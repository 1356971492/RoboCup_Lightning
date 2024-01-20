local testPos  = {
	CGeoPoint:new_local(0,1200),
	CGeoPoint:new_local(0,-1200),
	CGeoPoint:new_local(0,0),
	CGeoPoint:new_local(-200,1200),
	CGeoPoint:new_local(-200,-1200),
}

gPlayTable.CreatePlay{

	firstState = "run1",

	["run1"] = {
		switch = function()
			if bufcnt(true,300) then 
				print(ball.posX())
				return "run2" 
			end
		end,
		Assister = task.goCmuRush(testPos[3],0),
		Leader = task.goCmuRush(testPos[3],0), 
		match = "{AL}"
	},
	["run2"] = {
	-- 正
		switch = function()
			if bufcnt((ball.posX() < 10) and (ball.posX() > -50),10) then 
				return "run3" 
			end
		end,
		Assister = task.goCmuRush(testPos[1],0),
		Leader= task.goCmuRush(testPos[2],0), 
		match = "(AL)"
	},
	["run3"] = {
		-- 负
			switch = function()
				if bufcnt((ball.posX() < 50) and (ball.posX() > -10),10) then 
					return "run2" 
				end
			end,
			Assister = task.goCmuRush(testPos[4],0),
			Leader= task.goCmuRush(testPos[5],0), 
			match = "(AL)"
	},
	
	name = "Andy666-Test",
	applicable ={
		exp = "a",
		a = true
	},
	attribute = "attack",
	timeout = 99999
}
