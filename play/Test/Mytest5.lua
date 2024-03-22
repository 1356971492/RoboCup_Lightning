--测试对方放球时的跑位
gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {
	switch = function()
		
	end,
	Leader = task.touchKick(player.pos("Assister"),false),
	Assister = task.goCmuRush(testPos[1]),
	match = "{LAMSD}"
},



name = "Mytest5",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}