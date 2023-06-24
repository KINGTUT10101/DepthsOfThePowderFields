local thisScene = {}

local sceneMan, Slab, particles, simulation

local mouseX, mouseY
local nearestX = 0
local nearestY = 0
local mapX = 1
local mapY = 1

local lastUpdate = 0
local tickSpeed = 1/16

local selectedPart = 1

function thisScene:load (...)
    sceneMan, Slab, particles, simulation = ...

    simulation.clear ()
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Sets the mouse and coordinates variables
	mouseX, mouseY = love.mouse.getPosition ()
	nearestX = mouseX-(mouseX%20)
	nearestY = mouseY-(mouseY%20)
    mapX = math.floor ((nearestX - 940) / 20) + 1
    mapY = math.floor ((nearestY - 360) / 20) + 1

    if mouseX >= 940 and mouseX < 1260 and mouseY >= 360 and mouseY < 680 then
        -- Removes particles while RMB is pressed
        if love.mouse.isDown (2) then
            simulation.delete (mapX, mapY)
        end
        
        -- Places particles while LMB is pressed
        if love.mouse.isDown (1) and inventory[selectedPart] > 0 then
            if simulation.spawn (selectedPart, mapX, mapY) == true then
                inventory[selectedPart] = inventory[selectedPart] - 1
            end
        end
        
        -- Picks a particle while MMB is pressed
        if love.mouse.isDown (3) and mapX <= mapData.size then
            if simulation.grid[mapX][mapY].id >= 1 and simulation.grid[mapX][mapY].id <= 8 then
                selectedPart = simulation.grid[mapX][mapY].id
            end
        end
    end

    -- Executes a game tick
	lastUpdate = lastUpdate + dt
	if lastUpdate >= tickSpeed then
        for i = simulation.size, 1, -1 do
            local firstPart = simulation.grid[i]
            
            for j = simulation.size, 1, -1 do
                if firstPart[j].id ~= 0 then
                    particles[firstPart[j].id].act (i, j)

                    if firstPart[j].health <= 0 then
                        simulation.delete (i, j)
                    end
                end
            end
        end

        -- Damages the weapon if it attacked something
        if damageWeapon == true then
            for i = 1, math.random (1, 6) do
                simulation.damage ()
            end
            damageWeapon = false
        end

        -- Validates and recalculates the weapon's stats
        simulation.validate ()
        simulation.calcDamage ()
        simulation.calcDurability ()

        -- Resets last update
        lastUpdate = 0
    end

    -- Resets the game
    if resetMap == true then
        resetMap = false
        
        simulation.clear ()
    end
end

function thisScene:draw ()
    -- Renders the background
    local avgHealth = (simulation.stats.overallHealth + simulation.stats.averageHealth) / 2
    love.graphics.setColor (1 - avgHealth, avgHealth, 0, 1)
    love.graphics.rectangle ("fill", 920, 340, 360, 360)
    
    love.graphics.setColor (0.40, 0.40, 0.40, 1)
    love.graphics.rectangle ("fill", 940, 360, 320, 320)

    -- Renders build area
    if mouseX >= 940 and mouseX < 1260 and mouseY >= 360 and mouseY < 680 then
        love.graphics.setColor (1, 0, 0, 0.25)
        love.graphics.rectangle ("fill", 940, 360, 160, 240)
    end
    
    -- Renders the particles
    for i = 1, simulation.size do
        local firstPart = simulation.grid[i]
        
        for j = 1, simulation.size do
            if firstPart[j].id ~= 0 then
                love.graphics.setColor (particles[firstPart[j].id].color)
                love.graphics.rectangle ("fill", (i * 20) + 920, (j * 20) + 340, 20, 20)
            end
        end
    end

    -- Renders the weapon information
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.print ("Overall durability: " .. simulation.stats.overallHealth * 100 .. "%", 925, 100)
    love.graphics.print ("Average durability: " .. simulation.stats.averageHealth * 100 .. "%", 925, 150)

    if simulation.stats.damage <= 0 then
        love.graphics.print ("Base damage: 0.1 HP", 925, 200)
    else
        love.graphics.print ("Base damage: " .. simulation.stats.damage .. " HP", 925, 200)
    end

    love.graphics.setColor (simulation.stats.sharp, simulation.stats.serrated, simulation.stats.pierce, 1)
    love.graphics.print ("Damage distribution: " .. math.floor (simulation.stats.sharp * 100 + 0.5) .. "%, " .. math.floor (simulation.stats.serrated * 100 + 0.5) .. "%, " .. math.floor (simulation.stats.pierce * 100 + 0.5) .. "%", 925, 250)
    love.graphics.print ("(Sharp, Serrated, Pierce)", 925, 300)

    -- Renders the inventory
    for i = 1, #inventory do
        if i == selectedPart then
            love.graphics.setColor (0, 1, 0, 1)
        else
            love.graphics.setColor (1, 1, 1, 1)
        end
        
        love.graphics.print ("(" .. i .. ") " .. particles[i].name .. ": " .. inventory[i], 700, 300 + i * 25)
    end

    -- Renders info about the current part
    love.graphics.setColor (0, 1, 0, 1)
    love.graphics.printf (particles[selectedPart].desc, 700, 550, 225)

    -- Renders the cursor
    if mouseX >= 940 and mouseX < 1260 and mouseY >= 360 and mouseY < 680 then
        love.graphics.setColor (1, 1, 1, 1)
        love.graphics.setColor(1, 1, 1, 1)
	    love.graphics.rectangle("line", nearestX, nearestY, 20, 20)
    end
end

function thisScene:keypressed (key)
	if key == "u" then
        if mouseX >= 940 and mouseX < 1260 and mouseY >= 360 and mouseY < 680 then
            simulation.grid[mapX][mapY].health = simulation.grid[mapX][mapY].health - 10
            print (simulation.grid[mapX][mapY].health)
        end
    
    -- The user can select the material using the number keys
    elseif type (tonumber(key)) == "number" and tonumber(key) <= 8 then
        selectedPart = tonumber(key)
    end
end

return thisScene