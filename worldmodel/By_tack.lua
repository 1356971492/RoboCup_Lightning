module(..., package.seeall)

function whirl2passBall (role1, role2, whirlSpeed, pre) -- role1: 机器人自身 role2: 旋转目标机器人或点 whrlSpeed: 旋转速度 pre: 旋转精度
	local ipre
	local iwhirlSpeed
	if pre ~= nil then
		ipre = pre
	else
		ipre = 0.04
	end
	if whirlSpeed ~= nil then
		iwhirlSpeed = whirlSpeed
	else 
		iwhirlSpeed = 3
	end
	local spdW = function() --旋转速度
		local PlayerDir = player.dir(role)
		local toTargetDir --到目标点的角度
		if type(role2) == "userdata" then --判断目标是点还是球员
			toTargetDir = (role2 - player.pos(role1)):dir()
		else
			toTargetDir = (player.pos(role2) - player.pos(role1)):dir()
		end
		if math.abs(toTargetDir - PlayerDir) < pre then
			if toTargetDir - PlayerDir < 0 then
				return whirlSpeed
			else 
				return -whirlSpeed
			end
		else
			return 0
		end
	end
	local idir = function()
		return player.dir(role1)
	end
	local ikick = function()
		return 0
	end
	local ikp = function()
		return 0
	end
	local icp = function()
		return 0
	end
	local iflag = function()
		return flag.allow_dss + flag.dribbling
	end

	local mexe, mpos = OpenSpeed{speedX = spdX, speedY = spdY, speedW = spdW} 
	return {mexe, mpos, ikick, idir, pre.low, ikp, icp, iflag}
end