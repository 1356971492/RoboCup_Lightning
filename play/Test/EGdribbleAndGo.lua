--吸球后带球移动（或转向）

local DSS_FLAG = flag.allow_dss + flag.dodge_ball

local shootGen = function(dist)
	return function()
		local pos = ball.pos() + Utils.Polar2Vector(dist,(ball.pos() - pos.theirGoal()):dir())
		return pos
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
			return "t_backMove"
		elseif bufcnt(true,120)	then
			return "t"
		end

	end,

	a = task.goCmuRush(shootGen(100),_, _, flag.dribbling),
	
	Goalie = task.goalie(),

	match = "[a]"
},



["t_backMove"] = {
	switch = function()
		if bufcnt(player.infraredCount("a")>1,100) then
			-- debugEngine:gui_debug_msg(ball.pos(),"wht  后退100帧的距离")
			return "t"
		elseif bufcnt(true,120)	then
			return "t"	
		end

	end,

	a = task.goCmuRush(shootGen(250),_, _, flag.dribbling),
	
	Goalie = task.goalie(),

	match = "[a]"
},

name = "EGdribbleAndGo",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
