-- **MOD NAME**
local modName = "Air"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 0,
    health = math.huge,
    flammable = false,
    explosive = false,
    drops = {},
    resistance = {1, 1, 1}
}


function particle:draw () end

return modName, particle