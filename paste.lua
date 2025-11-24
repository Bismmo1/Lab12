
local url = "https://cedar.fogcloud.org/api/logs/d5A5"


print("Checking URL")
local response = http.get(url)

if not response then
    print("bad URL")
    return
end

local rawData = response.readAll()
response.close()

print("Data received: " .. rawData) 
local slotMap = {
    ["0"] = 1, -- White
    ["1"] = 2, -- Black
    ["2"] = 3, -- Red
    ["3"] = 4, -- Blue
    ["4"] = 5, -- Yellow
}

local currentDistance = 0


local function returnAndShift()
    print("Nex Row")
    
    turtle.turnRight()
    turtle.turnRight()

    for i = 1, currentDistance do
        turtle.forward()
    end

    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()

    currentDistance = 0
end

local function placeBlock(val)
    local slot = slotMap[val]
    
    if slot then
        turtle.select(slot)
        turtle.digDown() 
        if turtle.placeDown() then
            if turtle.forward() then
                currentDistance = currentDistance + 1
            else
                print("cant get a goin")
            end
        else
            print("out of blocks " .. slot)
        end
    end
end


print("Starting Print Job...")

for i = 1, #rawData do

    local char = string.sub(rawData, i, i)

    if char == "x" then
        returnAndShift()
    elseif slotMap[char] then
        placeBlock(char)
    end
end

print("Job done")
