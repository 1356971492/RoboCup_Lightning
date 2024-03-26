local DSS_FLAG = flag.allow_dss + flag.dodge_ball
local placePos = ball.placementPos()
local testPlacePos = CGeoPoint:new_local(1000,-2000)
local ballpos = ball.pos()
local ballposY = ball.posY()
local ballposX = ball.posX()

local toBallDir = function(role)
	return (ball.pos() - player.pos(role)):dir()
end
local ourKickOffPos = function() --点球时开球机器人所在的位置
	return function()
		local ballPos = ball.pos()
		return ballPos + Utils.Polar2Vector(400, math.pi)
	end
end
local OurPenaltyLeavePos = function(role) --点球时其他机器人所在的位置
	local dist1 = 800
	return function()
		local ballposX = ball.posX()
		debugEngine:gui_debug_msg(CGeoPoint:new_local(-1000, 0), "ballposX is  "..ballposX)
		if ballposX - dist1 < player.posX(role) then
		-- if 1 < 2 then
			return player.pos(role) + Utils.Polar2Vector(dist1 + player.posX(role) - ballposX, math.pi)
		else
			return player.pos(role)
		end
	end
end





--进攻方
gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {--初始化
	switch = function()
		if bufcnt(true, 1) then
			return "state1"
		end
	end,
	
	Leader = task.stop(),
	a      = task.stop(),
	b      = task.stop(),
	c      = task.stop(),
	d      = task.stop(),
	Goalie = task.stop(),
	match  = "{LGabcd}"
},
["state1"] = {--前往点球时的站位, 开球者站到开球位置， 其他球员站到球后一定距离
	switch = function()
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0, 0), ballposX)
		
	end,
	
	Leader = task.goCmuRush(ourKickOffPos("Leader"),dir.playerToBall,_,DSS_FLAG),
	a      = task.goCmuRush(OurPenaltyLeavePos("a"),dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(OurPenaltyLeavePos("b"),dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(OurPenaltyLeavePos("c"),dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(OurPenaltyLeavePos("d"),dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{LGabcd}"
},






name = "Mytest1",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}