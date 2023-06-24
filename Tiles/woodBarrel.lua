-- **MOD NAME**
local modName = "Wood Barrel"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 4,
    health = 30,
    flammable = false,
    explosive = false,
    drops = {7, 7, 1, 7, 7, 7, 8, 1},
    resistance = {0.85, 0, 0.45}
}


function particle:draw (x, y)
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 20, (y * 20) + 20, 20, 20)

    love.graphics.setColor (87/255, 53/255, 12/255, 1)
    love.graphics.rectangle ("fill", (x * 20) + 21, (y * 20) + 21, 18, 18)

    love.graphics.setColor (17/255, 13/255, 0/255, 1)
    love.graphics.rectangle ("fill", (x * 20) + 25, (y * 20) + 25, 10, 10)
end

return modName, particle