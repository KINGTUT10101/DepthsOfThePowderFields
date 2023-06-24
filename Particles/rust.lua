local partFunc = ...

-- **MOD NAME**
local modName = "Rust"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "The result of a poorly-maintained metal. You might as well remove it.",
    id = 9,
    health = 50,
    damage = 1,
    weight = 6,
    flammable = false,
    gravity = true,
    color = {160/255, 81/255, 55/255, 1},
}


function particle.act (x, y)
    if y == partFunc.size then
        partFunc.delete (x, y)
    else
        partFunc.swap (x, y, x, y + 1)
    end
end

return modName, particle