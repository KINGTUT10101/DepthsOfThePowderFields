local partFunc = ...

-- **MOD NAME**
local modName = "Zona"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "An odd metal found on the lunar surface. It's always undergoing an endothermic reaction, which makes it more danagerous.",
    id = 3,
    health = 350,
    damage = 50,
    weight = 20,
    flammable = false,
    color = {50/255, 30/255, 66/255, 1},
}


function particle.act () end

return modName, particle