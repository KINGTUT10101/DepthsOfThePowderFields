-- **MOD NAME**
local modName = "Wall"

-- **ATTRIBUTES**
local particle = {
    name = modName,
    id = 1,
    health = math.huge,
    flammable = false,
    explosive = false,
    drops = {},
    resistance = {1, 1, 1}
}


function particle:draw (x, y)
    love.graphics.setColor (0, 0, 0, 1)
    love.graphics.rectangle ("fill", (x * 20) + 20, (y * 20) + 20, 20, 20)
    
    love.graphics.setColor (87/255, 42/255, 59/255, 1)
    love.graphics.rectangle ("fill", (x * 20) + 21, (y * 20) + 21, 18, 18)
end

return modName, particle