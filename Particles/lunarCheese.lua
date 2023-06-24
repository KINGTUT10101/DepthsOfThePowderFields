local partFunc = ...

-- **MOD NAME**
local modName = "Lunar Cheese"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "A hard material similar to stone that's durable, but not very sharp. Despite the name, it's not very tasty.",
    id = 8,
    health = math.huge,
    damage = 4,
    weight = 35,
    flammable = false,
    color = {200/255, 200/255, 57/255, 1},
}


function particle.act () end

return modName, particle