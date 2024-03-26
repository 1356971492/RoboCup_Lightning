function whirl2passBall (role1, role2, whirlSpeed, pre1) -- role1: 机器人自身 role2: 旋转目标机器人或点 whrlSpeed: 旋转速度 pre: 旋转精度
	local Tpre
	local iwhirlSpeed
	if pre1 ~= nil then
		Tpre = pre1
	else
		Tpre = 0.04
	end
	if whirlSpeed ~= nil then
		iwhirlSpeed = whirlSpeed
	else 
		iwhirlSpeed = 3
	end
	local spdW = function() --旋转速度大小及方向
		local PlayerDir = player.dir(role1)
		local toTargetDir --到目标点的角度
		if type(role2) == "userdata" then --判断目标是点还是球员
			toTargetDir = (role2 - player.pos(role1)):dir()
		else
			toTargetDir = (player.pos(role2) - player.pos(role1)):dir()
		end
		 
		if math.abs(toTargetDir - PlayerDir) > Tpre then
			-- if PlayerDir < 0 then
				return iwhirlSpeed
			-- else 
				-- return -iwhirlSpeed
			-- end
		else
			return 0
		end
	end
	local spdX = function() --X方向上的速度为0
		return 0
	end
	local spdY = function() --Y方向上的速度为0
		return 0
	end
	local idir = function()
		return player.dir(role1)
	end
	local ikick = function()
		return 0
	end
	local ipre = pre.low
	-- local ipre = function()
	-- 	return pre.low()
	-- end
	local ikp = function()
		return 0
	end
	local icp = function()
		return 0
	end
	local iflag = flag.allow_dss + flag.dribbling
	local mexe, mpos = Speed{speedX = spdX, speedY = spdY, speedW = spdW} 
	return {mexe, mpos, ikick, idir, ipre, ikp, icp, iflag}
end