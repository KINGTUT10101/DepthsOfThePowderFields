local partFunc = ...

-- **MOD NAME**
local modName = "Molten metal"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "It's metal ... that's melted. It'll cool down and form slag over time.",
    id = 10,
    health = 100,
    damage = 25,
    weight = 20,
    flammable = false,
    gravity = true,
    color = {225/255, 104/255, 25/255, 1},
}


function particle.act (x, y)
    local rng = math.random ()

    if y == partFunc.size then
        partFunc.delete (x, y)
        
    elseif partFunc.swap (x, y, x, y + 1) == false then

        if rng < 0.33 then
            partFunc.swap (x, y, x + 1, y)
        elseif rng < 0.66 then
            partFunc.swap (x, y, x - 1, y)
        elseif math.random () < 0.2 then
            partFunc.delete (x, y)
            partFunc.spawn (11, x, y)
        end
    end
end

return modName, particle