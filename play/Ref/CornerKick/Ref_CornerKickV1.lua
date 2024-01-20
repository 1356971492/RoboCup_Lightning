
gPlayTable.CreatePlay{
firstState = "halt",
["halt"] = {
  switch = function()
  end,
  ["Leader"]   = task.stop(),
  ["Special"]  = task.stop(),
  ["Assister"] = task.stop(),
  match = "[LSA]"
},
name = "Ref_CornerKickV1",
applicable = {
  exp = "a",
  a   = true
},
attribute = "attack",
timeout = 99999
}