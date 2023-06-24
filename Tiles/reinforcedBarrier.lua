-- **MOD NAME**
local modName = "Reinforced Barrier"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 3,
    health = 150,
    flammable = false,
    explosive = false,
    drops = {1, 1, 3, 3, 3},
    resistance = {1, 0.75, 0}
}


function particle:draw (x, y)
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 20, (y * 20) + 20, 20, 20)
    
    love.graphics.setColor (122/255, 196/255, 156/255, 1)
    love.graphics.rectangle ("fill", (x * 20) + 21, (y * 20) + 21, 18, 18)
    
    love.graphics.setColor (92/255, 166/255, 126/255, 1)
    love.graphics.rectangle ("line", (x * 20) + 25, (y * 20) + 25, 10, 10)
end

return modName, particle