-- Низ-0, верх-1, сзади-2, перед-3, право-4, лево-5.
local side = 0
-- Номер слота, в котором лежит стержень, если все схемы разные-ставьте 0 (не работает)
local slot = 22
-- Автозамена стержней(на будущее)
--local autoChange = 0


-- Обьявление библиотек
local version = "0.4"
local os = require("os")
local component = require("component")
local sides = require("sides")
local math = require("math")
local term = require("term")
local event = require("event")

-- Обьявление компонентов
local gpu = component.gpu
-- Раcкомментировать для использования очков AR (не работает)
--local glasses = component.glasses 

-- Массив данных с адрессами реакторов и инвентарей реакторов 
-- statistic - адресс реактора, inventory - адресс контроллера инвентаря

local reactor = {  
  r1 = {  
    statistic = "e7e5119c-f89c-413a-8860-3c857426c303",  
	inventory = "f6d4f92c-4bea-4500-8105-3243cb4e9ddd"  
  }, 
  r2 = {  
    statistic = "c6b55c97-677e-4e2e-8671-d0ea9456402f",  
	inventory = "2b94b239-11de-40b1-936f-10b491ac8a23"  
  },
  r3 = {  
    statistic = "5e1cf1d3-d01c-4ef9-bbe4-9d62a3df6d72",  
	inventory = "a445b4ff-dd8f-4e4d-bccd-bfe48b232b39" 
  },
  r4 = {  
    statistic = "e9d92feb-8f29-47a5-a61a-3a047befcb05",  
	inventory = "a6019959-3d34-4f12-a76c-5b4ace0098d8"  
  },
  r5 = {  
    statistic = "66418556-5823-4ca4-842d-05870f651e26",  
	inventory = "096f0a3e-9acd-466c-a39a-3aed3b58ce06"  
  },
  reactor6 = {  
    statistic = "13879e6c-5e64-4c7a-8893-c2043647b153",  
	inventory = "5f82f103-d01c-45c2-b6d5-b1fbc155a465"  
  },
  reactor7 = {  
    statistic = "9903629d-ff29-4b7a-bb11-8a20506b3a71",  
	inventory = "f68cf793-4c54-4fe0-9076-3bb411cb56e7"  
  },
  reactor8 = {  
    statistic = "2b6663c4-6e28-4888-bc8b-690512553c86",  
	inventory = "d38b17d0-515c-4b34-a3dd-4216d3ec938f"  
  }
};

local clearCords = {
	r1 = {2, 4, 15, 9}, 
    r2 = {18, 4, 15, 9},   
    r3 = {34, 4, 15, 9},
    r4 = {50, 4, 15, 9},
    r5 = {66, 4, 14, 9},
    r6 = {2, 16, 15, 9},
    r7 = {18, 16, 15, 9},
    r8 = {34, 16, 15, 9},
    r9 = {50, 16, 15, 9},
    r10 = {66, 16, 14, 9}
};

--Координаты надписей

local coords = {
	r1 = {
        coordsA = {3, 5},
        coordsV = {4, 6},
        coordsO = {4, 8},
        coordsT = {5, 9}
    }; 
    --2 = {
    --    coordsA = 
    --    coordsV =
    --    coordsO =
    --};
};

--Вспомогательная часть

local statusReactor = {r1=0, r2=0, r3=0, r4=0, r5=0, r6=0, r7=0, r8=0, r9=0, r10=0};



--Выставление разрешения экрана
gpu.setResolution(80, 25)
--Цвет экрана
gpu.setBackground(0X0000FF)
--Очистка экрана
term.clear()

--Нанесение разметки на экране
gpu.set(1, 1, "╔═══════════════╤═══════════════╤═══════════════╤═══════════════╤══════════════╗")
gpu.set(1, 25,"╚═══════════════╧═══════════════╧═══════════════╧═══════════════╧══════════════╝")

for i = 2, 24 do
	gpu.set(1, i, "║")
	gpu.set(80, i, "║")
    
    gpu.set(17, i, "│")
	gpu.set(33, i, "│")
    gpu.set(49, i, "│")
	gpu.set(65, i, "│")
end

gpu.set(1, 13,"╟───────────────┼───────────────┼───────────────┼───────────────┼──────────────╢")

gpu.set(5, 3, "Реактор 1")
gpu.set(21, 3, "Реактор 2")
gpu.set(37, 3, "Реактор 3")
gpu.set(53, 3, "Реактор 4")
gpu.set(69, 3, "Реактор 5")
gpu.set(5, 15, "Реактор 6")
gpu.set(21, 15, "Реактор 7")
gpu.set(37, 15, "Реактор 8")
gpu.set(53, 15, "Реактор 9")
gpu.set(68, 15, "Реактор 10")

--Функция, возвращает на место времени 
local function getTime(numberReactor, side, slot)
 	infoRod = component.proxy(reactor.numberReactor.inventory).getStackInSlot(side,slot)
	if not infoRod then
        return "Слот пустой"
    elseif infoRod.name == "ic2:nuclear" then
        return "Пора менять стержни"
    elseif infoRod.name == "ic2:mox_fuel_rod" or infoRod.name =="ic2:dual_mox_fuel_rod"or infoRod.name =="ic2:quad_mox_fuel_rod" then
        local rodAllSec = infoRod.maxDamage-infoRod.damage
        local rodHour = tostring(math.floor(rodAllSec/3600))
        local rodMin = tostring(math.floor((rodAllSec-rodHour*3600)/60))
        local rodSec = tostring(math.floor(rodAllSec-(rodHour*3600+rodMin*60)))
  		return rodHour..":"..rodMin..":"..rodSec
	else
        return "Не правильно выбран слот"
   end
end
 
local function changeStatusReactor(numberReactor, side, slot)
    if statusReactor.numberReactor == 0 then
  		     
        gpu.fill(clearCords.numberReactor[1], clearCords.numberReactor[2], clearCords.numberReactor[3], clearCords.numberReactor[4], " ") --поменять значения
        
        gpu.set(coords.numberReactor.coordsA, "Активирован")
    	gpu.set(coords.numberReactor.coordsV, "Выход:")
    	gpu.set(coords.numberReactor.coordsO, "Осталось:")
        
        statusReactor[numberReactor] = 1
        
    elseif statusReactor[numberReactor] == 1 then
            
		gpu.fill(coords.numberReactor.coordsT[1], coords.numberReactor.coordsT[2], 1, 7, " ")
        gpu.set(coords.numberReactor.coordsT[1], coords.numberReactor.coordsT[2], getTime(numberReactor, side, slot))    
            
    elseif statusReactor[numberReactor] == 2 then
  		gpu.fill(clearCords.numberReactor[1], clearCords.numberReactor[2], clearCords.numberReactor[3], clearCords.numberReactor[4], " ")
        gpu.set(coordsV, "Выключен")
	end
end

while true do
    if component.proxy(reactor.r1.statistic).producesEnergy() == true then
      	changeStatusReactor("r1", side, slot)
	else 
		print("нет energy")
   end    
end   
