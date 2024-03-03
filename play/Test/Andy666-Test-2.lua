local testPos  = {
	CGeoPoint:new_local(0,1200),
	CGeoPoint:new_local(0,-1200),
	CGeoPoint:new_local(0,0),
	CGeoPoint:new_local(-200,1200),
	CGeoPoint:new_local(-200,-1200),
	CGeoPoint:new_local(-2000,0),
	CGeoPoint:new_local(-1200,0)
}

gPlayTable.CreatePlay{

	firstState = "run1",

	["run1"] = {
		switch = function()
			
		end,
		Assister = task.goCmuRush(testPos[3],0),
		Leader = task.goCmuRush(testPos[3],0), 
		Kicker = task.goCmuRush(testPos[6],0),
		match = "{ALK}"
	},	
	name = "Andy666-Test-2",
	applicable ={
		exp = "a",
		a = true
	},
	attribute = "attack",
	timeout = 99999
}
