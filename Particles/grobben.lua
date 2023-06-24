local partFunc = ...

-- **MOD NAME**
local modName = "Grobben"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "A flammable material that's similar to wood. It's harvested from an alien plant that grows into large bulbs.",
    id = 7,
    health = 80,
    damage = 4,
    weight = 15,
    flammable = true,
    color = {108/255, 172/255, 182/255, 1},
}


function particle.act () end

return modName, particle