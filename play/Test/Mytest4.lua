local DSS_FLAG = flag.allow_dss + flag.dodge_ball
-- local placePos = ball.placementPos()
local testPlacePos = CGeoPoint:new_local(0, 0)
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

gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {
	switch = function()
	debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
	debugEngine:gui_debug_arc(testPlacePos,500,0,360,1)
	debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
	debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
	end,
	
	Leader = task.goCmuRush(),
	b = task.stop(),
	c = task.stop(),
	d = task.stop(),
	e = task.stop(),
	f = task.stop(),
	match = "{Lbcdef}"
},

-- ["state1"] = {
-- 	switch = function()
		
-- 	end,
-- 	-- a = task.goCmuRush(stopPos("a"), dir.playerToBall,_,DSS_FLAG),
-- 	match = "{a}"
-- },



name = "Mytest4",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}