-- This script needs a crafting turtle to work.
-- It will craft all the flowers in slot 1
-- And output the petals into slot 2

function dropInventory()
  turtle.select(2)
  turtle.drop()
end

function craftDyes()
  turtle.select(1)
  numPetals = turtle.getItemCount()
  for i=0, numPetals do
    turtle.select(2)
    turtle.craft()
    dropInventory()
    turtle.select(1)
  end
end

dropInventory()
craftDyes()

while true do
  local success = turtle.suckDown()
  if success then
    craftDyes()
  end
  os.sleep(0.2)
end
