local DSS_FLAG = flag.allow_dss + flag.dodge_ball
local placePos = ball.placementPos()
local testPlacePos = CGeoPoint:new_local(1000,-2000)
local ballpos = ball.pos()
local ballposY = ball.posY()
local ballposX = ball.posX()

local toBallDir = function(role)
  return (ball.pos() - player.pos(role)):dir()
end
local theirPenaltyLeavePos = function(role) --点球时机器人所在的位置
  local dist1 = 800
  return function()
    local ballposX = ball.posX()
    debugEngine:gui_debug_msg(CGeoPoint:new_local(-1000, 0), "ballposX is  "..ballposX)
    if player.posX(role) - dist1 < ballposX then
    -- if 1 < 2 then
      return player.pos(role) + Utils.Polar2Vector(dist1 - player.posX(role) + ballposX, 0)
    else
      return player.pos(role)
    end
  end
end





--先做点球防守方
gPlayTable.CreatePlay{

firstState = "state0",

["state0"] = {--初始化
  switch = function()
    if bufcnt(true, 1) then
      return "state1"
    end
  end,
  
  Leader = task.stop(),
  a      = task.stop(),
  b      = task.stop(),
  c      = task.stop(),
  d      = task.stop(),
  Goalie = task.stop(),
  match  = "{LGabcd}"
},
["state1"] = {--前往点球时的站位
  switch = function()
    -- debugEngine:gui_debug_msg(CGeoPoint:new_local(0, 0), ballposX)
    
  end,
  
  Leader = task.goCmuRush(theirPenaltyLeavePos("Leader"),dir.playerToBall,_,DSS_FLAG),
  a      = task.goCmuRush(theirPenaltyLeavePos("a"),dir.playerToBall,_,DSS_FLAG),
  b      = task.goCmuRush(theirPenaltyLeavePos("b"),dir.playerToBall,_,DSS_FLAG),
  c      = task.goCmuRush(theirPenaltyLeavePos("c"),dir.playerToBall,_,DSS_FLAG),
  d      = task.goCmuRush(theirPenaltyLeavePos("d"),dir.playerToBall,_,DSS_FLAG),
  Goalie = task.goalie(),
  match  = "{LGabcd}"
},


name = "Ref_PenaltyDefV1",
applicable = {
  exp = "a",
  a = true
},
attribute = "attack",
timeout = 99999
}