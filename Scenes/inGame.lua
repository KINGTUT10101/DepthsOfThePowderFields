local thisScene = {}

local sceneMan, Slab, entities, controller, stats

local music = {}
local currentTrack
local ambientMusic = love.audio.newSource ("Moments - Only one Soundtrack.mp3", "stream")

-- Defines the functions
local keyTracker = {}
-- This algorithm will choose a random value from a table without repeating the same value twice
local function keyNoRepeats (table)
    keyTracker[table] = keyTracker[table] or {}
    
    -- Picks the next element of the table
    local lastKey = keyTracker[table]
    keyTracker[table] = math.random (1, #table)
    -- Checks for repeats
    if keyTracker[table] == lastKey then
        keyTracker[table] = (keyTracker[table] - 1 == 0) and keyTracker[table] + 1 or keyTracker[table] - 1
    end
    
    return keyTracker[table]
end

function thisScene:load (...)
    sceneMan, Slab, entities, controller, stats = ...
    
    controller.spawnPlayer (16.5, 16.5)

    -- Loads the music
    local musicFolder = love.filesystem.getDirectoryItems ("Music")
	for k, v in pairs (musicFolder) do
		music[#music + 1] = love.audio.newSource ("Music/" .. v, "stream")
	end
    currentTrack = music[keyNoRepeats (music)]
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    if controller.player.health > 0 then
        -- Updates the player
        entities[0].act (controller.player, dt, stats)

        -- Updates all the entities
        for i = 1, #controller.active do
            if controller.active[i] ~= nil then
                -- Executes the act method
                entities[controller.active[i].id].act (controller.active[i], dt)

                -- Checks if the entity is dead
                if controller.active[i].health <= 0 then
                    -- Gives the player some drops
                    local drops = entities[controller.active[i].id].drops

                    for i = 1, #drops do
                        if math.random () < 1/#drops then
                            inventory[drops[i]] = inventory[drops[i]] + 1
                        end
                    end

                    enemiesLeft = enemiesLeft - 1
                    playerStats.kills = playerStats.kills + 1
                    
                    controller.delete (i)
                end
            end
        end

        -- Plays the background music
        if currentTrack:isPlaying () == false then
            if enemiesLeft == 0 then
                currentTrack = ambientMusic
            else
                currentTrack = music[keyNoRepeats (music)]
            end
            love.audio.play (currentTrack)
        elseif currentTrack == ambientMusic and enemiesLeft > 0 then
            love.audio.stop( )
            currentTrack = music[keyNoRepeats (music)]
            love.audio.play (currentTrack)
        elseif currentTrack ~= ambientMusic and enemiesLeft <= 0 then
            love.audio.stop( )
            currentTrack = ambientMusic
            love.audio.play (currentTrack)
        end
    elseif currentTrack ~= ambientMusic or currentTrack:isPlaying () == false then
        love.audio.stop( )
        currentTrack = ambientMusic
        love.audio.play (currentTrack)
    end
end

function thisScene:draw ()
    -- Draws the player
    entities[0].draw (controller.player:getPosition ())
    
    -- Draws all the entities
    for i = 1, #controller.active do
        entities[controller.active[i].id].draw (controller.active[i]:getPosition ())
    end

    -- Displays the damage the player just dealt
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.print ("Total Damage \nDealt: " .. math.floor (damageDelt * 10) / 10 .. " HP", 700, 250)

    -- Displays the FPS
    love.graphics.print ("FPS: " .. love.timer.getFPS (), 1175, 10)

    -- Displays the player's health
    love.graphics.setColor (1 - controller.player.health / 100, controller.player.health / 100, 0, 1)
    love.graphics.print ("Player: " .. controller.player.health .. " HP", 700, 40)

    -- Displays the current floor and number of enemies left
    love.graphics.setColor (1, 1, 1, 1)
    love.graphics.print ("Floor " .. floor, 700, 80)
    love.graphics.print ("Enemies " .. enemiesLeft, 700, 120)

    if enemiesLeft == 0 then
        love.graphics.setColor (1, 0, 0, 1)
        love.graphics.rectangle ("fill", 700, 170, 200, 50)

        love.graphics.setColor (1, 1, 1, 1)
        love.graphics.print ("Press ENTER to \nstart another wave! ", 700, 170)
    end

    -- TEMP
    love.graphics.setColor (1, 1, 1, 1)
    world:draw()

    -- Draws the game over screen
    if controller.player.health <= 0 then
        love.graphics.setColor (1, 0.1, 0.1, 1)
        love.graphics.rectangle ("fill", 40, 40, 640, 640)

        love.graphics.setColor (1, 1, 1, 1)
        love.graphics.printf ("The Lunar Powder Fields leave no survivors!", 220, 100, 300, "center")
        love.graphics.printf ("May your next life get you closer to the core...", 220, 150, 300, "center")
        love.graphics.printf ("You made it to floor " .. floor, 220, 300, 300, "center")
        love.graphics.printf ("Tiles Mined: " .. playerStats.tilesMined, 220, 350, 300, "center")
        love.graphics.printf ("Enemies Killed: " .. playerStats.kills, 220, 400, 300, "center")

        
        love.graphics.printf ("Push R to restart", 220, 600, 300, "center")
    end
end

function thisScene:keypressed (key)
	if key == "/" then
        --controller.spawn (3, 10, 10)

    elseif key == "k" then
        --controller.player.health = 0
    
    elseif key == "q" then
        meleeToggle = not meleeToggle

    -- Resets the game
    elseif key == "r" and controller.player.health <= 0 then
        playerStats = {
            tilesMined = 0,
            kills = 0,
        }

        floor = 1
        inventory = {10, 0, 0, 0, 0, 0, 0, 0}
        enemiesLeft = 0
        damageWeapon = false
        controller.player.health = 100
        resetMap = true

        print (#controller.active)
        for i = #controller.active, 1, -1 do
            controller.delete (i)
        end
    
    -- Teleports the player to the center of the map and spawns a wave of enemies
    elseif key == "return" and enemiesLeft == 0 then
        controller.player:setPosition(16.5 * 20 + 20, 16.5 * 20 + 20)
        --controller.player.health = 100

        for i = 1, math.random (1, 3) do
            -- Chooses a wave to spawn
            local count = controller.waves[math.random (1, #controller.waves)][1]
            local id = controller.waves[math.random (1, #controller.waves)][2]

            for j = 1, count do
                -- Chooses a location to spawn in
                if math.random () < 0.50 then
                    controller.spawn (id, 2, math.random (2, 32))
                else
                    controller.spawn (id, 31, math.random (2, 32))
                end

                enemiesLeft = enemiesLeft + 1
            end
        end
    end
end

return thisScene