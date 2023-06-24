local partFunc = ...

-- **MOD NAME**
local modName = "Onnakon"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    desc = "A rare material found deep beneath lunar powder fields. It's constantly releasing heat, which can melt other metals!",
    id = 2,
    health = 200,
    damage = 20,
    weight = 32,
    flammable = false,
    color = {138/255, 54/255, 31/255, 1},
}


function particle.act (x, y)
    -- Chance to replace allnium and zona with molten metal
    if math.random () < 0.02 and (partFunc.getID (x, y - 1) == 1 or partFunc.getID (x, y - 1) == 3) then
        partFunc.delete (x, y - 1)
        partFunc.spawn (10, x, y - 1)
    end

    if math.random () < 0.02 and (partFunc.getID (x, y + 1) == 1 or partFunc.getID (x, y + 1) == 3) then
        partFunc.delete (x, y + 1)
        partFunc.spawn (10, x, y + 1)
    end

    if math.random () < 0.02 and (partFunc.getID (x - 1, y) == 1 or partFunc.getID (x - 1, y) == 3) then
        partFunc.delete (x - 1, y)
        partFunc.spawn (10, x - 1, y)
    end

    if math.random () < 0.02 and (partFunc.getID (x + 1, y) == 1 or partFunc.getID (x + 1, y) == 3) then
        partFunc.delete (x + 1, y)
        partFunc.spawn (10, x + 1, y)
    end
end

return modName, particle