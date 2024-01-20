local testPos  = {
	CGeoPoint:new_local(0,0),
	CGeoPoint:new_local(1000,0),
	CGeoPoint:new_local(1000,-1000),
	CGeoPoint:new_local(-1000,1000),
}
local DEBUG_SWITCH = true
local number = 123
local DEBUG_FUNC = function()
	debugEngine:gui_debug_x(CGeoPoint:new_local(2000,2500))
	debugEngine:gui_debug_x(CGeoPoint:new_local(2000,3000))
	debugEngine:gui_debug_x(CGeoPoint:new_local(2500,2000))
	debugEngine:gui_debug_x(CGeoPoint:new_local(3000,2000))
	debugEngine:gui_debug_msg(CGeoPoint:new_local(2500,2500),number..' '..type(number),5)
	debugEngine:gui_debug_x(enemy.pos(0))
	debugEngine:gui_debug_msg(enemy.pos(1),"enemy!!",6)
	debugEngine:gui_debug_msg(CGeoPoint:new_local(0,0),enemy.posX(0) ..' '.. enemy.posY(0))
end	

gPlayTable.CreatePlay{

firstState = "run1",

["run1"] = {
	switch = function()
		number =123
		if DEBUG_SWITCH then
			DEBUG_FUNC()
		end
		if bufcnt(player.toTargetDist('Leader')<10,10) then	
			return "run2"
		end	
	end,
	Leader = task.goCmuRush(testPos[1]),
	match = "{L}"
},
["run2"] = {
	switch = function()
		number =321
		if DEBUG_SWITCH then
			DEBUG_FUNC()
		end
		if bufcnt(player.toTargetDist('Leader')<10,10) then	
			return "run1"
		end	
	end,
	Leader = task.shoot(testPos[2]),
	match = "{L}"
},


name = "Mytest1",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}