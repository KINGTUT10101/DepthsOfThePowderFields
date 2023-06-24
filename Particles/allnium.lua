local partFunc = ...

-- **MOD NAME**
local modName = "Allnium"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "A cheap metal used throughout the lunar infrastructure. Despite its versatility, it's prone to rusting.",
    id = 1,
    health = 150,
    damage = 10,
    weight = 20,
    flammable = false,
    color = {142/255, 176/255, 146/255, 1},
}


function particle.act (x, y)
    -- Chance to rust at low health
    if math.random () < 0.01 and partFunc.grid[x][y].health < 35 then
        partFunc.delete (x, y)
        partFunc.spawn (9, x, y)
    end
end

return modName, particle