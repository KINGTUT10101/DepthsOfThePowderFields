local tiles = {}

-- Loads in the tiles
local files =  love.filesystem.getDirectoryItems ("Tiles")
for _, v in pairs (files) do
    local chunk = love.filesystem.load ("Tiles/" .. v)
    if chunk ~= nil then
        local name, tile = chunk ()
        tiles[tile.id] = tile
    end
end

local overworld = {
    grid = {},
    size = 32,
}
local grid = overworld.grid


-- Initializes the map
for i = 1, overworld.size do
    grid[i] = {}
    for j = 1, overworld.size do
        -- Spawns an air particle
        grid[i][j] = {
            id = 0,
            health = math.huge,
            resistance = tiles[0].resistance
        }
    end
end


-- Clears the map and fills it with air tiles
function overworld.clear ()
    local colliders = world:queryRectangleArea (60, 60, 600, 600, {"tile"})
    for _, collider in ipairs(colliders) do
        collider:destroy ()
    end
    
    for i = 1, overworld.size do
        for j = 1, overworld.size do
            if i == 1 or i == overworld.size or j == 1 or j == overworld.size then
                -- Spawns a wall particle
                grid[i][j] = world:newRectangleCollider ((i * 20) + 20, (j * 20) + 20, 20, 20)

                grid[i][j]:setType ("static")
                grid[i][j]:setCollisionClass ("tile")
                grid[i][j].id = 1
                grid[i][j].health = math.huge
                grid[i][j].resistance = tiles[1].resistance
            else
                -- Spawns an air particle
                grid[i][j] = {
                    id = 0,
                    health = math.huge,
                    resistance = tiles[0].resistance,
                }
            end
        end
    end
end


function overworld.spawn (id, x, y)
    local result = false
    
    if x >= 1 and x <= overworld.size and y >= 1 and y <= overworld.size then
        grid[x][y] = world:newRectangleCollider ((x * 20) + 20, (y * 20) + 20, 20, 20)

        grid[x][y]:setType ("static")
        grid[x][y]:setCollisionClass ("tile")
        grid[x][y].id = id
        grid[x][y].health = tiles[id].health
        grid[x][y].resistance = tiles[id].resistance

        result = true
    end

    return result
end


function overworld.delete (x, y)
    local result = false
    
    if x >= 1 and x <= overworld.size and y >= 1 and y <= overworld.size then
        if grid[x][y].id > 0 then
            grid[x][y]:destroy ()
        end
        
        grid[x][y] = {
            id = 0,
            health = math.huge,
        }

        result = true
    end

    return result
end


function overworld.move (x, y)

end


function overworld.explode (x, y)

end


function overworld.ignite (x, y)

end


return overworld, tiles