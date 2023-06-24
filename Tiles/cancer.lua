-- **MOD NAME**
local modName = "Cancer"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 7,
    health = 20,
    flammable = true,
    explosive = false,
    drops = {5, 5, 5, 4, 4, 4, 4},
    resistance = {0, 0.30, 0.55}
}


function particle:draw (x, y)
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 20, (y * 20) + 20, 20, 20)

    love.graphics.setColor (255/255, 220/255, 122/255, 1)
    love.graphics.rectangle ("fill", (x * 20) + 21, (y * 20) + 21, 18, 18)

    love.graphics.setColor (1, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 35, (y * 20) + 38, 2, 2)
    love.graphics.rectangle ("fill", (x * 20) + 30, (y * 20) + 30, 1, 1)
    love.graphics.rectangle ("fill", (x * 20) + 23, (y * 20) + 25, 1, 2)
    love.graphics.rectangle ("fill", (x * 20) + 30, (y * 20) + 23, 2, 2)
end

return modName, particle