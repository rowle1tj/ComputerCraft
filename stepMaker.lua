os.loadAPI("utils/mv")

function mineStep()
  mv.checkFuel()
  mv.mineDown()
  mv.mineForward()
  turtle.digUp()
end

mv.moveForward()

function stairUp()
  mv.checkFuel()
  mv.mineForward()
  turtle.dig()
  mv.mineForward()
  turtle.select(5)
  turtle.place()
  mv.moveBackward()
  turtle.select(9)
  turtle.place()
  mv.moveUp()
end

result, deets = turtle.inspectDown()
while deets.name ~= "minecraft:bedrock" do
  mineStep()
  result, deets = turtle.inspectDown()
end

mv.turnLeft()
mv.turnLeft()

local deltas = mv.getLocDelta()
local done = (deltas.x == 0 or deltas.x == -1) and (deltas.y == -1 or deltas.y == 0) and deltas.z == 0

while not done do
  stairUp()
  deltas = mv.getLocDelta()
  done = (deltas.x == 0 or deltas.x == -1 or deltas.x == 1) and (deltas.y == -1 or deltas.y == 0 or deltas.y == 1) and (deltas.z == 0)
end
mv.printLocation()
