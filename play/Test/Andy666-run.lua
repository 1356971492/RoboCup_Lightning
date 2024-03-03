local testPos = {
    CGeoPoint:new_local(0, 1.2e3),
    CGeoPoint:new_local(0, -1.2e3),
    CGeoPoint:new_local(0, 0),
    CGeoPoint:new_local(-200, 1.2e3),
    CGeoPoint:new_local(-200, -1.2e3),
    CGeoPoint:new_local(-2e3, 0),
    CGeoPoint:new_local(-1.2e3, 0)
}

local enemywithball = function()
    for i = 0, 2 do
        local dist = ball.pos() - enemy.pos(i)
        if dist < 200 then 
            return i 
        end
    end
end

local nearestenemy = function()
    return function()
        local min = 0
        for i = 1, 2 do 
            if enemy.posX(i) < enemy.posX(min) then 
                min = i 
            end 
        end
        return min
    end
end



gPlayTable.CreatePlay {
    firstState = "run1",
    ["run1"] = {
        -- 相持
        switch = function()
            debugEngine:gui_debug_msg(nearestenemy)
            if bufcnt(ball.posX() < 50, 5) and enemywithball == nil then
                return "run2"
            elseif bufcnt(ball.posX() > 1.5e3, 5) then
                return "run3"
            end
        end,
        Assister = task.goCmuRush(enemy.pos(nearestenemy) , 0),
        Leader = task.goCmuRush(testPos[3], 0),
        Kicker = task.goCmuRush(testPos[6], 0),
        match = "{ALK}"
    },
    ["run2"] = {
        -- 防御
        switch = function() if bufcnt(ball.posX() < 50, 10) then return "run3" end end,
        Assister = task.goCmuRush(testPos[1], 0),
        Leader = task.goCmuRush(testPos[2], 0),
        match = "(ALK)"
    },
    ["run3"] = {
        -- 进攻
        switch = function() if bufcnt(ball.posX() > -50, 10) then return "run2" end end,
        Assister = task.goCmuRush(ball.pos(), 0),
        Leader = task.goCmuRush(testPos[5], 0),
        Kicker = task.goCmuRush(testPos[4], 0),
        match = "(ALK)"
    },
    name = "Andy666-run",
    applicable = { exp = "a", a = true },
    attribute = "attack",
    timeout = 9.9999e4
}
