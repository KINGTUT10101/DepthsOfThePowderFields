-- Loads the libraries
--push = require ("Libraries.push")
local Slab = require("Libraries.Slab")
local lovelyToasts = require ("Libraries.lovelyToasts")
local screen = require ("Libraries.shack")
local sceneMan = require ("Libraries.sceneMan")
local fileMan = require ("Libraries.fileMan")
wf = require ("Libraries.windfield")


-- Declares / initializes the local variables
local overworld, tiles = love.filesystem.load ("overworld.lua") ()
local simulation, particles = love.filesystem.load ("simulation.lua") ()
local controller, entities = love.filesystem.load ("controller.lua") ()

local tutorialPage = 1
local tutorialImages = {
    love.graphics.newImage ("Textures/gameplay.png"),
    love.graphics.newImage ("Textures/weapon.png"),
    love.graphics.newImage ("Textures/enemies.png"),
    love.graphics.newImage ("Textures/tiles.png"),
}


-- Declares / initializes the global variables
world = wf.newWorld (0, 0, true)
meleeToggle = false
damageDelt = 0
medFont = love.graphics.newFont ("Fonts/VT323.ttf", 25)
damageWeapon = false
inventory = {10, 0, 0, 0, 0, 0, 0, 0}
enemiesLeft = 0
floor = 1
playerStats = {
    tilesMined = 0,
    kills = 0,
}
resetMap = false


-- Defines the functions



function love.load ()
	-- Sets an RNG seed
    math.randomseed(os.time())
    
    -- Sets up the font
    love.graphics.setFont (medFont)
    
    -- Sets up the world
    world:setQueryDebugDrawing (true)
    
    world:addCollisionClass ("player")
    world:addCollisionClass ("tile")
    world:addCollisionClass ("floating", {ignores = {"tile"}})
    world:addCollisionClass ("grounded")
    
    -- Loads the scenes
    sceneMan:newScene ("inGame", require ("Scenes.inGame"), Slab, entities, controller, simulation.stats) -- Handles general gamestate stuff, player controls, and enemies
    sceneMan:newScene ("map", require ("Scenes.map"), Slab, tiles, overworld) -- Handles the overworld system
    sceneMan:newScene ("weapon", require ("Scenes.weapon"), Slab, particles, simulation) -- Handles the weapon simulation

    sceneMan:push ("map")
    sceneMan:push ("weapon")
    sceneMan:push ("inGame")
end


function love.update (dt)
	if tutorialPage > 4 then
        Slab.Update (dt)
        screen:update (dt)
        sceneMan:update (dt)
        world:update(dt)
    end
end


function love.draw()
    if tutorialPage > 4 then
        --push:start()
            --love.graphics.setColor (options.game.backgroundColor)
            --love.graphics.rectangle ("fill", 0, 0, 1920, 1080)
            sceneMan:draw ()
            screen:apply()
            Slab.Draw ()
        --push:finish()
    else
        love.graphics.draw (tutorialImages[tutorialPage], 0, 0)
    end
end


function love.keypressed (key)
	if tutorialPage > 4 then
        sceneMan:keypressed (key)
    else
        tutorialPage = tutorialPage + 1
    end
end