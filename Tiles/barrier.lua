-- **MOD NAME**
local modName = "Barrier"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 2,
    health = 75,
    flammable = false,
    explosive = false,
    drops = {1, 1, 1, 8, 8},
    resistance = {1, 0.75, 0}
}


function particle:draw (x, y)
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 20, (y * 20) + 20, 20, 20)
    
    love.graphics.setColor (142/255, 176/255, 146/255, 1)
    love.graphics.rectangle ("fill", (x * 20) + 21, (y * 20) + 21, 18, 18)
    
    love.graphics.setColor (112/255, 146/255, 116/255, 1)
    love.graphics.rectangle ("line", (x * 20) + 25, (y * 20) + 25, 10, 10)
end

return modName, particle