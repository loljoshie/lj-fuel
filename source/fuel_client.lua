local fuelSynced = false
local inBlacklisted = false
local inGasStation = false

-- exports not working in qb-target v3.1.2
--[[ local prop = { "prop_gas_pump_1d", "prop_gas_pump_1a", "prop_gas_pump_1b", "prop_gas_pump_1c", "prop_vintage_pump", "prop_gas_pump_old2", "prop_gas_pump_old3",
}

local bones = { "boot",
}

exports['qb-target']:AddTargetBone(bones, {
	options = {
		{
			type = "client",
			event = "qb-trunk:client:GetIn",
			icon = "fas fa-user-secret",
			label = "Get In Truck",
		},
		{
			type = "client",
			event = "lj-fuel:client:SendMenuToServer",
			icon = "fas fa-gas-pump",
			label = "Refuel Vehicle",
		},
	},
		distance = 1.5
})

exports['qb-target']:AddTargetModel(prop, {
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
}) ]]


-- buy jerry can menu
RegisterNetEvent('lj-fuel:client:buyCanMenu')
AddEventHandler('lj-fuel:client:buyCanMenu', function()
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
RegisterNetEvent('lj-fuel:client:buyCan')
AddEventHandler('lj-fuel:client:buyCan', function()
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
RegisterNetEvent('lj-fuel:client:refuelCanMenu')
AddEventHandler('lj-fuel:client:refuelCanMenu', function()
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
		while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do Citizen.Wait(100) end
		
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

	------------------------------------------------------
	if inGasStation == false and not HasPedGotWeapon(ped, 883325847) then
		QBCore.Functions.Notify('Don\'t have jerry can', 'error')
	end

	-- refuel vehicle with jerry can outside zone
	if HasPedGotWeapon(ped, 883325847) then
		RequestAnimDict("weapon@w_sp_jerrycan")
		while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do 
			Citizen.Wait(100) 
		end
			TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
	
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
			while not HasAnimDictLoaded('weapon@w_sp_jerrycan') do Citizen.Wait(100) end
			TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
						
			-- Exploison chance 
			if GetIsVehicleEngineRunning(Vehicle) and Config.VehicleBlowUp then
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

RegisterNetEvent('polyzonehelper:enter')
AddEventHandler('polyzonehelper:enter', function(name)
	if name == "GasStations" then
		inGasStation = true
	end
end)

RegisterNetEvent('polyzonehelper:exit')
AddEventHandler('polyzonehelper:exit', function(name)
	if name == "GasStations" then
		inGasStation = false
	end
end)


Citizen.CreateThread(function() 
    for k, v in pairs(Config.GasStations) do 
        exports["polyzonehelper"]:AddBoxZone('GasStations', vector3(Config.GasStations[k].polyzone.x, Config.GasStations[k].polyzone.y, Config.GasStations[k].polyzone.z), Config.GasStations[k].polyzone1, Config.GasStations[k].polyzone2, {
            name='GasStations', 
            heading = Config.GasStations[k].polyzoneHeading,
            debugPoly=false
        })
    end
end)

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

Citizen.CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, index)
	end

	while true do
		Citizen.Wait(1000)

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

-- gas station blips around map
Citizen.CreateThread(function()
	for k, v in pairs(Config.GasStations) do
		local blip = AddBlipForCoord(Config.GasStations[k].polyzone.x, Config.GasStations[k].polyzone.y, Config.GasStations[k].polyzone.z)
		SetBlipSprite(blip, 415)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Gas Station')
		EndTextCommandSetBlipName(blip)
	end
end)
