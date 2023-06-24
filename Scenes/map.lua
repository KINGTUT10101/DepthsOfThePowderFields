

local thisScene = {}

local sceneMan, Slab, tiles, overworld

function thisScene:load (...)
    sceneMan, Slab, tiles, overworld = ...

    overworld.clear ()
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Checks if each tile is dead and provides drops if true
    for i = 1, overworld.size do
        local firstPart = overworld.grid[i]
        
        for j = 1, overworld.size do
            if firstPart[j].id > 1 and firstPart[j].health <= 0 then
                local drops = tiles[firstPart[j].id].drops

                -- Bandaid fix
                if drops ~= nil and firstPart[j].killedByPlayer == true then
                    for i = 1, #drops do
                        if math.random () < 1/#drops then
                            inventory[drops[i]] = inventory[drops[i]] + 1
                        end
                    end
                end
                
                playerStats.tilesMined = playerStats.tilesMined + 1
                overworld.delete (i, j)
            end
        end
    end

    -- Resets the game
    if resetMap == true then
        overworld.clear ()
    end
end

function thisScene:draw ()
    love.graphics.setColor (146/255, 145/255, 146/255, 1)
    love.graphics.rectangle ("fill", 40, 40, 640, 640)
    
    for i = 1, overworld.size do
        local firstPart = overworld.grid[i]
        
        for j = 1, overworld.size do
            tiles[firstPart[j].id]:draw (i, j)
        end
    end
end

function thisScene:keypressed (key)
	if key == "p" then
        --local x = math.random (2, overworld.size - 1)
        --local y = math.random (2, overworld.size - 1)
        --overworld.spawn (math.random (2, 7), x, y)
    
    -- Randomly spawns tiles around the map and clears some areas when the new wave starts
    elseif key == "return" and enemiesLeft == 0 then
        floor = floor - 1

        overworld.clear ()

        for i = 1, math.random (20, 50) do
            local x = math.random (2, overworld.size - 1)
            local y = math.random (2, overworld.size - 1)
            overworld.spawn (math.random (2, 7), x, y)
        end

        -- Clears the middle and corners
        overworld.delete (16, 16)
        overworld.delete (16, 17)
        overworld.delete (17, 16)
        overworld.delete (17, 17)

        overworld.delete (2, 2)
        overworld.delete (2, 3)
        overworld.delete (3, 2)
        overworld.delete (3, 3)

        overworld.delete (30, 30)
        overworld.delete (30, 31)
        overworld.delete (31, 30)
        overworld.delete (31, 31)

        overworld.delete (2, 30)
        overworld.delete (2, 31)
        overworld.delete (3, 30)
        overworld.delete (3, 31)

        overworld.delete (30, 2)
        overworld.delete (31, 2)
        overworld.delete (30, 3)
        overworld.delete (31, 3)
    end
end

return thisScene