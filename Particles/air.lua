local partFunc = ...

-- **MOD NAME**
local modName = "Air"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "It's the stuff you breath. Unless you're an alien, of course.",
    id = 0,
    health = math.huge,
    damage = 0,
    weight = 0,
    flammable = false,
    color = {0, 0, 0, 0}
}


function particle.act () end

return modName, particle