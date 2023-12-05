local testPos  = {
	CGeoPoint:new_local(1000,1000),
	CGeoPoint:new_local(-1000,-1000)
}

gPlayTable.CreatePlay{

firstState = "run1",

["run1"] = {
	switch = function()
		if bufcnt(player.toTargetDist('Kicker')<10,10) then	
			return "run2"
		end	
	end,
	Kicker = task.goCmuRush(testPos[1],0),
	match = ""
},
["run2"] = {
	switch = function()
		if bufcnt(player.toTargetDist('Kicker')<10,10) then	
			return "run2"
		end	
	end,
	Kicker = task.goCmuRush(testPos[2],0),
	match = ""
},


name = "Mytest1",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}