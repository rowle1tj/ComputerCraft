function findInventorySlot()
  for i=1,16 do
    if turtle.getItemCount(i) > 0 then
      return i
    end
  end
  return 1
end

local cakesPlaced = 0
local turnLeft = true
while true do
  if not turtle.detect() then
    turtle.select(findInventorySlot())
    if turtle.getItemCount() > 0 and turtle.place() then
      cakesPlaced = cakesPlaced + 1
      print("I've placed ", cakesPlaced, " cakes.")
    end
    if turnLeft then
      turtle.turnLeft()
    else
      turtle.turnRight()
    end
    turnLeft = not turnLeft
  end
  sleep(2)
end
