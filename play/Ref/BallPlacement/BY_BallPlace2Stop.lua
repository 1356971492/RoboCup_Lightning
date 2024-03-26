local DSS_FLAG = flag.allow_dss + flag.dodge_ball
local placePos = ball.placementPos()
local testPlacePos = CGeoPoint:new_local(1000,-2000)
local ballpos = ball.pos()
local ballposY = ball.posY()


local BackStandPos  = { -- 后场站位
	CGeoPoint:new_local(-3000,2100),
	CGeoPoint:new_local(-3000,1000),
	CGeoPoint:new_local(-3000,-1000),
	CGeoPoint:new_local(-3000,-2100),
}
local MiddleStandPos  = { -- 中场站位
	CGeoPoint:new_local(0,2100),
	CGeoPoint:new_local(0,1000),
	CGeoPoint:new_local(0,-1000),
	CGeoPoint:new_local(0,-2100),
}
local FrontStandPos  = { -- 前场站位
	CGeoPoint:new_local(3000,2100),
	CGeoPoint:new_local(3000,1000),
	CGeoPoint:new_local(3000,-1000),
	CGeoPoint:new_local(3000,-2100),
}
local backPos = function(role)
	return function()
		local dist
		if vision:getNextRefereeMsg() == "OurIndirectKick" then
			dist = 200
		else 
			dist = 620
		end
		local ipos = ballpos + Utils.Polar2Vector(dist,(player.pos(role) - ballpos):dir())
		return ipos
	end
end
local isLeaveBallPlace = function(role, dist1)  		--判断当前位置是否合法
	-- local playerP = player.pos(role)
	-- res = function()
		if dist1 == nil then
			dist1 = 650
		end
		local playerP = player.pos(role)
		local ballP = ball.pos()

		local movePoint = placePos

		local seg = CGeoSegment:new_local(ballP, movePoint)
		local intersectionP = seg:projection(playerP)

		local distance = intersectionP:dist(playerP)
		local isprjon = seg:IsPointOnLineOnSegment(intersectionP)
		if distance < dist1 and isprjon then  				  --距离直线小于dist1 并且投影在线段上
			return false
		elseif ballP:dist(playerP) < dist1 then			    --与球的距离小于dist1 
			return false
		elseif movePoint:dist(playerP) < dist1 then 	  --与放置点的距离小于dist1
			return false
		else 																						--如果都符合 返回true
			return true
		end
	-- end
	-- return res
end

local LeaveBallPlacePos = function(role, dist1)     --如果当前位置不合法 需要前往的位置
	-- local tempPoint = player.pos(role)
	local movePoint = function()
		local tempPoint = player.pos(role)
		if dist1 == nil then
			dist1 = 650
		end
		local playerP = player.pos(role)
		local ballP = ball.pos()

		local movePoint = placePos

		local seg = CGeoSegment:new_local(ballP, movePoint)
		local intersectionP = seg:projection(playerP)

		local distance = intersectionP:dist(playerP)
		local isprjon = seg:IsPointOnLineOnSegment(intersectionP)
		if distance < dist1 and isprjon then 						--距离直线小于dist1 并且投影在线段上
			tempPoint = intersectionP + Utils.Polar2Vector(dist1, (playerP - intersectionP):dir())
		elseif ballP:dist(playerP) < dist1 then 				--与球的距离小于dist1 
			tempPoint = ballP + Utils.Polar2Vector(dist1, (playerP - ballP):dir())
		elseif movePoint:dist(playerP) < dist1 then 		--与放置点的距离小于dist1
			tempPoint = movePoint + Utils.Polar2Vector(dist1, (playerP - movePoint):dir())
		else 																						--如果都符合 返回机器人的位置
			tempPoint = player.pos(role)
		end

		debugEngine:gui_debug_line(CGeoPoint(param.pitchLength / 2-param.penaltyDepth-500,-param.penaltyWidth/2-500),CGeoPoint(param.pitchLength / 2-param.penaltyDepth-500,param.penaltyWidth/2+500))
		if tempPoint:x()>param.pitchLength / 2-param.penaltyDepth-500 and math.abs(tempPoint:y())<param.penaltyWidth/2+500 then
				
			if tempPoint:x() > 0 then
				return CGeoPoint:new_local(-2000, 2000)
			else
				return CGeoPoint:new_local(2000, 2000)
			end	
		end

		if math.abs(tempPoint:x()) > param.pitchLength / 2 or math.abs(tempPoint:y()) > param.pitchWidth / 2 then
			if tempPoint:x() > 0 then
				return CGeoPoint:new_local(2000, 2000)
			else
				return CGeoPoint:new_local(-2000, 2000) -- BUG中机器人前往的坐标
			end
		else
			return tempPoint
		end
	end
	return movePoint
end
local standPos = function(role, num)
	return function()
		local ballPlacePos = placePos
		local ballPlacePosX = placePos:x()
		local ipos
		-- local is = isLeaveBallPlace(1, 500)()
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),tostring(isLeaveBallPlace(role, 500)))
		if isLeaveBallPlace(role, 500) then
		-- if 1 > 2  then
			if ballPlacePosX < -3000 then
				ipos = BackStandPos[num]
			elseif ballPlacePosX > 3000 then
				ipos = FrontStandPos[num]
			else 
				ipos = MiddleStandPos[num]
			end
		else 
			ipos = LeaveBallPlacePos(role, 500)()
		end
		return ipos
	end
end

local PtestPlacePos = function(role) --到放球位置， 已经吸住球后使用
	local ballpos = ball.pos()
	local pos = function()
		local idir = (player.pos(role) - ballpos):dir()
		return placePos + Utils.Polar2Vector(param.playerFrontToCenter, idir)
	end
	
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




local toBallDir = function(role)
	return (ball.pos() - player.pos(role)):dir()
end
local toBallPlacePosDir = function(role)
	return (placePos - player.pos(role)):dir()
end

local testPlacePos1 = function()
	local pos = placePos + Utils.Polar2Vector(500, (ball.pos() - placePos):dir() + math.pi/2 )
	return pos
end
local testPlacePos2 = function()
	local pos = placePos + Utils.Polar2Vector(500, (ball.pos() - placePos):dir() - math.pi/2 )
	return pos
end
local testBallPos1 = function()
	local pos = ball.pos() + Utils.Polar2Vector(500, (placePos - ball.pos()):dir() - math.pi/2 )
	return pos
end
local testBallPos2 = function()
	local pos = ball.pos() + Utils.Polar2Vector(500, (placePos - ball.pos()):dir() + math.pi/2 )
	return pos
end


gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {--必要的初始化 不然会导致goCmuRush的位置出现问题
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),tostring(isLeaveBallPlace("b", 500)))
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),tostring(standPos("b",2)():x()).."  "..tostring(standPos("b",2)():y()))
		if bufcnt(true, 1) then
			return "state1"
		end
	end,
	
	Leader = task.goCmuRush(pre2placeBall(), dir.playerToBall,_,DSS_FLAG + flag.our_ball_placement),
	a      = task.goCmuRush(standPos("a",1)(), dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(standPos("b",2)(), dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(standPos("c",3)(), dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(standPos("d",4)(), dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{LGabcd}"
},
["state1"] = {--跑到球的位置
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),tostring(isLeaveBallPlace("b", 500)))
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),tostring(standPos("b",2)():x()).."  "..tostring(standPos("b",2)():y()))
		if bufcnt(player.toTargetDist("Leader") < 150, 10) then
			return "state2"
		end
	end,
	
	Leader = task.goCmuRush(pre2placeBall(), dir.playerToBall,_,DSS_FLAG + flag.our_ball_placement),
	a      = task.goCmuRush(standPos("a",1), dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(standPos("b",2), dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(standPos("c",3), dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(standPos("d",4), dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{LGabcd}"
},

["state2"] = {--吸球
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.infraredCount("Leader")>10, 10) then
			return "state3"
		elseif bufcnt(player.toBallDist("Leader") > 500, 10) then
			return "state1"
		end
	end,

	Leader = task.goCmuRush(ball.pos(), dir.playerToBall,_,flag.dribbling + flag.our_ball_placement),
	a      = task.goCmuRush(standPos("a",1), dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(standPos("b",2), dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(standPos("c",3), dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(standPos("d",4), dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{a}"
},
["state3"] = { --转向
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if  math.abs((placePos - player.pos("Leader")):dir() - player.dir("Leader"))  < 0.04 then
			return "state4"
		end
	end,

	Leader = task.whirl2passBall("Leader", placePos),
	a      = task.goCmuRush(standPos("a",1), dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(standPos("b",2), dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(standPos("c",3), dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(standPos("d",4), dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{a}"
},

["state4"] = { --带球移动到目标位置
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.toTargetDist("Leader") < 100, 100) then
			return "state5"
		elseif bufcnt(player.toBallDist("Leader") > 500, 10) then
			return "state1"
		end
	end,

	Leader = task.goCmuRush(PtestPlacePos("Leader"), player.toTargetDir(placePos, "Leader"),_,flag.dribbling + flag.our_ball_placement),
	a      = task.goCmuRush(standPos("a",1), dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(standPos("b",2), dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(standPos("c",3), dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(standPos("d",4), dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{a}"
},
["state5"] = { --退后
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt (cond.ourBallPlace() and ballpos:dist(placePos) > 100, 100) then
			return "state1"
		elseif cond.isGameOn() then
			return "finish"
		end
	end,

	Leader = task.goCmuRush(backPos("Leader"), player.toTargetDir(placePos, "Leader"),_,flag.our_ball_placement),
	a      = task.goCmuRush(standPos("a",1), dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(standPos("b",2), dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(standPos("c",3), dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(standPos("d",4), dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{a}"
},



name = "BY_BallPlace2Stop",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}