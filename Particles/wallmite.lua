local partFunc = ...

-- **MOD NAME**
local modName = "Wallmite"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "A tough material that is completely invincible. It doesn't make for a good weapon though.",
    id = 12,
    health = math.huge,
    damage = 1,
    weight = 25,
    flammable = false,
    color = {87/255, 42/255, 59/255, 1},
}


function particle.act () end

return modName, particle