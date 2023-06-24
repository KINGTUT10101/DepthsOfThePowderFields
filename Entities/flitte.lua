local controller = ...

local attackSpeed = 0.5
local damage = 2

local name = "Flitte"

local entity = {
    name = name,
    id = 1,
    health = 3,
    size = 7,
    resistance = {0, 0.15, 0.75},
    drops = {5, 4, 4, 7},
    collision = false,
}


function entity.whenSpawned (entity)
    entity:setLinearDamping (1)
    entity:setCollisionClass ("floating")
    entity.lastUpdate = 0
    entity.moveCooldown = 256
end


function entity.act (entity, dt)
    if entity.moveCooldown <= 0 then
        local x, y = controller.player:getPosition()
        local dx = x - entity:getX()
        local dy = y - entity:getY()
        local angle = math.atan2(dy, dx)
        local forceX = 400 * math.cos(angle)
        local forceY = 400 * math.sin(angle)

        --forceX = forceX > 0 and math.min (forceX, 600) or math.max (forceX, -600)
        --forceY = forceY > 0 and math.min (forceY, 600) or math.max (forceY, -600)

        entity:applyForce(forceX, forceY)
        entity.moveCooldown = 1
    else
        entity.moveCooldown = entity.moveCooldown - 1
    end

    -- Attacks things around itself
    local x, y = entity:getPosition ()
    entity.lastUpdate = entity.lastUpdate + dt
    if entity.lastUpdate >= attackSpeed then
        local colliders = world:queryCircleArea (x, y, 30, {"player", "tile"})
        for _, collider in ipairs(colliders) do
            collider.health = collider.health - damage
        end

        entity.lastUpdate = 0
    end
end


function entity.draw (x, y)
    love.graphics.setColor (0.45, 0, 0.80, 1)
    love.graphics.circle ("fill", x, y, 7)
end

return entity