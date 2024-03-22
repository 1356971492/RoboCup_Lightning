
module(..., package.seeall)

--~		Play中统一处理的参数（主要是开射门）
--~		1 ---> task, 2 ---> matchpos, 3---->kick, 4 ---->dir,
--~		5 ---->pre,  6 ---->kp,       7---->cp,   8 ---->flag
------------------------------------- 射门相关的skill ---------------------------------------
-- TODO
------------------------------------ 跑位相关的skill ---------------------------------------
--~ p为要走的点,d默认为射门朝向
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

function inter()
	local ipos = function()
		local res
		if ball.velMod() < 500 then
			--str = "22"
			res = ball.pos() + Utils.Polar2Vector(-100, ball.toTheirGoalDir())
		else 
			--str = "33"
			res = ball.pos() + Utils.Polar2Vector(ball.velMod() * 0.3, ball.vel():dir())
		end
		return res
	end
	local idir = function(runner)
		local res
		local str = "11"
		if ball.velMod() < 500 then
			str = "22"
			res = ball.toTheirGoalDir()
		else 
			str = "33"
			res = (ball.pos() - player.pos(runner)):dir()
		end
		debugEngine:gui_debug_msg(CGeoPoint:new_local(0, 0),"debug!"..str)
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end	

function marking(x1, x2, y1, y2)
	local ourGoal = CGeoPoint:new_local(-param.pitchLength/2.0, 0)
	local drawDebug = function()
		local p1 = CGeoPoint:new_local(x1,y1)
		local p2 = CGeoPoint:new_local(x1,y2)
		local p3 = CGeoPoint:new_local(x2,y2)
		local p4 = CGeoPoint:new_local(x2,y1)
		debugEngine:gui_debug_line(p1,p2,4)
		debugEngine:gui_debug_line(p2,p3,4)
		debugEngine:gui_debug_line(p3,p4,4)
		debugEngine:gui_debug_line(p4,p1,4)
	end
	local checknum = function()
		drawDebug()
		local between = function(a, min, max)
			if a > min and a < max then
				return true
			end
			return false
		end
		local num = -1
		for i=0,param.maxPlayer-1 do
			if enemy.valid(i) and between(enemy.posX(i), x1, x2) and between(enemy.posY(i), y1, y2) then
				-- return i
				num = i
			-- debugEngine:gui_debug_msg(CGeoPoint:new_local(-1000, 2000 - 200 * (i + 7)),enemy.valid(i) and "True" or "False"
			end
		end
		return num
	end
	local ipos = function()
		local enemyPos
		num = checknum()
		enemyPos = enemy.pos(num)
		if num < 0 then
			enemyPos = CGeoPoint:new_local((x1 + x2) / 2.0, (y1 + y2) / 2.0)
		end
		local res
		local l = (ourGoal - enemyPos):mod() * 0.4
		res = enemyPos + Utils.Polar2Vector(l,(ourGoal - enemyPos):dir())
		return res
	end
	local idir = function()
		local res
		local enemyPos
		num = checknum()
		enemyPos = enemy.pos(num)
		if num < 0 then
			enemyPos = CGeoPoint:new_local((x1 + x2) / 2.0, (y1 + y2) / 2.0)
		end
		res = (enemyPos - ourGoal):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function attack()
	local ipos = function(runner)
		local res
		res = ball.pos() + Utils.Polar2Vector(-140, ball.toTheirGoalDir())
		return res
	end
	local idir = function(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function waitForAttack()
	local checkAttacker = function(runner)
		num = -1
		 for i = 0, param.maxPlayer - 1 do
		 	if player.valid(i) and (ball.pos() - player.pos(i)):mod() < 1000 and i ~= runner then
		 		debugEngine:gui_debug_msg(CGeoPoint:new_local(0,2000),i)
		 		return i
		 	end
		 end
		 return num
	end
	local ipos = function(runner)
		num = checkAttacker(runner)
		local res
		local x = player.posX(num)
		local y = player.posY(num)
		if x > 0 then
			res = CGeoPoint:new_local(param.pitchLength / 2.0 - x, -y)
		else
			res = CGeoPoint:new_local(param.pitchLength / 2.0 - math.abs(x), -y)
		end
		return res
	end
	local idir = function(runner)
		num = checkAttacker(runner)
		local res
		res = (ball.pos() - player.pos(runner)):dir()
		return res
	end
	local mexe, mpos = GoCmuRush{pos = ipos, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function goalie()
	local mexe, mpos = Goalie()
	return {mexe, mpos}
end
function touch()
	local ipos = pos.ourGoal()
	local mexe, mpos = Touch{pos = ipos}
	return {mexe, mpos}
end
function touchKick(p,ifInter)
	local ipos = p or pos.theirGoal()
	local idir = function(runner)
		return (ipos - player.pos(runner)):dir()
	end
	local mexe, mpos = Touch{pos = ipos, useInter = ifInter}
	return {mexe, mpos, kick.flat, idir, pre.low, cp.full, cp.full, flag.nothing}
end
function goSpeciPos(p, d, f, a) -- 2014-03-26 增加a(加速度参数)
	local idir
	local iflag
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end

	if f ~= nil then
		iflag = f
	else
		iflag = 0
	end

	local mexe, mpos = SmartGoto{pos = p, dir = idir, flag = iflag, acc = a}
	return {mexe, mpos}
end

function goSimplePos(p, d, f)
	local idir
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end

	if f ~= nil then
		iflag = f
	else
		iflag = 0
	end

	local mexe, mpos = SimpleGoto{pos = p, dir = idir, flag = iflag}
	return {mexe, mpos}
end

function runMultiPos(p, c, d, idir, a)
	if c == nil then
		c = false
	end

	if d == nil then
		d = 20
	end

	if idir == nil then
		idir = dir.shoot()
	end

	local mexe, mpos = RunMultiPos{ pos = p, close = c, dir = idir, flag = flag.not_avoid_our_vehicle, dist = d, acc = a}
	return {mexe, mpos}
end

--~ p为要走的点,d默认为射门朝向
function goCmuRush(p, d, a, f, r, v)
	local idir
	if d ~= nil then
		idir = d
	else
		idir = dir.shoot()
	end
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos}
end

function forcekick(p,d,chip,power)
	local ikick = chip and kick.chip or kick.flat
	local ipower = power and power or 8000
	local idir = d and d or dir.shoot()
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.forcekick}
end

function shoot(p,d,chip,power)
	local ikick = chip and kick.chip or kick.flat
	local ipower = power and power or 8000
	local idir = d and d or dir.shoot()
	local mexe, mpos = GoCmuRush{pos = p, dir = idir, acc = a, flag = f,rec = r,vel = v}
	return {mexe, mpos, ikick, idir, pre.low, kp.specified(ipower), cp.full, flag.nothing}
end
------------------------------------ 防守相关的skill ---------------------------------------
-- TODO
----------------------------------------- 其他动作 --------------------------------------------

-- p为朝向，如果p传的是pos的话，不需要根据ball.antiY()进行反算
function goBackBall(p, d)
	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = flag.dodge_ball}
	return {mexe, mpos}
end

-- 带避车和避球
function goBackBallV2(p, d)
	local mexe, mpos = GoCmuRush{ pos = ball.backPos(p, d, 0), dir = ball.backDir(p), flag = bit:_or(flag.allow_dss,flag.dodge_ball)}
	return {mexe, mpos}
end

function stop()
	local mexe, mpos = Stop{}
	return {mexe, mpos}
end

function continue()
	return {["name"] = "continue"}
end

------------------------------------ 测试相关的skill ---------------------------------------

function openSpeed(vx, vy, vdir)
	local spdX = function()
		return vx
	end

	local spdY = function()
		return vy
	end
	
	local spdW = function()
		return vdir
	end

	local mexe, mpos = OpenSpeed{speedX = spdX, speedY = spdY, speedW = spdW}
	return {mexe, mpos}
end

function speed(vx, vy, vdir, f)
	local ikick = kick.none
	local idir = dir.specified(0)
	local ipre = pre.specified(10)
	local ikp = kp.specified(1000)
	local icp = cp.specified(1000)
	local iflag = f or flag.nothing
	local spdX = function()
		return vx
	end

	local spdY = function()
		return vy
	end
	
	local spdW = function()
		return vdir
	end

	local mexe, mpos = Speed{speedX = spdX, speedY = spdY, speedW = spdW}
	return {mexe, mpos, ikick, idir, ipre, ikp, icp, iflag}
end
