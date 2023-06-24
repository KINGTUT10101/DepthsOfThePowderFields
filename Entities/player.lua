local controller = ...

local lastUpdate = 0
local maxWeight = 2000 -- The maximum weight of the weapon before getting over 2x speed multiplier
local midWeight = 1000 -- The maximum weight of the weapon before getting damage benefits

local name = "Player"

local entity = {
    name = name,
    id = 0,
    health = 100,
    size = 8,
    resistance = {0, 0, 0},
    collision = true,
}


function entity.whenSpawned (entity)
    entity:setLinearDamping (9)
    entity:setCollisionClass ("player")
    entity.attackCooldown = 0
end


function entity.act (entity, dt, stats)
    local x, y = entity:getPosition ()
    
    -- Player movement
    if love.keyboard.isDown ("w") == true then
        entity:applyForce(0, -1000)
    end

    if love.keyboard.isDown ("a") == true then
        entity:applyForce(-1000, 0)
    end

    if love.keyboard.isDown ("s") == true then
        entity:applyForce(0, 1000)
    end

    if love.keyboard.isDown ("d") == true then
        entity:applyForce(1000, 0)
    end

    -- Melee attack
    -- Only executes when the weapon isn't on cooldown, which depends on the weapon's weight
    lastUpdate = lastUpdate + dt
    if lastUpdate >= (stats.weight / maxWeight * 1) and (meleeToggle or love.keyboard.isDown ("space")) then
        damageDelt = 0
        
        -- Attacks all entities within range
        local colliders = world:queryCircleArea (x, y, 50, {"All", except = {"player"}})
        for _, collider in ipairs(colliders) do
            local realDamage = (stats.weight / midWeight * stats.damage)
            local resistance = collider.resistance
            local origHealth = collider.health
            
            -- Considers all the entities reistances
            -- Sharp
            collider.health = collider.health - ((1 - resistance[1]) * realDamage * stats.sharp)

            -- Serrated
            collider.health = collider.health - ((1 - resistance[2]) * realDamage * stats.serrated)

            -- Pierce
            collider.health = collider.health - ((1 - resistance[3]) * realDamage * stats.pierce)

            -- Basic blunt damage for when the weapon is baren
            if collider.health == origHealth then
                collider.health = collider.health - 0.1
            end

            if collider.health ~= math.huge then
                damageDelt = damageDelt + origHealth - collider.health
                -- Signals that the weapon should be damaged
                -- Using a global is lazy, but I'm out of time
                damageWeapon = true
            end

            if collider.health <= 0 then
                collider.killedByPlayer = true
            end

            local strength = 5000 * stats.weight / midWeight
            local objX, objY = collider:getPosition ()
            local dx = objX - x
            local dy = objY - y
            local distance = math.sqrt(dx^2 + dy^2)
            -- Normalize the vector pointing from the explosion center to the object
            dx = dx / distance
            dy = dy / distance
            -- Apply the knock-away force proportional to the object's distance from the center
            collider:setLinearVelocity (0, 0)
            collider:applyLinearImpulse (strength * dx / distance, strength * dy / distance)
        end

        -- Resets the cooldown
        lastUpdate = 0
    end
end


function entity.draw (x, y)
    love.graphics.setColor (1, 0, 0, 1)
    love.graphics.circle ("fill", x, y, 10)
end

return entity