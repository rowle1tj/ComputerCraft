local tArgs = { ... }
if #tArgs < 3 then
  print( "Usage: mineRoom <height> <width> <depth>" )
  return
end

local height = tonumber(tArgs[1])
local width = tonumber(tArgs[2])
local depth = tonumber(tArgs[3])
local replaceFloor = tArgs[4]

print("Height: " .. height)
print("Width: " .. width)
print("Depth: " .. depth)
if replaceFloor then
  print("Replacing floor.")
end

function fuelCheck()
  local fuelLevel = turtle.getFuelLevel()
  if fuelLevel < 20 then
    turtle.select(1)
    if not turtle.refuel(1) then
      print("Can't find any fuel.")
    end
  end
end

function moveForward()
  while not turtle.forward() do
    turtle.dig()
    sleep(0.1)
  end
end

function moveUp()
  if turtle.detectUp() then
    turtle.digUp()
  end
  turtle.up()
end

local turnLeft = true
local floorsUsed = 0
local currentFloorInvPosition = 2

function replaceFloor(hCount)
  if hCount == 1 and replaceFloor then
    if turtle.detectDown() then
      turtle.digDown()
    end
    turtle.select(currentFloorInvPosition)
    turtle.placeDown()
    floorsUsed = floorsUsed + 1
    if floorsUsed == 64 then
      floorsUsed = 0
      currentFloorInvPosition = currentFloorInvPosition + 1
    end
  end
end

for hCount=1,height do
  for wCount=1,width do
    for dCount=1,depth-1 do
      fuelCheck()
      replaceFloor(hCount)
      moveForward()
    end

    if turnLeft then
      turtle.turnLeft()
      if wCount < width then
        replaceFloor(hCount)
        moveForward()
      end
      turtle.turnLeft()
    else
      turtle.turnRight()
      if wCount < width then
        replaceFloor(hCount)
        moveForward()
      end
      turtle.turnRight()
    end 
    turnLeft = not turnLeft
  end
  if hCount < height then
    -- Next Layer Up
    replaceFloor(hCount)
    moveUp()
  else
    -- Go back Home
    for cBack=1, height-1 do
      turtle.down()
    end
  end
  turnLeft = not turnLeft
  
end