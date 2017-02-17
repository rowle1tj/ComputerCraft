function chopTree()
  local success, data = turtle.inspect()
  if data.name == "minecraft:log" then
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
    turtle.back()
    turtle.select(3)
    turtle.place()
    turtle.select(1)
  end
end