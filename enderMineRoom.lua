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
local replaceFloorBlock = tArgs[4]
local replaceRightWall = tArgs[5]
local replaceLeftWall = tArgs[6]
local replaceFrontWall = tArgs[7]
local replaceBackWall = tArgs[8]

--local answer
--repeat
--   io.write("continue with this operation (y/n)? ")
--   io.flush()
--   answer=io.read()
--until answer=="y" or answer=="n"

print("Height: " .. height)
print("Width: " .. width)
print("Depth: " .. depth)

local materialIncrements = {
  ["floor"] = {
    ["blocksUsed"] = 0,
    ["currentInvPosition"] = 2
  },
  ["wall"] = {
    ["blocksUsed"] = 0,
    ["currentInvPosition"] = 9
  }
}

function fuelCheck()
  local fuelLevel = turtle.getFuelLevel()
  if fuelLevel < 20 then
    turtle.select(1)
    while not turtle.refuel(1) do
      io.write("Please put fuel in slot 1 and press enter to continue.")
      io.flush()
      io.read()
    end
  end
end

local excludeItems = {
  "minecraft:cobblestone",
  "minecraft:dirt",
  "minecraft:gravel",
  "chisel:limestone",
  "chisel:andesite",
  "chisel:granite",
  "chisel:diorite"
}

function dropItems()
  for i=2, 16 do
    for n, text in pairs(excludeItems) do
      local itemInfo = turtle.getItemDetail(i)
        if itemInfo then
        if turtle.getItemDetail(i).name == text then
          turtle.select(i)
          turtle.drop()
        end
      end
    end
  end
end

function moveForward()
  while not mv.moveForward() do
    turtle.dig()
    sleep(0.1)
  end
end

function moveUp()
  while not mv.moveUp() do
    turtle.digUp()
    sleep(0.1)
  end
end

local turnLeft = true

function incrementMaterialUsed(materialType)
  materialIncrements[materialType]["blocksUsed"] = materialIncrements[materialType]["blocksUsed"] + 1
  if materialIncrements[materialType]["blocksUsed"]  == 64 then
    materialIncrements[materialType]["blocksUsed"] = 0
    materialIncrements[materialType]["currentInvPosition"] = materialIncrements[materialType]["currentInvPosition"] + 1
  end
end

function replaceFloor(hCount)
  if hCount == 1 and replaceFloorBlock then
    if turtle.detectDown() then
      turtle.digDown()
    end
    turtle.select(materialIncrements["floor"]["currentInvPosition"])
    turtle.placeDown()
    incrementMaterialUsed("floor")
  end
end

function replaceRightBlock(inventoryPosition)
  mv.turnRight()
  while turtle.detect() do
    turtle.dig()
    sleep(0.1)
  end
  turtle.select(materialIncrements["wall"]["currentInvPosition"])
  turtle.place()
  incrementMaterialUsed("wall")
  
  mv.turnLeft()
end

function replaceLeftBlock(inventoryPosition)
  mv.turnLeft()
  while turtle.detect() do
    turtle.dig()
    sleep(0.1)
  end
  turtle.select(inventoryPosition)
  turtle.place()
  incrementMaterialUsed("wall")

  mv.turnRight()
end

function replaceRight(wCount, hCount, replaceRightWall)
  if replaceRightWall and (wCount == 1 and (hCount % 2) == 1) then
    replaceRightBlock(materialIncrements["wall"]["currentInvPosition"])
  end
end

function replaceLeft(wCount, hCount, replaceRightWall)
  if replaceRightWall and wCount == width and (hCount % 2) == 0 then
    replaceLeftBlock(materialIncrements["wall"]["currentInvPosition"])
  end  
  if replaceLeftWall and wCount == 1 and (hCount % 2) == 0 then
    replaceLeftBlock(materialIncrements["wall"]["currentInvPosition"])
  end
end

function wallCheck(replaceRightWall, replaceLeftWall)
  local deltaX = mv.getLocDelta().x
  local deltaY = mv.getLocDelta().y

  -- Replace the Right Wall
  if deltaX == 0 and mv.getFacing() == directions.FRONT and replaceRightWall then
    replaceRightBlock(materialIncrements["wall"]["currentInvPosition"])
  elseif deltaX == 0 and mv.getFacing() == directions.BACK and replaceRightWall then
    replaceLeftBlock(materialIncrements["wall"]["currentInvPosition"])
  end

  -- Replace the Left Wall
  if deltaX == -(width - 1) and mv.getFacing() == directions.BACK and replaceLeftWall then
    replaceRightBlock(materialIncrements["wall"]["currentInvPosition"])
  elseif deltaX == -(width - 1) and mv.getFacing() == directions.FRONT and replaceLeftWall then
    replaceLeftBlock(materialIncrements["wall"]["currentInvPosition"])
  end
end

function frontBackWallCheck(replaceFrontWall)
  local deltaX = mv.getLocDelta().x
  local deltaY = mv.getLocDelta().y
  
  -- Replace front wall
  if deltaY == (depth - 1) and mv.getFacing() == directions.FRONT and replaceFrontWall then
    mv.turnLeft()
    replaceRightBlock(materialIncrements["wall"]["currentInvPosition"])
    mv.turnRight()
  elseif deltaY == (depth - 1) and mv.getFacing() == directions.BACK and replaceRightWall then
    mv.turnLeft()
    replaceLeftBlock(materialIncrements["wall"]["currentInvPosition"])
    mv.turnRight()
  end
  
  -- Replace back wall
  if deltaY == 0 and mv.getFacing() == directions.BACK and replaceBackWall then
    mv.turnLeft()
    replaceRightBlock(materialIncrements["wall"]["currentInvPosition"])
    mv.turnRight()
  elseif deltaY == 0 and mv.getFacing() == directions.FRONT and replaceBackWall then
    mv.turnLeft()
    replaceLeftBlock(materialIncrements["wall"]["currentInvPosition"])
    mv.turnRight()
  end
end

function createRoom(height, width, depth, replaceFloorBlock, replaceRightWall, replaceLeftWall, replaceFrontWall, replaceBackWall)
    for hCount=1,height do
      for wCount=1,width do
        for dCount=1,depth-1 do
          fuelCheck()
          replaceFloor(hCount)
          wallCheck(replaceRightWall, replaceLeftWall)
          frontBackWallCheck(replaceFrontWall, replaceBackWall)
          moveForward()

          dropItems()
        end

        replaceFloor(hCount)
        
        wallCheck(replaceRightWall, replaceLeftWall)
        frontBackWallCheck(replaceFrontWall, replaceBackWall)

        if turnLeft then
          mv.turnLeft()
          if wCount < width then
            moveForward()
          end
          mv.turnLeft()
        else
          mv.turnRight()
          if wCount < width then
            moveForward()
          end
          mv.turnRight()
        end 
        turnLeft = not turnLeft
        
      end
      if hCount < height then
        -- Next Layer Up
        replaceFloor(hCount)
        moveUp()
      else
        -- Go down to the main level
        for cBack=1, height-1 do
          mv.moveDown()
        end
      end
      turnLeft = not turnLeft
    end

    -- now clear the bottom layer of anything that has fallen
    if (height > 1) then
        createRoom(1, width, depth, false, false, false, false, false)
    end
end

createRoom(height, width, depth, false, false, false, false, false)