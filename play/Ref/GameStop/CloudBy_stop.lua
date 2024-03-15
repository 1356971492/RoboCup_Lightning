local goaliePos = CGeoPoint:new_local(-param.pitchLength/2,0)
local DSS_FLAG = flag.allow_dss + flag.dodge_ball

local stopPos = function(role)
  local ballPos = ball.pos()
    local pos = function()
      local idir = (player.pos(role) - ballPos):dir()
      if player.toBallDist(role) > 550 then
        return player.pos(role)
      else
        return ballPos + Utils.Polar2Vector(530+param.playerFrontToCenter, idir)
      end
    end
  return pos
end


gPlayTable.CreatePlay {

firstState = "state0",

["state0"] = {
  switch = function()
    if bufcnt(true, 10) then
      return "state1"
    end
  end,
  a      = task.stop(),
  b      = task.stop(),
  c      = task.stop(),
  d      = task.stop(),
  e      = task.stop(),
  f      = task.stop(),
  match  = "{abcdef}"
},


["state1"] = {
  switch = function()
    debugEngine:gui_debug_arc(ball.pos(),500,0,360,1)
    if cond.isGameOn() then
      return "exit"
    end
  end,
  a        = task.goCmuRush(stopPos("a"),dir.playerToBall,_,_),
  b        = task.goCmuRush(stopPos("b"),dir.playerToBall,_,_),
  c        = task.goCmuRush(stopPos("c"),dir.playerToBall,_,_),
  d        = task.goCmuRush(stopPos("d"),dir.playerToBall,_,_),
  e        = task.goCmuRush(stopPos("e"),dir.playerToBall,_,_),
  f        = task.goCmuRush(stopPos("f"),dir.playerToBall,_,_),
  match    = "{abcdef}"
},

name = "CloudBy_stop",
applicable = {
  exp = "a",
  a = true
},
attribute = "attack",
timeout = 99999
}