local partFunc = ...

-- **MOD NAME**
local modName = "Bone"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "A brittle bone that is relatively sharp. Just don't think about where it came from!",
    id = 4,
    health = 35,
    damage = 8,
    weight = 12,
    flammable = false,
    color = {241/255, 230/255, 191/255, 1},
}


function particle.act () end

return modName, particle