local controller = {
    active = {},
    player = {},
    waves = {
        {5, 3},
        {6, 1},
        {2, 3},
        {6, 4},
        {2, 4},
        {8, 3},
        {9, 1},
    }
}


local entities = {}

-- Loads in the tiles
local files =  love.filesystem.getDirectoryItems ("Entities")
for _, v in pairs (files) do
    local chunk = love.filesystem.load ("Entities/" .. v)
    if chunk ~= nil then
        local entity = chunk (controller)
        entities[entity.id] = entity
    end
end


-- Spawns an entity
function controller.spawn (id, x, y)
    controller.active[#controller.active + 1] = world:newCircleCollider ((x * 20) + 30, (x * 20) + 30, entities[id].size)
    controller.active[#controller.active].id = id
    controller.active[#controller.active].health = entities[id].health
    controller.active[#controller.active].resistance = entities[id].resistance

    entities[id].whenSpawned (controller.active[#controller.active])
end


-- Spawns the player and sets a value in the controller so other entities can track its position
function controller.spawnPlayer (x, y)
    controller.player = world:newCircleCollider ((x * 20) + 30, (x * 20) + 30, entities[0].size)
    controller.player.id = 0
    controller.player.health = entities[0].health

    entities[0].whenSpawned (controller.player)
end


function controller.delete (index)
    controller.active[index]:destroy ()
    table.remove (controller.active, index)
end


return controller, entities