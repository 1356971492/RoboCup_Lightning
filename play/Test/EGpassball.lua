--向固定点传球

local p = CGeoPoint:new_local(3000,1000)

gPlayTable.CreatePlay{

firstState = "t",

["t"] = {
	switch = function()
		-- if  player.kickBall("a")  then
		-- 	-- debugEngine:gui_debug_msg(player.pos("a"),"wht  踢球完成")
		-- 	return "t"
		-- elseif bufcnt(true,180)	then
		-- 	return "t"
		-- end

	end,

	a = task.touchKick(p,false),

	Goalie = task.goalie(),

	match = "[a]"
},





name = "EGpassball",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
