--移动到固定点

--设置角色始终面向球 
local role2Dir = function()
	return function(role)
		return player.toBallDir(role)
	end 	
end


-- 设置固定点
local staticPos = CGeoPoint:new_local(500,-1000)





gPlayTable.CreatePlay{

firstState = "t",

["t"] = {
	switch = function()

	end,
	a = task.goSpeciPos(pos.specified(staticPos),role2Dir("a")),
	
	Goalie = task.goalie(),

	match = "{a}"
},




name = "EGgoSpeciPos",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
