local DSS_FLAG = flag.allow_dss + flag.dodge_ball
local ballpos = ball.pos()


local StandPos  = { -- 后场站位
	CGeoPoint:new_local(-2400,1800),
	CGeoPoint:new_local(-1200,1800),
	CGeoPoint:new_local(-2400,0),
	CGeoPoint:new_local(-1200,0),
	CGeoPoint:new_local(-2400,-1800),
	CGeoPoint:new_local(-1200,-1800),
}

gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {--必要的初始化 不然会导致goCmuRush的位置出现
	switch = function()
		
	end,
	
	Leader = task.goCmuRush(StandPos[1], dir.playerToBall,_,DSS_FLAG),
	a      = task.goCmuRush(StandPos[2], dir.playerToBall,_,DSS_FLAG),
	b      = task.goCmuRush(StandPos[3], dir.playerToBall,_,DSS_FLAG),
	c      = task.goCmuRush(StandPos[4], dir.playerToBall,_,DSS_FLAG),
	d      = task.goCmuRush(StandPos[5], dir.playerToBall,_,DSS_FLAG),
	Goalie = task.goCmuRush(StandPos[6], dir.playerToBall,_,DSS_FLAG),
	match  = "{LGabcd}"
},





name = "InitialStand",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}