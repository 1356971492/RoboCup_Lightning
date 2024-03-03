--直接吸球

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
			-- debugEngine:gui_debug_msg(ball.pos(),"wht  吸球完成")
			return "t"
		elseif bufcnt(true,120) then
			return "t"
		end

	end,

	a = task.goCmuRush(shootGen(100),_, _, flag.dribbling),
	
	Goalie = task.goalie(),

	match = "[a]"
},


name = "EGdirectDribble",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}