local testPos  = {
	CGeoPoint:new_local(0,0),
}
local TOTAL=5
local speed = 1/4.0
local angle = -math.pi/2
local radius = 500
local p = function(n,TOTAL)
	return function()
		local centerX = ball.posX()
		local centerY = ball.posY()
		return CGeoPoint:new_local(centerX + radius * math.cos(angle+n*math.pi*2/TOTAL),centerY + radius * -math.sin(angle+n*math.pi*2/TOTAL))	
	end
end
gPlayTable.CreatePlay{

firstState = "run1",

["run1"] = {
	switch = function()
		angle = angle + math.pi*2/60*speed
		-- if bufcnt(player.toTargetDist('Leader')<10,10) then	
		-- 	return "run2"
		-- end	
	end,
	Leader = task.touchKick(player.pos("Assister"),false),
	Assister = task.goCmuRush(testPos[1]),
	match = "{LAMSD}"
},



name = "Mytest2",
applicable ={
	exp = "a",
	a = true
},
attribute = "attack",
timeout = 99999
}