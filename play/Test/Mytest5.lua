--测试对方放球时的跑位
local DSS_FLAG = flag.allow_dss + flag.dodge_ball
local placePos = ball.placementPos()
local testPlacePos = CGeoPoint:new_local(1000,-2000)
local ballpos = ball.pos()


local isLeaveBallPlace = function(role, dist1)  		--判断当前位置是否合法
	-- local playerP = player.pos(role)
	-- res = function()
		if dist1 == nil then
			dist1 = 650
		end
		local playerP = player.pos(role)
		local ballP = ball.pos()

		local movePoint = testPlacePos

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

		local movePoint = testPlacePos

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
local defendEnemyGen = function(role,num,dist1)
	return function()
		local enemyP = enemy.pos(num)
		local ipos = enemyP + Utils.Polar2Vector(dist1,(testPlacePos - enemyP):dir())
		return ipos
	end
end
local standPos = function(role, num)
	return function()
		local ballPlacePos = testPlacePos
		local ballPlacePosX = testPlacePos:x()
		local ipos
		-- local is = isLeaveBallPlace(1, 500)()
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),tostring(isLeaveBallPlace(role, 500)))
		if isLeaveBallPlace(role, 500) then
		-- if 1 > 2  then
			ipos = defendEnemyGen(role,num,500)()
		else 
			ipos = LeaveBallPlacePos(role, 500)()
		end
		return ipos
	end
end





local ballpos = ball.pos()
local ballposY = ball.posY()

local toBallDir = function(role)
	return (ball.pos() - player.pos(role)):dir()
end
local toBallPlacePosDir = function(role)
	return (testPlacePos - player.pos(role)):dir()
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


gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {--必要的初始化 不然会导致goCmuRush的位置出现问题
	switch = function()
		debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
		debugEngine:gui_debug_arc(testPlacePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),tostring(isLeaveBallPlace("b", 500)))
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),tostring(standPos("b",2)():x()).."  "..tostring(standPos("b",2)():y()))
		if bufcnt(true, 1) then
			return "state1"
		end
	end,
	
	Leader = task.goCmuRush(standPos("Leader",0)(), dir.playerToBall,_,DSS_FLAG + flag.our_ball_placement),
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
		debugEngine:gui_debug_arc(testPlacePos,500,0,360,1)
		debugEngine:gui_debug_line(testPlacePos1(),testBallPos1(),1)
		debugEngine:gui_debug_line(testPlacePos2(),testBallPos2(),1)
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),tostring(isLeaveBallPlace("b", 500)))
		-- debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),tostring(standPos("b",2)():x()).."  "..tostring(standPos("b",2)():y()))
		if bufcnt(player.toTargetDist("Leader") < 150, 10) then
			-- return "state2"
		end
	end,
	
	Leader = task.goCmuRush(standPos("Leader",0), dir.playerToBall,_,DSS_FLAG + flag.our_ball_placement),
	a      = task.goCmuRush(standPos("a",1), dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(standPos("b",2), dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(standPos("c",3), dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(standPos("d",4), dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goalie(),
	match  = "{LGabcd}"
},


name = "Mytest5",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}