-- Get user input
os.loadAPI("utils/mv")
local directions = mv.getDirections()
 
local tArgs = { ... }
if #tArgs < 3 then
  print( "Usage: mineRoom <height> <width> <depth>" )
  return
end

local height = tonumber(tArgs[1])
local width = tonumber(tArgs[2])
local depth = tonumber(tArgs[3])

print("I'm headed to the mine.  I plan to mine an area that is")
print("    " .. height .. " blocks tall, " .. width .. " blocks wide, and " .. depth .. " blocks deep.")
print("Don't forget my fuel in slot 1.")
io.write("Sound good to you? ")
io.flush()
local answer = io.read()
if answer == "no" then
    print("Allright.  Maybe some other time.")
    return
end

print("Continue...")

function goingDown()
  if height == -1 then
    success, data = turtle.inspectDown()
    return data ~= "minecraft:bedrock"
  else
    local deltaZ = mv.getLocDelta().z
    if -deltaZ <= height then
        return true
    end
    return false
  end
end

-- need to loop height, width, then depth
while goingDown() do

end