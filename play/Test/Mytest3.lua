local f = flag.dribbling
gPlayTable.CreatePlay{

firstState = "t1",

["t1"] = {
	switch = function()
		if bufcnt(true, 90) then
			return "t2"
		end
	end,
	-- Leader = task.waitForAttack(),
	-- Assister = task.attack(),
	Leader = task.speed(200, 0, 0, f),
	Goalie = task.goalie(),
	match = "{LA}"
},
["t2"] = {
	switch = function()
		if bufcnt(true, 90) then
			return"t3"
		end
	end,
	Leader = task.speed(-200, 0, 0, f),
	Goalie = task.goalie(),
	match = "{LA}"
},
["t3"] = {
	switch = function()
		if bufcnt(true, 90) then
			return"t4"
		end
	end,
	Leader = task.speed(0, 200, 0, f),
	Goalie = task.goalie(),
	match = "{LA}"
},
["t4"] = {
	switch = function()
		if bufcnt(true, 90) then
			return"t1"
		end
	end,
	Leader = task.speed(0, -200, 0, f),
	Goalie = task.goalie(),
	match = "{LA}"
},
name = "Mytest3",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}