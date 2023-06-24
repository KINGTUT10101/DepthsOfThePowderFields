local partFunc = ...

-- **MOD NAME**
local modName = "Flesh"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "It doesn't make for a great weapon, but it'll certainly do in a pinch.",
    id = 5,
    health = 65,
    damage = 1,
    weight = 15,
    flammable = true,
    color = {194/255, 53/255, 55/255, 1},
}


function particle.act () end

return modName, particle