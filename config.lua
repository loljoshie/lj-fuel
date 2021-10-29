Config = {}

Config.RefillCost = 100 -- default price
Config.CostMultiplier = 3.0 -- tax basically
Config.canCost = 400 --buy jerry can price
Config.refuelCost = 600 --refueling jerry can price

Config.FuelDecor = "_FUEL_LEVEL" -- don't touch


-- Blacklist certain vehicles. Use names or hashes. https://wiki.gtanet.work/index.php?title=Vehicle_Models
Config.Blacklist = {
	--"Adder",
	--276773164
}


-- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.
Config.Classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 1.0, -- Industrial
	[11] = 1.0, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.0, -- Service
	[18] = 1.0, -- Emergency
	[19] = 1.0, -- Military
	[20] = 1.0, -- Commercial
	[21] = 1.0, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
Config.FuelUsage = {
	[1.0] = 1.3,
	[0.9] = 1.1,
	[0.8] = 0.9,
	[0.7] = 0.8,
	[0.6] = 0.7,
	[0.5] = 0.5,
	[0.4] = 0.3,
	[0.3] = 0.2,
	[0.2] = 0.1,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

Config.GasStations = { -- gas station polyzones
    ["1"] = {
        polyzone = vector3(175.20, -1563.07, 29.27),
        polyzoneHeading = 134,
        polyzone1 = 16,
        polyzone2 = 19,
    },
    ["2"] = { 
        polyzone = vector3(-70.05, -1761.54, 29.53),
        polyzoneHeading = 160,
        polyzone1 = 14,
        polyzone2 = 28,
        
    },
    ["3"] = { 
        polyzone = vector3(-524.45, -1211.63, 18.18),
        polyzoneHeading = 155,
        polyzone1 = 17.8,
        polyzone2 = 18.8,
    },
    ["4"] = { 
        polyzone = vector3(-722.59, -935.15, 19.03),
        polyzoneHeading = 180,
        polyzone1 = 16,
        polyzone2 = 28.0,
    },
    ["5"] = { 
        polyzone = vector3(265.12, -1259.38, 29.14),
        polyzoneHeading = 180,
        polyzone1 = 24.6,
        polyzone2 = 30,
    },
    ["6"] = { 
        polyzone = vector3(818.28, -1028.57, 26.4),
        polyzoneHeading = 90,
        polyzone1 = 28, 
        polyzone2 = 10,
    },
    ["7"] = { 
        polyzone = vector3(1208.87, -1401.38, 36.51),
        polyzoneHeading = 140,
        polyzone1 = 12, 
        polyzone2 = 16,
    },
    ["8"] = { 
        polyzone = vector3(1180.78, -330.14, 69.32),
        polyzoneHeading = 100,
        polyzone1 = 16, 
        polyzone2 = 26,
    },
    ["9"] = { 
        polyzone = vector3(620.56, 268.92, 103.09),
        polyzoneHeading = 180,
        polyzone1 = 15.8, 
        polyzone2 = 28.4,
    },
    ["10"] = { 
        polyzone = vector3(-1436.93, -276.43, 46.21),
        polyzoneHeading = 131,
        polyzone1 = 20,
        polyzone2 = 20,
    },
    ["11"] = { 
        polyzone = vector3(-2096.78, -318.96, 13.17),
        polyzoneHeading = 174,
        polyzone1 = 21.0,
        polyzone2 = 26,
    },
    ["12"] = {
        polyzone = vector3(-94.46, 6419.59, 31.48),
        polyzoneHeading = 135,
        polyzone1 = 13, 
        polyzone2 = 10,
    },
    ["13"] = { 
        polyzone = vector3(180.1, 6602.62, 31.87),
        polyzoneHeading = 100,
        polyzone1 = 26, 
        polyzone2 = 15,
    },
    ["14"] = { 
        polyzone = vector3(1701.32, 6416.69, 32.76),
        polyzoneHeading = 65,
        polyzone1 = 13, 
        polyzone2 = 10,
    },
    ["15"] = { 
        polyzone = vector3(1687.49, 4929.26, 42.08),
        polyzoneHeading = 55,
        polyzone1 = 14, 
        polyzone2 = 8,
    },
    ["16"] = { 
        polyzone = vector3(2004.92, 3774.17, 32.4),
        polyzoneHeading = 120,
        polyzone1 = 12, 
        polyzone2 = 10,
    },
    ["17"] = { 
        polyzone = vector3(1785.42, 3330.46, 41.38),
        polyzoneHeading = 120,
        polyzone1 = 8, 
        polyzone2 = 8,
    },
    ["18"] = { 
        polyzone = vector3(2680.26, 3263.99, 55.24),
        polyzoneHeading = 61,
        polyzone1 = 10, 
        polyzone2 = 10,
    },
    ["19"] = { 
        polyzone = vector3(1207.94, 2660.20, 37.9),
        polyzoneHeading = 130,
        polyzone1 = 8, 
        polyzone2 = 8,
    },
    ["20"] = { 
        polyzone = vector3(1039.41, 2671.50, 39.55),
        polyzoneHeading = 90,
        polyzone1 = 14, 
        polyzone2 = 14,
    },
    ["21"] = { 
        polyzone = vector3(264.03, 2606.97, 44.98),
        polyzoneHeading = 100,
        polyzone1 = 8, 
        polyzone2 = 8,
    },
    ["22"] = { 
        polyzone = vector3(49.71, 2779.19, 58.04),
        polyzoneHeading = 50,
        polyzone1 = 10, 
        polyzone2 = 10,
    },
    ["23"] = { 
        polyzone = vector3(-2555.14, 2334.39, 33.08),
        polyzoneHeading = 94,
        polyzone1 = 15, 
        polyzone2 = 25,
    },
    ["24"] = { 
        polyzone = vector3(2537.58, 2593.67, 37.94),
        polyzoneHeading = 105,
        polyzone1 = 5, 
        polyzone2 = 6,
    },
    ["25"] = {
        polyzone = vector3(2581.05, 361.42, 108.47),
        polyzoneHeading = 177,
        polyzone1 = 15, 
        polyzone2 = 25,
    },
    ["26"] = { 
        polyzone = vector3(-1799.81, 803.49, 138.65),
        polyzoneHeading = 43,
        polyzone1 = 15, 
        polyzone2 = 26,
    },
    ["26"] = { 
        polyzone = vector3(-1799.81, 803.49, 138.65),
        polyzoneHeading = 43,
        polyzone1 = 15, 
        polyzone2 = 26,
    },
    ["27"] = { 
        polyzone = vector3(-319.41, -1471.71, 30.55),
        polyzoneHeading = 31,
        polyzone1 = 20.05, 
        polyzone2 = 33.65,
    },
}
