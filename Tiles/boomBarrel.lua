-- **MOD NAME**
local modName = "Boom Barrel"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 5,
    health = 10,
    flammable = false,
    explosive = true,
    drops = {1, 1, 2, 8},
    resistance = {0, 0, 0}
}


function particle:draw (x, y)
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 20, (y * 20) + 20, 20, 20)

    love.graphics.setColor (31/255, 138/255, 10/255, 1)
    love.graphics.rectangle ("line", (x * 20) + 21, (y * 20) + 21, 18, 18)

    love.graphics.setColor (1, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 25, (y * 20) + 25, 5, 5)
end

return modName, particle