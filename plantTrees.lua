-- Plants a whole forrest!  Configurable with 
-- width, depth, and how much space you want 
-- between each tree
local tArgs = { ... }
if #tArgs < 2 then
  print("Usage: manageGrove <width> <depth> [spacer]")
  return
end

local width = tonumber(tArgs[1])
local depth = tonumber(tArgs[2])
local spacer = 3

function fuelCheck()
  local fuelLevel = turtle.getFuelLevel()
  if fuelLevel < 20 then
    turtle.select(1)
    local data = turtle.getItemDetail()
    if data == nil or data.name ~= "minecraft:coal" then
      io.write("Need more fuel in slot 1.  Enter to continue.")
      io.flush()
      io.read()
    end
    turtle.refuel(1)
    print("Refueled!")
  end
end

function chopTree()
  local success, data = turtle.inspect()
  while not success do
    success, data = turtle.inspect()
  end
  while data.name ~= "minecraft:log" do
    success, data = turtle.inspect()
  end
  
  print("Tree detected... chopping.")
  turtle.dig()
  turtle.forward()
  while turtle.detectUp() == true do
    turtle.digUp()
    turtle.up()
  end
  while turtle.detectDown() == false do
    turtle.down()
  end
  turtle.forward()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.select(2)
  turtle.place()
  turtle.select(1)
  turtle.turnLeft()
  turtle.turnLeft()   
end

local turnLeft = true

function chopGrid()
  for cWidth=1, width do
    for cDepth=1, depth do
      fuelCheck()
      chopTree()
      turtle.suck()
      turtle.suckUp()
      if cDepth < depth then
        for cSpacer=1, spacer do
          turtle.forward()
        end
      end
    end
    if turnLeft then
      turtle.turnLeft()
    else
      turtle.turnRight()
    end
    if cWidth < width then
      for cSpacer=1, spacer+1 do
        turtle.forward()
      end
    end
    if turnLeft then
      turtle.turnLeft()
    else
      turtle.turnRight()
    end
  end

  
end

while true do
  chopGrid()
  turnLeft = not turnLeft
end