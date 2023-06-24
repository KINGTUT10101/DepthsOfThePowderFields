local partFunc = ...

-- **MOD NAME**
local modName = "Slag"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "This is a metal that has been improperly heated and cooled. It's very dull now, but it'll still deal some considerable damage.",
    id = 11,
    health = 75,
    damage = 2,
    weight = 20,
    flammable = false,
    color = {96/255, 95/255, 93/255, 1},
}


function particle.act () end

return modName, particle