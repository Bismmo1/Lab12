-- CONFIGURATION
-- Add your specific block names here
local colorMap = {
    ["minecraft:white_wool"] = "0",
    ["minecraft:black_wool"] = "1",
    ["minecraft:red_wool"]   = "2",
    ["minecraft:blue_wool"]  = "3",
    ["minecraft:yellow_wool"] = "4",
}

print("Starting Scan...")

-- Infinite loop that breaks only when it finds an invalid block
while true do
    -- 1. Scan the block below
    local success, data = turtle.inspectDown()

    -- 2. Check if the scan worked AND if the block is in our list
    if success and colorMap[data.name] then
        local number = colorMap[data.name]
        
        -- Print the number to the terminal
        print(number)
        
        -- 3. Move forward
        -- If the turtle hits a wall, it stops to prevent getting stuck
        if not turtle.forward() then
            print("Path blocked! Stopping.")
            break
        end
    else
        -- 4. STOP CONDITION
        -- If inspectDown() failed (air) or the color isn't in the map
        print("No valid color found below. Stopping.")
        break
    end
end
