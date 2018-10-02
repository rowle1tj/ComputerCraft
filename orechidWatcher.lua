turtle.select(1)

while true do
  success, data = turtle.inspect()
  if success and data.name ~= "minecraft:stone" then
    turtle.dig()
  end
  sleep(3)
end
