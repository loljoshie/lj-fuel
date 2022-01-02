local QBCore = exports['qb-core']:GetCoreObject()

local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

-- refuel vehicle menu
RegisterNetEvent("lj-fuel:server:OpenMenu", function (amount, inGasStation)
	local src = source
	if not src then return end
	local player = QBCore.Functions.GetPlayer(src)
	if not player then return end
	local tax = GlobalTax(amount)
	local total = math.ceil(amount + tax)
	if inGasStation == true then
	TriggerClientEvent('qb-menu:client:openMenu', src, {
		{
			header = 'Gas Station',
			txt = 'The total cost is going to be: $'..total..' including taxes.' ,
			params = {
				event = "lj-fuel:client:RefuelVehicle",
				args = total,
			}
		},
	})
end

	-- refuel vehicle with jerry can menu outside zone
	if inGasStation == false then
		TriggerClientEvent('qb-menu:client:openMenu', src, {
			{
				header = 'Gas Station',
				txt = 'The total cost is going to be: $'..total..' including taxes.' ,
				params = {
					event = "lj-fuel:client:RefuelVehicle",
					args = total,
				}
			},
		})
	end
end)

-- fuel pay
RegisterNetEvent("lj-fuel:server:PayForFuel", function (amount)
	local src = source
	if not src then return end
	local player = QBCore.Functions.GetPlayer(src)
	if not player then return end
	player.Functions.RemoveMoney('cash', amount)
end)
