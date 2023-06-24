local partFunc = ...

-- **MOD NAME**
local modName = "Feral Slime"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "This artifical creature will slowly consume nearby materials. It seems intelligent...",
    id = 6,
    health = 50,
    damage = 4,
    weight = 8,
    flammable = true,
    color = {0, 218/255, 65/255, 1},
}


function particle.act (x, y)
    -- Chance to replace other particles with slime
    if math.random () < 0.01 and (partFunc.grid[x][y - 1].health ~= math.huge) then
        partFunc.delete (x, y - 1)
        partFunc.spawn (6, x, y - 1)
    end

    if math.random () < 0.01 and (partFunc.grid[x][y + 1].health ~= math.huge) then
        partFunc.delete (x, y + 1)
        partFunc.spawn (6, x, y + 1)
    end

    if math.random () < 0.01 and (partFunc.grid[x - 1][y].health ~= math.huge) then
        partFunc.delete (x - 1, y)
        partFunc.spawn (6, x - 1, y)
    end

    if math.random () < 0.01 and (partFunc.grid[x + 1][y].health ~= math.huge) then
        partFunc.delete (x + 1, y)
        partFunc.spawn (6, x + 1, y)
    end
end

return modName, particle