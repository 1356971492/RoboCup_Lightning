local DSS_FLAG = flag.allow_dss + flag.dodge_ball

local shootGen = function(dist)
	return function()
		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - pos.theirGoal()):dir())
		return pos
	end
end



-- 射门点可调，以球与对方球门中心的连接为标准，可左右调整，单位为角度（0到180度）
local shootDir = function(p)
	return function()
		local goalPos = CGeoPoint:new_local(param.pitchLength/2,0)
		local goalDir = (goalPos-ball.pos()):dir()+math.pi*p/180
		return goalDir
	end 
end 





gPlayTable.CreatePlay{

firstState = "t",

["t"] = {
	switch = function()
		if bufcnt(player.toTargetDist("a")<50,10) then
			return "t_dribble"
		end

	end,

	a = task.goCmuRush(shootGen(150),_, _, DSS_FLAG),

	Goalie = task.goalie(),

	match = "[a]"
},


["t_dribble"] = {
	switch = function()
		if player.infraredCount("a")>10 then
			-- debugEngine:gui_debug_msg(ball.pos(),"wht  吸球完成")
			return "t_shoot"
		elseif bufcnt(true,120) then
			return "t"
		end

	end,

	a = task.goCmuRush(shootGen(100),_, _, flag.dribbling),
	
	Goalie = task.goalie(),

	match = "[a]"
},



["t_shoot"] = {
	switch = function()
		if  player.kickBall("a")  then
			-- debugEngine:gui_debug_msg(player.pos("a"),"wht  踢球完成")
			return "t"
		elseif bufcnt(true,180)	then
			return "t"
		end

	end,

	a = task.shoot(shootGen(100),shootDir(0)),
	
	Goalie = task.goalie(),

	match = "[a]"
},


name = "真实文件名",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
