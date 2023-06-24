local fileMan = {}

-- Recursively finds lua files within a directory and returns a table of chunks with a starting index of 1
-- If a chunk can't be loaded (usually due to a syntax error) the function will print a message and set its entry to false
function fileMan.recursiveChunks (directory, chunks)
    local files =  love.filesystem.getDirectoryItems (directory)
    chunks = chunks or {}
    
    for _, v in pairs (files) do
        local fileType = love.filesystem.getInfo (directory .. "/" .. v).type
        
        -- Checks file type
        if fileType == "directory" then
            fileMan.recursiveChunks (directory .. "/" .. v, chunks)
        elseif fileType == "file" and v:sub (-4, #v) == ".lua" then
            local status, tempChunk, error = pcall (love.filesystem.load, directory .. "/" .. v)

            if error == nil and status == true then
                chunks[#chunks + 1] = tempChunk
            else
                print (tempChunk)
                chunks[#chunks + 1] = false
            end
        end
    end
    
    return chunks
end

return fileMan