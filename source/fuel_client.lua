-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local fuelSynced = false
local inBlacklisted = false
local inGasStation = false
local Stations = {}
local props = {
	'prop_gas_pump_1d',
	'prop_gas_pump_1a',
	'prop_gas_pump_1b',
	'prop_gas_pump_1c',
	'prop_vintage_pump',
	'prop_gas_pump_old2',
	'prop_gas_pump_old3',
}

-- Functions

local function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

local function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

local function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Wait(1)
		end
	end
end

local function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gas Station")
	EndTextCommandSetBlipName(blip)
	return blip
end

local function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			fuelPumps[#fuelPumps+1] = object
		end
		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = #(coords - GetEntityCoords(fuelPumpObject))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end

	return pumpObject, pumpDistance
end

local function isCloseVeh()
    local ped = PlayerPedId()
    coordA = GetEntityCoords(ped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 100.0, 0.0)
    vehicle = getVehicleInDirection(coordA, coordB)
    if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
        return true
    end
    return false
end

local function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle
	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		offset = offset - 1
		if vehicle ~= 0 then break end
	end
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	if distance > 25 then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end

local function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))
		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
		SetVehicleEngineOn(veh, true, true, true)
	else
		SetVehicleEngineOn(veh, true, true, true)
	end
end

-- Events

-- buy jerry can menu
RegisterNetEvent('lj-fuel:client:buyCanMenu', function()
    exports['qb-menu']:openMenu({
        {
            header = "Gas Station",
            txt = 'The total cost is going to be: $'..Config.canCost..' including taxes.',
            params = {
                event = "lj-fuel:client:buyCan",
            }
        },
    })
end)

-- buy jerry can from pump
RegisterNetEvent('lj-fuel:client:buyCan', function()
    if not HasPedGotWeapon(ped, 883325847) then
		if QBCore.Functions.GetPlayerData().money['cash'] >= Config.canCost then
			TriggerServerEvent('QBCore:Server:AddItem', "weapon_petrolcan", 1)
			SetPedAmmo(ped, 883325847, 4500)
			TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["weapon_petrolcan"], "add")
        	TriggerServerEvent('lj-fuel:server:PayForFuel', Config.canCost, GetPlayerServerId(PlayerId()))
		else
			QBCore.Functions.Notify('Don\'t not have enough money', 'error')
		end
    end
end)

-- refuel jerry can menu
RegisterNetEvent('lj-fuel:client:refuelCanMenu', function()
	exports['qb-menu']:openMenu({
		{
			header = "Gas Station",
			txt = "Buy jerry can. Remember there will be a 10% tax fee.",
			params = {
				event = "lj-fuel:client:refuelCan",
			}
		},
	})
end)

-- refuel jerry can from pump
RegisterNetEvent('lj-fuel:client:refuelCan', function()
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local ped = PlayerPedId()
	local CurFuel = GetVehicleFuelLevel(vehicle)

	if HasPedGotWeapon(ped, 883325847) then
	if GetAmmoInPedWeapon(ped, 883325847) < 4500 then
		RequestAnimDict("weapon@w_sp_jerrycan")
		while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do Wait(100) end
			TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
			QBCore.Functions.Progressbar("refuel-car", "Refueling", 10000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
			}, {}, {}, {}, function() -- Done
			TriggerServerEvent('lj-fuel:server:PayForFuel', Config.refuelCost, GetPlayerServerId(PlayerId()))
			SetPedAmmo(ped, 883325847, 4500)
			PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
			StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
		end, function() -- Cancel
			QBCore.Functions.Notify('Refueling Canceled', 'error')
			StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
			end)
		else 
			QBCore.Functions.Notify('This jerry can is already full.', 'error')
		end
	end
end)

-- server check menu that gets sent to server side
RegisterNetEvent('lj-fuel:client:SendMenuToServer', function()
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local CurFuel = GetVehicleFuelLevel(vehicle)
	local refillCost = Round(Config.RefillCost - CurFuel) * Config.CostMultiplier
	
	if CurFuel < 95 then
		TriggerServerEvent('lj-fuel:server:OpenMenu', refillCost, inGasStation)
	else
		QBCore.Functions.Notify('This vehicle is already full.', 'error')
	end
end)

-- refuel vehicle 
RegisterNetEvent('lj-fuel:client:RefuelVehicle', function(refillCost)
	local vehicle = QBCore.Functions.GetClosestVehicle()
	local ped = PlayerPedId()
	local CurFuel = GetVehicleFuelLevel(vehicle)
	local time = (100 - CurFuel) * 400
	local vehicleCoords = GetEntityCoords(vehicle)

	if inGasStation == false and not HasPedGotWeapon(ped, 883325847) then
		QBCore.Functions.Notify('Don\'t have jerry can', 'error')
	elseif inGasStation == false and GetAmmoInPedWeapon(ped, 883325847) == 0 then
		QBCore.Functions.Notify('Jerry can is empty', 'error')
		return
	end

	-- refuel vehicle with jerry can outside zone
	if HasPedGotWeapon(ped, 883325847) then
		RequestAnimDict("weapon@w_sp_jerrycan")
		while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do 
			Wait(100) 
		end
			TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
			-- explosion chance when engine is left running outside gas station zone
			if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
				local Chance = math.random(1, 100)
			if Chance <= Config.BlowUpChance then
				AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
					return
				end
			end
			QBCore.Functions.Progressbar("refuel-car", "Refueling", time, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
				}, {}, {}, {}, function() -- Done
				SetFuel(vehicle, 100)
				SetPedAmmo(ped, 883325847, 0)
				PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
				StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
			end, function() -- Cancel
				QBCore.Functions.Notify('Refueling Canceled', 'error')
				StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
			end)
		else

		-- refuel vehicle at gas station inside zone		
		if inGasStation then
			if isCloseVeh() then
				if QBCore.Functions.GetPlayerData().money['cash'] <= refillCost then 
					QBCore.Functions.Notify('Don\'t not have enough money', 'error')
				else
				RequestAnimDict("weapon@w_sp_jerrycan")
				while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do Wait(100) end
				TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
				-- explosion chance when engine is left running inside gas station zone
				if GetIsVehicleEngineRunning(vehicle) and Config.VehicleBlowUp then
					local Chance = math.random(1, 100)
				if Chance <= Config.BlowUpChance then
					AddExplosion(vehicleCoords, 5, 50.0, true, false, true)
						return
					end
				end
				
				QBCore.Functions.Progressbar("refuel-car", "Refueling", time, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function() -- Done
					TriggerServerEvent('lj-fuel:server:PayForFuel', refillCost, GetPlayerServerId(PlayerId()))
					SetFuel(vehicle, 100)
					PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
					StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
				end, function() -- Cancel
					QBCore.Functions.Notify('Refueling Canceled', 'error')
					StopAnimTask(ped, "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
					end)
				end
			end
		end
	end
end)

-- exports

exports['qb-target']:AddTargetModel(props, {
	options = {
		{
			type = "client",
			event = "lj-fuel:client:buyCanMenu",
			icon = "fas fa-burn",
			label = "Buy Jerry Can",
		},
		{
			type = "client",
			event = "lj-fuel:client:refuelCanMenu",
			icon = "fas fa-gas-pump",
			label = "Refuel Jerry Can",
		},
	},
		distance = 2.0
})

-- Thread

-- leave engine running
if Config.LeaveEngineRunning then
	CreateThread(function()
		while true do
			Wait(100)
			local ped = GetPlayerPed(-1)
			
			if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
				local engineWasRunning = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
				Wait(1000)
				if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
					local veh = GetVehiclePedIsIn(ped, true)
					if engineWasRunning then
						SetVehicleEngineOn(veh, true, true, true)
					end
				end
			end
		end
	end)
end

-- show nearest gas stations when close enough
if Config.ShowNearestGasStationOnly then
    CreateThread(function()
	local currentGasBlip = 0

	while true do
		local coords = GetEntityCoords(PlayerPedId())
		local closest = 1000
		local closestCoords

		for _, gasStationCoords in pairs(Config.GasStationsBlips) do
			local dstcheck = #(coords - gasStationCoords)
			if dstcheck < closest then
				closest = dstcheck
				closestCoords = gasStationCoords
			end
		end

		if DoesBlipExist(currentGasBlip) then
			RemoveBlip(currentGasBlip)
		end

		currentGasBlip = CreateBlip(closestCoords)
		Wait(10000)
	end
end)

-- show all gas stations around map
elseif Config.ShowAllGasStations then
    CreateThread(function()
        for _, gasStationCoords in pairs(Config.GasStationsBlips) do
            CreateBlip(gasStationCoords)
        end
    end)
end

CreateThread(function() 
    for k=1, #Config.GasStations do
		Stations[k] = PolyZone:Create(Config.GasStations[k].zones, {
			name="GasStation"..k,
			minZ = 	Config.GasStations[k].minz,
			maxZ = Config.GasStations[k].maxz,
			debugPoly = false
		})
		Stations[k]:onPlayerInOut(function(isPointInside)
			if isPointInside then
				inGasStation = true
			else
				inGasStation = false
			end
		end)
    end
end)

CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		Config.Blacklist[index] = nil
	end

	while true do
		Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

CreateThread(function()
	local bones = {
		'wheel_lr',
		'wheel_rr'
	}
	exports['qb-target']:AddTargetBone(bones, {
		options = {
		{
			type = "client",
			event = "lj-fuel:client:SendMenuToServer",
			icon = "fas fa-gas-pump",
			label = "Refuel Vehicle",
		}
	},
		distance = 1.5,
	})
end)
