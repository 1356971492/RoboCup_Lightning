local DSS_FLAG = flag.allow_dss + flag.dodge_ball
-- local placePos = ball.placementPos()
local testPlacePos = CGeoPoint:new_local(0, 0)

local PtestPlacePos = function(role) --到放球位置， 已经吸住球后使用
	local testPlacePos = CGeoPoint:new_local(0, 0)
	local ballpos = ball.pos()
	local pos = function()
		local idir = (player.pos(role) - ballpos):dir()
		return testPlacePos + Utils.Polar2Vector(param.playerFrontToCenter, idir)
	end
	return pos
end


local ballpos = ball.pos()
local ballposY = ball.posY()

local  toBallDir = function(role)
	return (ball.pos() - player.pos(role)):dir()
end

local testPlacePos1 = function()
	local pos = testPlacePos + Utils.Polar2Vector(500, (ball.pos() - testPlacePos):dir() + math.pi/2 )
	return pos
end
local testPlacePos2 = function()
	local pos = testPlacePos + Utils.Polar2Vector(500, (ball.pos() - testPlacePos):dir() - math.pi/2 )
	return pos
end
local testBallPos1 = function()
	local pos = ball.pos() + Utils.Polar2Vector(500, (testPlacePos - ball.pos()):dir() - math.pi/2 )
	return pos
end
local testBallPos2 = function()
	local pos = ball.pos() + Utils.Polar2Vector(500, (testPlacePos - ball.pos()):dir() + math.pi/2 )
	return pos
end
local pre2placeBall = function() --到球的位置， 未吸球时使用
	-- local ballposY = ball.posY()
	local pos = function()
		local ballposY = ball.posY()
		if ballposY > 0 then
			return ballpos + Utils.Polar2Vector(-50, math.pi / 2)
		else
			return ballpos + Utils.Polar2Vector(50, math.pi / 2)
		end
	end
	return pos
end

gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {--跑到球的位置
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(testPlacePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.toTargetDist("Leader") < 150, 10) then
			return "state1"
		end
	end,
	
	Leader = task.goCmuRush(pre2placeBall(), dir.playerToBall,_,DSS_FLAG),
	b      = task.stop(),
	c      = task.stop(),
	d      = task.stop(),
	e      = task.stop(),
	Goalie = task.goalie(),
	match  = "{GbcdeL}"
},

["state1"] = {--吸球
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(testPlacePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.infraredCount("Leader")>10, 10) then
			return "state3"
		-- else
		-- 	return "state0"
		end
	end,

	Leader = task.goCmuRush(ball.pos(), dir.playerToBall,_,flag.dribbling),
	b      = task.stop(),
	c      = task.stop(),
	d      = task.stop(),
	e      = task.stop(),
	Goalie = task.goalie(),
	match  = "{a}"
},
["state2"] = { --转向
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(testPlacePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.toTargetDir("Leader") < 0.1, 10) then
			return "state3"
		end
	end,

	Leader = task.whirl2passBall("Leader", "testPlacePos"),
	b      = task.stop(),
	c      = task.stop(),
	d      = task.stop(),
	e      = task.stop(),
	Goalie = task.goalie(),
	match  = "{a}"
},

["state3"] = { --带球移动到目标位置
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(testPlacePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.toBallDist("Leader") > 1000, 10) then
			return "state0"
		end
	end,

	Leader = task.goCmuRush(PtestPlacePos("Leader"), dir.playerToBall,_,flag.dribbling),
	b      = task.stop(),
	c      = task.stop(),
	d      = task.stop(),
	e      = task.stop(),
	Goalie = task.goalie(),
	match  = "{a}"
},



name = "Mytest1",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}