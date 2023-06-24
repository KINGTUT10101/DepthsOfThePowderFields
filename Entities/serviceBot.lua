local controller = ...

local attackSpeed = 2
local damage = 10

local name = "Service Bot"

local entity = {
    name = name,
    id = 4,
    health = 60,
    size = 8,
    resistance = {0.90, 0.65, 0},
    drops = {1, 1, 1, 1, 2, 3, 1, 2},
    collision = false,
}


function entity.whenSpawned (entity)
    entity:setLinearDamping (6.5)
    entity:setCollisionClass ("grounded")
    entity.lastUpdate = 0
    entity.moveCooldown = 256
end


function entity.act (entity, dt)
    if entity.moveCooldown <= 0 then
        local x, y = controller.player:getPosition()
        local dx = x - entity:getX()
        local dy = y - entity:getY()
        local angle = math.atan2(dy, dx)
        local forceX = 800 * math.cos(angle)
        local forceY = 800 * math.sin(angle)

        --entity:setLinearVelocity (0, 0)
        entity:applyForce(forceX, forceY)
        entity.moveCooldown = 2
    else
        entity.moveCooldown = entity.moveCooldown - 1
    end

    -- Attacks things around itself
    local x, y = entity:getPosition ()
    entity.lastUpdate = entity.lastUpdate + dt
    if entity.lastUpdate >= attackSpeed then
        local colliders = world:queryCircleArea (x, y, 50, {"player", "tile"})
        for _, collider in ipairs(colliders) do
            collider.health = collider.health - damage
        end

        entity.lastUpdate = 0
    end
end


function entity.draw (x, y)
    love.graphics.setColor (0.25, 0.25, 0.35, 1)
    love.graphics.circle ("fill", x, y, 8)
end

return entity