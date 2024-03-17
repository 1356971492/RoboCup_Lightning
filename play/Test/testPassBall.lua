local BeginPos = CGeoPoint:new_local(0, 0)
local DSS_FLAG = flag.allow_dss + flag.dodge_ball
local PassBallDir = function()
	local res = (player.pos("b") - player.pos("a")):dir()
	return res
end
local ReceiveBallDir = function()
	local res = (ball.pos() - player.pos(1)):dir()
	return res
end
local passGen = function(dist)
	return function()
		local playerbPos = player.pos(1)
		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - playerbPos):dir())
		return pos
	end
end
local shootGen = function(dist)
	return function()
		local goalPos = CGeoPoint(param.pitchLength/2,0)
		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - goalPos):dir())
		return pos
	end
end
function passball(p,ifInter)
	local ipos = p or pos.theirGoal()
	local idir = function(runner)
		return (ipos - player.pos(runner)):dir()
	end
	local mexe, mpos = Touch{pos = ipos, useInter = ifInter}
	return {mexe, mpos, kick.flat, idir, pre.specified(3), cp.full, cp.full, flag.nothing}
end
gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {
	switch = function()
		if bufcnt(player.toTargetDist("a")<50, 20) then
			return "state1"
		end
	end,
	a = task.goCmuRush(passGen(150),PassBallDir,_,DSS_FLAG),
	b = task.goCmuRush(BeginPos,ReceiveBallDir),
	match = "{ab}"
},
["state1"] = {
	switch = function()
		if bufcnt(player.kickBall("a"), 5) then
			return "state2"
		end
	end,
	a = passball(player.pos(1),true),
	b = task.goCmuRush(BeginPos,ReceiveBallDir,_,DSS_FLAG),
	match = "{ab}"
},
["state2"] = {
	switch = function()
		if bufcnt(player.toBallDist("b") < 50, 10) then
			return "state3"
		elseif bufcnt(player.toBallDist("b") > 1000, 10) then
			return "state0"
		end
	end,
	a = task.stop,
	b = task.goCmuRush(BeginPos,ReceiveBallDir,_,flag.dribbling),
	match = "{ab}"
},
["state3"] = {
	switch = function()
		
	end,
	a = task.stop,
	b = task.goCmuRush(BeginPos,_,_,flag.dribbling),
	match = "{ab}"
},



name = "testPassBall",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}