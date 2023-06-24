local controller = ...

local attackSpeed = 1
local damage = 5

local name = "Feral Slime"

local entity = {
    name = name,
    id = 3,
    health = 30,
    size = 9,
    resistance = {0.25, 0, 0.45},
    drops = {6, 6, 6},
    collision = false,
}


function entity.whenSpawned (entity)
    entity:setLinearDamping (0)
    entity:setCollisionClass ("grounded")
    entity.moveCooldown = 256
    entity.lastUpdate = 0
end


function entity.act (entity, dt)
    if entity.moveCooldown <= 0 then
        local x, y = controller.player:getPosition()
        local dx = x - entity:getX()
        local dy = y - entity:getY()
        local angle = math.atan2(dy, dx)
        local forceX = 35000 * math.cos(angle)
        local forceY = 35000 * math.sin(angle)

        entity:setLinearVelocity (0, 0)
        entity:applyForce(forceX, forceY)
        entity.moveCooldown = 256
    else
        entity.moveCooldown = entity.moveCooldown - 1
    end

    -- Attacks things around itself
    local x, y = entity:getPosition ()
    entity.lastUpdate = entity.lastUpdate + dt
    if entity.lastUpdate >= attackSpeed then
        local colliders = world:queryCircleArea (x, y, 40, {"player", "tile"})
        for _, collider in ipairs(colliders) do
            collider.health = collider.health - damage
        end

        entity.lastUpdate = 0
    end
end


function entity.draw (x, y)
    love.graphics.setColor (0, 1, 0, 1)
    love.graphics.circle ("fill", x, y, 7)
end

return entity