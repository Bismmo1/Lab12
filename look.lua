
local t = 0
local linesScanned = 0
local url = "https://cedar.fogcloud.org/api/logs/F0A0"

local colorMap = {
    ["minecraft:white_wool"] = "0",
    ["minecraft:black_wool"] = "1",
    ["minecraft:red_wool"]   = "2",
    ["minecraft:blue_wool"]  = "3",
    ["minecraft:yellow_wool"] = "4",
}

local function go(val)

    local body = "line=" .. tostring(val)
    
    print("Uploading: " .. body)
    local response, message = http.post(url, body)
    
    if response then
e
        response.close()
    else
        print("Upload failed: " .. tostring(message))
    end


    local success, move_msg = turtle.forward()
    if success then
        t = t + 1
    end
    return success, move_msg
end
local function back()
    turtle.turnRight()
    turtle.turnRight()
    for i = 1, t do
        turtle.forward()
    end
    turtle.turnLeft()
    local current_t = t
    t = 0 
    linesScanned = linesScanned + 1 
    return current_t
end


print("Starting Scan...")

local should_stop_program = false

while true do
    if should_stop_program then break end

    local success, data = turtle.inspectDown()
    
    if not success or not data or not colorMap[data.name] then
        print("Invalid start block. Stopping.")
        break 
    end

    local currentNumber = colorMap[data.name]
    print("Start of line color: " .. currentNumber)

    while true do

        local move_success = go(currentNumber)

        local line_break_reason = nil 

        if not move_success then
            print("Hit wall. Returning.")
            line_break_reason = "wall"
        else
            local scan_success, scan_data = turtle.inspectDown()

            if not scan_success or not scan_data or not colorMap[scan_data.name] then
                print("Invalid block mid-line. Returning.")
                line_break_reason = "invalid_block"
            else
                currentNumber = colorMap[scan_data.name]
            end
        end

        if line_break_reason then
            back() 

            local sidemove_success = turtle.forward()

            if not sidemove_success then
                print("Cannot move sideways. Done.")
                should_stop_program = true 
            else
                turtle.turnLeft() 
            end
            
            break
        end
    end
end

print("Finished. Lines: " .. linesScanned)
