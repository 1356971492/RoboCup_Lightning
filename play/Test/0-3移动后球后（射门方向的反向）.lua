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


	end,

	a = task.goCmuRush(shootGen(150),_, _, DSS_FLAG),

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