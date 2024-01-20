local testPos  = {
	CGeoPoint:new_local(1000,1000),
	CGeoPoint:new_local(-1000,-1000),
	CGeoPoint:new_local(1000,-1000),
	CGeoPoint:new_local(-1000,1000)
}

gPlayTable.CreatePlay{

	firstState = "run1",

	["run1"] = {
		switch = function()
			if bufcnt(player.toTargetDist('Assister')<10,10) then 
				return "run2" 
			end
		end,
		Assister = task.goCmuRush(testPos[1],0),
		Leader = task.goCmuRush(testPos[3],0), 
		match = "[AL]"
	},
	["run2"] = {
		switch = function()
			if bufcnt(player.toTargetDist('Assister')<10,10) then 
				return "run1" 
			end
		end,
		Assister = task.goCmuRush(testPos[2],0),
		Leader= task.goCmuRush(testPos[4],0), 
		match = "{AL}"
	},
	
	name = "Andy666-Test",
	applicable ={
		exp = "a",
		a = true
	},
	attribute = "attack",
	timeout = 99999
}
