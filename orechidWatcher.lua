turtle.select(1)

-- wait for the block in front of it to not be stone
while true do
  success, data = turtle.inspect()
  if success and data.name ~= "minecraft:stone" then
    turtle.dig()
  end
  sleep(3)
end
