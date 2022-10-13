turtle.refuel()
 for a=1,50 do
 
  while not turtle.detect()
  do
    turtle.forward()
  end
   turtle.dig()
   turtle.forward()
   turtle.digDown()
   turtle.turnRight()

  for b=1,50 do
   turtle.dig()
   turtle.forward()
   turtle.digUp()
   turtle.digDown()
  end

   turtle.turnRight()
   turtle.turnRight()

  while not turtle.detectUp() do
   if turtle.detect()==true then
	   turtle.dig()
	  else
       turtle.forward()
      end
  end

    turtle.turnLeft()

   while not turtle.detect() do
      turtle.forward()
      
   end
    
	for i=1, 16 do
     turtle.select(i)
     turtle.drop()
   end
   
   turtle.turnLeft()
   turtle.turnLeft()
 end