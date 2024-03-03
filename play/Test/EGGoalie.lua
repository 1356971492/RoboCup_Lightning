--守门员

gPlayTable.CreatePlay{

firstState = "t",

["t"] = {
	switch = function()


	end,

	Goalie = task.goalie(),

	match = ""
},


name = "EGGoalie",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}
