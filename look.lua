-- CONFIGURATION
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

-- FIXED: go() now accepts 'val' (the number to upload)
local function go(val)
    -- Use the passed value 'val', not the invisible 'number'
    local body = "line=" .. tostring(val)
    
    print("Uploading: " .. body)
    local response, message = http.post(url, body)
    
    if response then
        -- response.close() -- Good practice to close, but keeping it simple
        response.close()
    else
        print("Upload failed: " .. tostring(message))
    end

    -- Move after uploading
    local success, move_msg = turtle.forward()
    if success then
        t = t + 1
    end
    return success, move_msg
end

-- BACK FUNCTION (Kept exactly as you had it)
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

    -- 1. Scan start of the line
    local success, data = turtle.inspectDown()
    
    if not success or not data or not colorMap[data.name] then
        print("Invalid start block. Stopping.")
        break 
    end

    -- Get the CURRENT number
    local currentNumber = colorMap[data.name]
    print("Start of line color: " .. currentNumber)

    -- LINE SCAN LOOP
    while true do

        -- 2. Call go() WITH the current number
        local move_success = go(currentNumber)

        local line_break_reason = nil 

        if not move_success then
            print("Hit wall. Returning.")
            line_break_reason = "wall"
        else
            -- 3. We moved forward! Now we must Scan the NEW block
            local scan_success, scan_data = turtle.inspectDown()

            if not scan_success or not scan_data or not colorMap[scan_data.name] then
                print("Invalid block mid-line. Returning.")
                line_break_reason = "invalid_block"
            else
                -- IMPORTANT: Update currentNumber so the NEXT go() uses the new color
                currentNumber = colorMap[scan_data.name]
            end
        end

        -- 4. Handle Return Trip
        if line_break_reason then
            back() 

            -- Move Sideways to next row
            local sidemove_success = turtle.forward()

            if not sidemove_success then
                print("Cannot move sideways. Done.")
                should_stop_program = true 
            else
                turtle.turnLeft() -- Face the new row
            end
            
            break -- Break inner loop to restart outer loop
        end
    end
end

print("Finished. Lines: " .. linesScanned)
