local Leader_standPos = CGeoPoint:new_local(0,0)
local Assister_standPos = CGeoPoint:new_local(-param.pitchLength  / 3.0, 0)
local shootPos = CGeoPoint:new_local(2000, 2000)

local MAXplayer = 3



local shootGen = function(dist)
	return function()
		local goalPos = CGeoPoint(param.pitchLength/2,0)
		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
		return pos
	end
end
local passBallGen = function(dist, playerPos)
	return function()
		local goalPos = CGeoPoint(param.pitchLength/2,0)
		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - playerPos):dir())
		return pos
	end
end
local defendBallGen = function(dist)--针对球的位置进行防守
	return function()
		local ourGoalPos = CGeoPoint(-param.pitchLength/2,0)
		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - ourGoalPos):dir())
		return pos
	end
end
local defendEnemyGen = function(dist, num)--针对敌方球员位置进行防守
	return function()
		local ourGoalPos = CGeoPoint(-param.pitchLength/2,0)
		local pos = enemy.pos(num) + Utils.Polar2Vector(dist,(ourGoalPos - enemy.pos(num)):dir())

		return pos
	end 
end

local DSS_FLAG = flag.allow_dss + flag.dodge_ball

local JUDGE = {
	BallInField = function()
		local x = ball.posX()
		local y = ball.posY()
		local mx = param.pitchLength
		local my = param.pitchWidth
		if not ball.valid() then
			return false
		end
		if x > mx / 2.0 or x < -mx / 2.0 or y > my / 2.0 or y < -my / 2.0 then
			return false
		end
		if math.abs(y) < param.penaltyWidth/2 and x > (param.pitchLength/2 - param.penaltyDepth) then
			return false
		end
		return true
	end,
	EnemyGetBall = function ()--敌方是否持球
		for i=0,MAXplayer - 1 do
			if (ball.pos() - enemy.pos(i)):mod() < 200 then
				return true
			end
		end
		return false
	end,
}

gPlayTable.CreatePlay{

firstState = "run_to_start",

["run_to_start"] = {
	switch = function()
		if bufcnt(JUDGE.BallInField(),10) then
			return "run_to_ball"
		end
	end,
	Leader = task.goCmuRush(Leader_standPos, _, _, DSS_FLAG),
	Assister = task.goCmuRush(Assister_standPos,_,_,DSS_FLAG),
	Goalie = task.goalie(),
	match = "[LA]"
},
["run_to_ball"] = {
	switch = function()
		if bufcnt(player.toTargetDist("Leader")<50,10) then
			return "try_dribble"
		end
		if bufcnt(JUDGE.EnemyGetBall(), 20) then
			return "defend_state"
		end
		if bufcnt(not JUDGE.BallInField(),5) then
			return "run_to_start"
		end
	end,
	Leader = task.goCmuRush(shootGen(150), _, _, DSS_FLAG),
	Assister = task.waitForAttack(),
	Goalie = task.goalie(),
	match = "[LA]"
},
["try_dribble"] = {
	switch = function()
		if bufcnt(player.toTargetDist("Leader")<50,10) then
			return "try_shoot"
		-- elseif bufcnt(player.posX("Leader") < 0, 10) then
		-- 	return "try_passBall"
		end
		if bufcnt(JUDGE.EnemyGetBall(), 20) then
			return "defend_state"
		end
		if bufcnt(not JUDGE.BallInField(),5) then
			return "run_to_start"
		end
	end,
	Leader = task.goCmuRush(shootGen(150),_,_,flag.dribbling),
	Assister = task.waitForAttack(),
	Goalie = task.goalie(),
	match = "[LA]"
},
["try_passBall"] = {
	switch = function()
		if bufcnt(player.infraredCount("Assister")>10, 10) then
			return "try_shoot"
		else 
			return "run_to_ball"
		end
		if bufcnt(JUDGE.EnemyGetBall(), 20) then
			return "defend_state"
		end
		if bufcnt(not JUDGE.BallInField(),5) then
			return "run_to_start"
		end
	end,
	Leader = task.touchKick(player.pos("Assister"),false),
	Assister = task.goCmuRush(shootGen(150),_,_,flag.dribbling),
	Goalie = task.goalie(),
	match = "[LA]"
},
["try_shoot"] = {
	switch = function()
		if bufcnt(JUDGE.EnemyGetBall(), 20) then
			return "defend_state"
		end
		if bufcnt(not JUDGE.BallInField(),5) then
			return "run_to_start"
		end
	end,
	Leader = task.shoot(shootGen(100)),
	Assister = task.waitForAttack(),
	Goalie = task.goalie(),
	match = "[LA]"
},
["defend_state"] = {
	switch = function()
		if bufcnt(not JUDGE.EnemyGetBall(), 20) then
			return "run_to_ball"
		end
		if bufcnt(not JUDGE.BallInField(),5) then
			return "run_to_start"
		end
	end,
	Leader = task.goCmuRush(defendEnemyGen(500, 1), _, _, DSS_FLAG),
	Assister = task.goCmuRush(defendEnemyGen(500, 2),_,_,DSS_FLAG),
	Goalie = task.goalie(),
	match = "[LA]"
},


name = "3V3Test",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}