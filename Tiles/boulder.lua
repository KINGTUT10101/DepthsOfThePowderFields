-- **MOD NAME**
local modName = "Boulder"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 6,
    health = 250,
    flammable = false,
    explosive = false,
    drops = {8, 8, 8, 8, 8, 8, 8},
    resistance = {1, 0.75, 0}
}


function particle:draw (x, y)
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 20, (y * 20) + 20, 20, 20)

    love.graphics.setColor (146/255, 154/255, 126/255, 1)
    love.graphics.rectangle ("fill", (x * 20) + 21, (y * 20) + 21, 18, 18)
end

return modName, particle