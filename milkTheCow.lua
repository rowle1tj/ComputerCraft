-- Iterate all the inventory locations to look for a bucket
function getBucketInv()
  for i=1,16 do
    data = turtle.getItemDetail(i)
    if data then
      if data.name == "minecraft:bucket" then
        return i
      end
    end
  end
  return false
end

local inv = 1
while true do
  inv = getBucketInv()
  if inv then
    turtle.select(inv)
    turtle.place()
  end
  sleep(1)
end
print(getBucketInv())
