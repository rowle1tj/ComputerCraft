-- set the initial x,y,z
local origin = {
  x = 0,
  y = 0,
  z = 0
}

local locDelta = {
  x = 0,
  y = 0,
  z = 0
}

local directions = {
  FRONT = 1,
  RIGHT = 2,
  BACK = 3,
  LEFT = 4
}

local facing = directions.FRONT

function getFacing()
  return facing
end

function getLocDelta()
  return locDelta
end

function getDirections()
  return directions
end

function printLocation()
  local direction
  if facing == directions.FRONT then
    direction = "Front"
  elseif facing == directions.RIGHT then
    direction = "Right"
  elseif facing == directions.BACK then
    direction = "Back"
  elseif facing == directions.LEFT then
    direction = "Left"
  end
  print("I am facing ", direction)
  print("locDelta")
  print(" X:", locDelta.x)
  print(" Y:", locDelta.y)
  print(" Z:", locDelta.z)
end

function moveForward()
  local r = turtle.forward()
  if not r then
    return r
  end
  if facing == directions.FRONT then
    locDelta.y = locDelta.y + 1
  elseif facing == directions.RIGHT then
    locDelta.x = locDelta.x + 1
  elseif facing == directions.BACK then
    locDelta.y = locDelta.y - 1
  elseif facing == directions.LEFT then
    locDelta.x = locDelta.x - 1
  end
  return r
end

function moveBackward()
  local r = turtle.back()
  if not r then
    return r
  end
  if facing == directions.FRONT then
    locDelta.y = locDelta.y - 1
  elseif facing == directions.RIGHT then
    locDelta.x = locDelta.x - 1
  elseif facing == directions.BACK then
    locDelta.y = locDelta.y + 1
  elseif facing == directions.LEFT then
    locDelta.x = locDelta.x + 1
  end
  return r
end

function moveUp()
  if turtle.up() then
    locDelta.z = locDelta.z + 1
    return true
  else
    return false
  end
end

function moveDown()
  if turtle.down() then
    locDelta.z = locDelta.z - 1
    return true
  else
    return false
  end
end

function mineForward()
  while not moveForward() do
    turtle.dig()
    sleep(0.1)
  end
end

function mineUp()
  while not moveUp() do
    turtle.digUp()
    sleep(0.1)
  end
end

function mineDown()
  while not moveDown() do
    turtle.digDown()
    sleep(0.1)
  end
end

function turnRight()
  facing = facing + 1
  if facing == 5 then
    facing = 1
  end
  turtle.turnRight()
end

function turnLeft()
  facing = facing - 1
  if facing == 0 then
    facing = 4
  end
  turtle.turnLeft()
end

function replaceRightBlock(inventoryPosition)
  turnRight()
  while turtle.detect() do
    turtle.dig()
    sleep(0.1)
  end
  turtle.select(inventoryPosition)
  turtle.place()
  
  mv.turnLeft()
end

function replaceLeftBlock(inventoryPosition)
  turnLeft()
  while turtle.detect() do
    turtle.dig()
    sleep(0.1)
  end
  turtle.select(inventoryPosition)
  turtle.place()

  turnRight()
end

function checkFuel()
  local fuelLevel = turtle.getFuelLevel()
  if fuelLevel < 20 then
    turtle.select(1)
    if not turtle.refuel(1) then
      print("Can't find any fuel.")
      return false
    end
  end
  return true
end