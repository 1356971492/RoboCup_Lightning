local DSS_FLAG = flag.allow_dss + flag.dodge_ball
local placePos = ball.placementPos()
local ballpos = ball.pos()


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
local isLeaveBallPlace = function(role, dist1) 		--判断当前位置是否合法
	res = function()
		if dist1 == nil then
			dist1 = 650
		end
		local ans
		local playerPos = player.pos(role)
		local ballPos = ball.pos()
		-- local movePoint = ball.placementPos()
		local movePoint = placePos 								--测试时使用
		local seg = CGeoSegment:new_local(ballPos,movePoint)
		local intersectionP = seg:projection(playerPos)
		local distance = intersectionP:dist(playerPos)
		local isPrjon = seg:IsPointOnLineOnSegment(intersectionP)
		if distance < dist1 and isprjon then 					--距离直线小于dist1 并且投影在线段上
			return false
		elseif ballP:dist(playerP) < dist1 then			  --与球的距离小于dist1 
			return false
		elseif movePoint:dist(playerP) < dist1 then 	--与放置点的距离小于dist1
			return false
		else --如果都符合 返回机器人的位置
			return true
		end
		return ans
	end
	return res
end
local LeaveBallPlacePos = function(role, dist1)   --如果当前位置不合法 需要前往的位置
	-- local tempPoint = player.pos(role)
	local movePoint = function()
		local tempPoint = player.pos(role)
		if dist1 == nil then
			dist1 = 650
		end
		local playerP = player.pos(role)
		local ballP = ball.pos()

		-- local movePoint = ball.placementPos()
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
				return CGeoPoint:new_local(-2000, 2000)
			end
		else
			return tempPoint
		end
	end
	return movePoint
end
local AstandPos = function()
		local ballPlacePos = placePos
		local ballPlacePosX = placePos:x()
		local ipos
		if isLeaveBallPlace("a", 500)  then
		-- if 1 > 2  then
			if ballPlacePosX < -3000 then
				ipos = BackStandPos[1]
			elseif ballPlacePosX > 3000 then
				ipos = FrontStandPos[1]
			else 
				ipos = MiddleStandPos[1]
			end
		else 
			-- ipos = LeaveBallPlacePos("a", 500)
			ipos = LeaveBallPlacePos("a", 500)
		end
		return ipos
end
local BstandPos = function()
		local ballPlacePos = placePos
		local ballPlacePosX = placePos:x()
		local ballposY = ball.posY()
		local ipos
		if isLeaveBallPlace("b", 500) then
			if ballPlacePosX < -3000 then
				ipos = BackStandPos[2]
			elseif ballPlacePosX > 3000 then
				ipos = FrontStandPos[2]
			else 
				ipos = MiddleStandPos[2]
			end
		else 
			ipos = LeaveBallPlacePos("b", 500)
		end
	return ipos
end
local CstandPos = function()
		local ballPlacePos = placePos
		local ballPlacePosX = placePos:x()
		local ballposY = ball.posY()
		local ipos
		if isLeaveBallPlace("c", 500) then
			if ballPlacePosX < -3000 then
				ipos = BackStandPos[3]
			elseif ballPlacePosX > 3000 then
				ipos = FrontStandPos[3]
			else 
				ipos = MiddleStandPos[3]
			end
		else 
			ipos = LeaveBallPlacePos("c", 500)
		end
	return ipos
end
local DstandPos = function()
		local ballPlacePos = placePos
		local ballPlacePosX = placePos:x()
		local ballposY = ball.posY()
		local ipos
		if isLeaveBallPlace("d", 500) then
			if ballPlacePosX < -3000 then
				ipos = BackStandPos[4]
			elseif ballPlacePosX > 3000 then
				ipos = FrontStandPos[4]
			else 
				ipos = MiddleStandPos[4]
			end
		else 
			ipos = LeaveBallPlacePos("d", 500)
		end
	return ipos
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


local ballpos = ball.pos()
local ballposY = ball.posY()

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

["state0"] = {--跑到球的位置
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.toTargetDist("Leader") < 150, 10) then
			return "state1"
		end
	end,
	
	Leader = task.goCmuRush(pre2placeBall(), dir.playerToBall,_,DSS_FLAG + flag.our_ball_placement),
	a      = task.goCmuRush(AstandPos, dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(BstandPos, dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(CstandPos, dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(DstandPos, dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "[LGabcd]"
},

["state1"] = {--吸球
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.infraredCount("Leader")>10, 10) then
			return "state2"
		-- else
		-- 	return "state0"
		end
	end,

	Leader = task.goCmuRush(ball.pos(), dir.playerToBall,_,flag.dribbling + flag.our_ball_placement),
	a      = task.goCmuRush(AstandPos, dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(BstandPos, dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(CstandPos, dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(DstandPos, dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{a}"
},
["state2"] = { --转向
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if  math.abs((placePos - player.pos("Leader")):dir() - player.dir("Leader"))  < 0.04 then
			return "state3"
		end
	end,

	Leader = task.whirl2passBall("Leader", placePos),
	a      = task.goCmuRush(AstandPos, dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(BstandPos, dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(CstandPos, dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(DstandPos, dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{a}"
},

["state3"] = { --带球移动到目标位置
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(placePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		if bufcnt(player.toBallDist("Leader") > 1000, 10) then
			return "state0"
		end
	end,

	Leader = task.goCmuRush(PtestPlacePos("Leader"), toBallPlacePosDir,_,flag.dribbling + flag.our_ball_placement),
	a      = task.goCmuRush(AstandPos, dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(BstandPos, dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(CstandPos, dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(DstandPos, dir.playerToBall,_,DSS_FLAG),
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