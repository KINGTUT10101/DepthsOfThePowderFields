local simulation = {
    grid = {},
    size = 16,
    patterns = {},
    stats = {
        averageHealth = 0, -- Average health of each non-air part in the weapon
        overallHealth = 0, -- Overall health of every non-air part in the weapon
        damage = 0, -- The weapon's base damage
        weight = 0, -- The weapon's base weight
        sharp = 0, -- The weapon's sharp damage percent
        serrated = 0, -- The weapon's serrated damage percent
        pierce = 0, -- The weapon's pierce damage percent
    },
}
local grid = simulation.grid

local particles = {}

-- Loads in the tiles
local files =  love.filesystem.getDirectoryItems ("Particles")
for _, v in pairs (files) do
    local chunk = love.filesystem.load ("Particles/" .. v)
    if chunk ~= nil then
        local name, part = chunk (simulation)
        particles[part.id] = part
    end
end


-- Initializes the map
for i = 1, simulation.size do
    grid[i] = {}
    for j = 1, simulation.size do
        grid[i][j] = {}
    end
end


-- Clears the map and fills it with air particles
function simulation.clear ()
    for i = 1, simulation.size do
        for j = 1, simulation.size do
            if i == 9 and j > 3 then
                -- Spawns wallmite to act as a handle
                grid[i][j] = {
                    id = 12,
                    health = math.huge,
                }
            else
                -- Spawns an air particle
                grid[i][j] = {
                    id = 0,
                    health = math.huge,
                }
            end
        end
    end
end


function simulation.spawn (id, x, y)
    local result = false
    
    if x >= 1 and x <= simulation.size and y >= 1 and y <= simulation.size then
        -- Checks if the position is valid (aka connection to another part)
        if simulation.getID (x, y - 1) ~= 0 or simulation.getID (x, y + 1) ~= 0
        or simulation.getID (x - 1, y) ~= 0 or simulation.getID (x + 1, y) ~= 0 then

            if grid[x][y].id == 0 then
                grid[x][y] = {
                    id = id,
                    health = particles[id].health,
                }

                result = true
            end
        end
    end

    return result
end


function simulation.delete (x, y)
    local result = false
    
    if x >= 1 and x <= simulation.size and y >= 1 and y <= simulation.size and grid[x][y].id ~= 12 then
        grid[x][y] = {
            id = 0,
            health = math.huge,
        }

        result = true
    end

    return result
end


function simulation.swap (x, y, nx, ny)
    local result = false
    
    if x >= 1 and x <= simulation.size and y >= 1 and y <= simulation.size then
        if nx >= 1 and nx <= simulation.size and ny >= 1 and ny <= simulation.size then
            if grid[nx][ny].id == 0 then
                grid[x][y], grid[nx][ny] = grid[nx][ny], grid[x][y]

                result = true
            end
        end
    end

    return result
end


-- Chooses a random damage pattern and applies it to the weapon
function simulation.damage ()
    local patterns = {}
    
    for k, v in pairs (simulation.patterns) do
        patterns[#patterns + 1] = v
    end
    
    patterns[math.random (1, #patterns)] ()
end


function simulation.getID (x, y)
    local result = -1
    
    if x >= 1 and x <= simulation.size and y >= 1 and y <= simulation.size then
        result = grid[x][y].id
    end
    
    return result
end


-- Damages the weapon using a horizontal line across the map
function simulation.patterns.damageHorizontal ()
    -- Chooses two points at the edge and middle of the map
    local x1 = math.random () < 0.50 and math.random (1, 4) or math.random (simulation.size - 3, simulation.size)
    local y1 = math.random (1, simulation.size)

    local x2 = math.random (8, 12)
    local y2 = math.random (8, 12)

    -- Damages the particles the line touches
    local delta_x = math.abs(x2 - x1)
    local delta_y = math.abs(y2 - y1)
    local sign_x = 1
    local sign_y = 1

    if x1 > x2 then
        sign_x = -1
    end
    if y1 > y2 then
        sign_y = -1
    end

    local error = delta_x - delta_y

    grid[x2][y2].health = grid[x2][y2].health - math.random (3, 15)

    while x1 ~= x2 or y1 ~= y2 do
        grid[x1][y1].health = grid[x1][y1].health - math.random (3, 15)

        local error2 = error * 2

        if error2 > -delta_y then
            error = error - delta_y
            x1 = x1 + sign_x
        end

        if error2 < delta_x then
            error = error + delta_x
            y1 = y1 + sign_y
        end
    end
end


-- Damages the weapon using a vertical line across the map
function simulation.patterns.damageVertical ()
    -- Chooses two points at the edge and middle of the map
    local x1 = math.random (1, simulation.size)
    local y1 = math.random () < 0.50 and math.random (1, 4) or math.random (simulation.size - 3, simulation.size)

    local x2 = math.random (8, 12)
    local y2 = math.random (8, 12)

    -- Damages the particles the line touches
    local delta_x = math.abs(x2 - x1)
    local delta_y = math.abs(y2 - y1)
    local sign_x = 1
    local sign_y = 1

    if x1 > x2 then
        sign_x = -1
    end
    if y1 > y2 then
        sign_y = -1
    end

    local error = delta_x - delta_y

    grid[x2][y2].health = grid[x2][y2].health - math.random (3, 15)

    while x1 ~= x2 or y1 ~= y2 do
        grid[x1][y1].health = grid[x1][y1].health - math.random (3, 15)

        local error2 = error * 2

        if error2 > -delta_y then
            error = error - delta_y
            x1 = x1 + sign_x
        end

        if error2 < delta_x then
            error = error + delta_x
            y1 = y1 + sign_y
        end
    end
end


-- Damages the weapon in a circular pattern
function simulation.patterns.damageCircle ()
    local x = math.random (5, 12)
    local y = math.random (5, 12)
    local r = math.random (2, 3)
    
    for i = x - r, x + r do
        for j = y - r, y + r do
            -- Checks if the current particle is within bounds
            if (i >= 1 and i <= simulation.size) and (j >= 1 and j <= simulation.size) then
                -- Calculate the distance between the center of the circle and the tile
                local dx = x - i
                local dy = y - j
                local distance = math.sqrt(dx * dx + dy * dy)

                -- If the distance is within the radius of the circle, execute the function
                if distance <= r then
                    grid[i][j].health = grid[i][j].health - math.random (2, 8)
                end
            end
        end
    end
end


-- Damages a particle at a random coordinate
function simulation.patterns.damageMinor ()
    local found = false
    local loops = 0
    
    --Makes up to three attempts to find a non-air particle
    while (found == false and loops < 3) do
        local x = math.random (1, 12)
        local y = math.random (1, 12)

        if grid[x][y].id ~= 0 then
            found = true
            grid[x][y].health = grid[x][y].health - math.random (15, 30)
        else
            loops = loops + 1
        end
    end
end


-- Damages the weapon in an X-shaped pattern
function simulation.patterns.damageX ()
    -- Chooses two points at the edge and middle of the map
    local x1 = math.random () < 0.50 and math.random (1, 4) or math.random (simulation.size - 3, simulation.size)
    local y1 = math.random () < 0.50 and math.random (1, 4) or math.random (simulation.size - 3, simulation.size)

    local x2 = math.random (8, 12)
    local y2 = math.random (8, 12)

    -- Damages the particles the line touches
    local delta_x = math.abs(x2 - x1)
    local delta_y = math.abs(y2 - y1)
    local sign_x = 1
    local sign_y = 1

    if x1 > x2 then
        sign_x = -1
    end
    if y1 > y2 then
        sign_y = -1
    end

    local error = delta_x - delta_y

    grid[x2][y2].health = grid[x2][y2].health - math.random (3, 15)

    while x1 ~= x2 or y1 ~= y2 do
        grid[x1][y1].health = grid[x1][y1].health - math.random (3, 15)

        local error2 = error * 2

        if error2 > -delta_y then
            error = error - delta_y
            x1 = x1 + sign_x
        end

        if error2 < delta_x then
            error = error + delta_x
            y1 = y1 + sign_y
        end
    end
end


-- Removes parts disconnected from the weapon
-- The handle starts at 9, 16 and can't be destroyed
-- Anything not connected to it should be removed
function simulation.validate ()
    local validParts = {}

    -- Initializes the table
    for i = 1, simulation.size do
        validParts[i] = {}
        for j = 1, simulation.size do
            validParts[i][j] = false
        end
    end

    simulation.validateHelper (validParts, 9, 16)

    -- Iterates over the table and removes any parts that are not marked as valid
    for i = 1, simulation.size do
        local firstValid = validParts[i]

        for j = 1, simulation.size do
            if firstValid[j] == false and particles[grid[i][j].id].gravity ~= true then
                simulation.delete (i, j)
            end
        end
    end
end


function simulation.validateHelper (validParts, x, y)
    -- Checks the part at the current position
    if grid[x][y].id ~= 0 then
        validParts[x][y] = true

        -- Recursively calls the method for adjacent tiles that haven't been marked
        if y + 1 <= simulation.size and validParts[x][y + 1] == false then
            simulation.validateHelper (validParts, x, y + 1)
        end
        
        if y - 1 >= 1 and validParts[x][y - 1] == false then
            simulation.validateHelper (validParts, x, y - 1)
        end

        if x + 1 <= simulation.size and validParts[x + 1][y] == false then
            simulation.validateHelper (validParts, x + 1, y)
        end

        if x - 1 >= 1 and validParts[x - 1][y] == false then
            simulation.validateHelper (validParts, x - 1, y)
        end
    end
end


-- Finds the weapons damage values using the particle's weights, damage values, and the weapon's pattern
-- Scans from 1, 1 to 8, 12
function simulation.calcDamage ()
    local lastLength = 0
    local nextLength = 8

    -- Resets the damage-related stats
    simulation.stats.damage = 0
    simulation.stats.sharp = 0
    simulation.stats.serrated = 0
    simulation.stats.pierce = 0
    simulation.stats.weight = 0

    -- Calculates the length of the first level
    for i = 1, 8 do
        if grid[i][1].id == 0 then
            nextLength = nextLength - 1
        end
    end
    
    -- Calculates the damage percentages and base damage
    for j = 1, 13 do
        local currentLength = nextLength
        nextLength = 8

        -- Calculates the base damage for this level
        -- This will use the damage value from the outmost particle in the level
        if currentLength > 0 and j > 1 then
            simulation.stats.damage = simulation.stats.damage + particles[grid[(8 - currentLength) + 1][j - 1].id].damage
        end

        -- Calculates the length of the next layer
        local found = false
        if j <= 13 then
            for i = 1, 8 do
                if grid[i][j].id == 0 and found == false then
                    nextLength = nextLength - 1
                else
                    found = true
                end
            end
        else
            nextLength = 0
        end
        
        -- Pierce
        if currentLength - math.max (lastLength, nextLength) >= 3 then
            simulation.stats.pierce = simulation.stats.pierce + 1
        
        -- Serrated
        elseif currentLength - lastLength >= 1 and currentLength - nextLength >= 1 then
            simulation.stats.serrated = simulation.stats.serrated + 1
            
        -- Skip
        elseif currentLength == 0 then
        
        -- Slash
        elseif currentLength >= lastLength or currentLength >= nextLength then
            simulation.stats.sharp = simulation.stats.sharp + 1
        end
        
        lastLength = currentLength
    end

    local damageSum = simulation.stats.sharp + simulation.stats.serrated + simulation.stats.pierce
    if damageSum > 0 then
        simulation.stats.sharp = simulation.stats.sharp / damageSum
        simulation.stats.serrated = simulation.stats.serrated / damageSum
        simulation.stats.pierce = simulation.stats.pierce / damageSum
    end

    -- Calculates the weight of the weapon
    for i = 1, simulation.size do
        local firstPart = grid[i]

        for j = 1, simulation.size do
            simulation.stats.weight = simulation.stats.weight + particles[firstPart[j].id].weight
        end
    end
end


-- Finds the average health and overall health of all non-air particles
function simulation.calcDurability ()
    local totalParts = 0
    local healthPercentSum = 0
    local healthSum = 0
    local totalHealthSum = 0
    
    for i = 1, simulation.size do
        local firstPart = grid[i]

        for j = 1, simulation.size do
            if firstPart[j].id ~= 0 and firstPart[j].id ~= 12 then
                totalParts = totalParts + 1
                healthPercentSum = healthPercentSum + firstPart[j].health / particles[firstPart[j].id].health
                healthSum = healthSum + firstPart[j].health
                totalHealthSum = totalHealthSum + particles[firstPart[j].id].health
            end
        end
    end
    
    simulation.stats.averageHealth = math.ceil (healthPercentSum / totalParts * 100) / 100
    simulation.stats.overallHealth = math.ceil (healthSum / totalHealthSum * 100) / 100
end


function simulation.explode (x, y)

end


function simulation.ignite (x, y)

end


return simulation, particles