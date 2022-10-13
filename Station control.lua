--Import lib
local component = require("component")
local sides = require("sides")
local colors = require("colors")
local os = require("os")
local term = require("term")
local event = require("event")
--Import components
local rs = component.redstone
local gpu = component.gpu

while true do
--Get occupancy railway
secondWay = rs.getBundledInput(sides.east, colors.lightblue)
firstWay = rs.getBundledInput(sides.east, colors.yellow)
 
secondStationWay = rs.getBundledInput(sides.east, colors.orange)
firstStationWay = rs.getBundledInput(sides.east, colors.white)
 
switchonetwo = rs.getBundledInput(sides.east, colors.magenta)

getPosSwitchOne = rs.getBundledInput(sides.north, colors.orange)
getPosSwitchTwo = rs.getBundledInput(sides.north, colors.white)
 
--Paint on the screen
term.clear()
gpu.setForeground(0xffffff)
gpu.set(1, 3, "]")
gpu.set(1, 6, "]")


if secondStationWay == 0 then
  gpu.setForeground(0x00ff00)
  gpu.set(2, 3, "═══════")    
else
  gpu.setForeground(0xff0000)
  gpu.set(2, 3, "═══════") 
end

if firstStationWay == 0 then
  gpu.setForeground(0x00ff00)
  gpu.set(2, 6, "═══════")    
else
  gpu.setForeground(0xff0000)
  gpu.set(2, 6, "═══════") 
end

if switchonetwo == 0 then
  gpu.setForeground(0x00ff00)   
else
  gpu.setForeground(0xff0000)
end

if getPosSwitchTwo ~= 0 then
	gpu.set(10, 3, "═════")
else
    gpu.set(10, 3, "  ╔══")
	gpu.set(10, 4, "  ║")
end

if getPosSwitchOne ~= 0 then
	gpu.set(10, 6, "═════")
else
	gpu.set(10, 5, "  ║")
	gpu.set(10, 6, "══╝")
end

if secondWay == 0 then
  gpu.setForeground(0x00ff00)
  gpu.set(16, 3, "═══════")    
else
  gpu.setForeground(0xff0000)
  gpu.set(16, 3, "═══════") 
end

if firstWay == 0 then
  gpu.setForeground(0x00ff00)
  gpu.set(16, 6, "═══════")    
else
  gpu.setForeground(0xff0000)
  gpu.set(16, 6, "═══════") 
end

local _,_,x,y= event.pull("touch")

	if (x>9) and (x<16) then
		if (y==3) or (y==4) then
			gpu.set(1, 20, "Touch 2")
		elseif (y==5) or (y==6) then	
			gpu.set(1, 20, "Touch 1")
		
	end
end

end