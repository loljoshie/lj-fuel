![LJ FUEL](https://user-images.githubusercontent.com/91661118/139381416-32ce9dd7-a77d-4690-bf35-e0b3fd336039.png)

# lj-fuel used with QBCore Framework
Join my Discord laboratory for updates, support, and special early testing!
<br>
https://discord.gg/loljoshie

lj-fuel is a modified version of LegacyFuel using PolyZones like NoPixel 3.0
<br>
Runs at ~ 0.00 to 0.01 ms if you have more optimization suggestions feel free to reach out

# Dependencies
* [qb-target](https://github.com/BerkieBb/qb-target)
* [qb-menu](https://github.com/qbcore-framework/qb-menu)
* [polyzone](https://github.com/qbcore-framework/PolyZone)
* [polyzonehelper](https://github.com/bashenga/polyzonehelper)

# Installation [tutorial video](https://www.youtube.com/watch?v=9bwqIRspgns)

* **IMPORTANT: Must rename ANY existing LegacyFuel exports to lj-fuel**
* Watch [tutorial video](https://www.youtube.com/watch?v=9bwqIRspgns) [if visual guide needed]

## qb-menu 
* find this in **"qb-menu/client/main.lua"**
* Put this **under line 27:**
```lua
RegisterNetEvent('qb-menu:openMenu')
AddEventHandler('qb-menu:openMenu', function(data)
    openMenu(data)
end)
```

## qb-target config (v3.1.2 newest isn't exporting correctly):
* Find this in **qb-target/config**
* Put this in **"Config.TargetBones"**
```lua
Config.TargetBones = {

	["main"] = {
        bones = {
            "door_dside_f",
            "door_dside_r",
            "door_pside_f",
            "door_pside_r"
        },
        options = {
      {
        type = "client",
        event = "lj-fuel:client:SendMenuToServer",
        icon = "fas fa-gas-pump",
        label = "Refuel Vehicle",
      },
        },
          distance = 1.0
    },

}
```
* Put this in **"Config.TargetModels"**
```lua
Config.TargetModels = {
	
	["fuel"] = {
        models = {
            "prop_gas_pump_1d",
            "prop_gas_pump_1a",
            "prop_gas_pump_1b",
            "prop_gas_pump_1c",
            "prop_vintage_pump",
            "prop_gas_pump_old2",
            "prop_gas_pump_old3"
        },
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
  },
  
}
```

## Global Taxes:
* Put this in **qb-core/server/functions.lua**
```lua
QBCore.Functions.GlobalTax = function(value)
	local tax = (value / 100 * QBConfig.Server.GlobalTax)
	return tax
end
```
* Find this in **qb-core/config.lua**
* Put this **under line 29:**
```lua
QBConfig.Server.GlobalTax = 15.0
```

## qb-smallresources:
* Remove this thread in **qb-smallresources/client/ignore.lua**
```lua
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
		if weapon ~= GetHashKey("WEAPON_UNARMED") then
			if IsPedArmed(ped, 6) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end

			if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") or  weapon == GetHashKey("WEAPON_PETROLCAN") then
				if IsPedShooting(ped) then
					SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
					SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_PETROLCAN"))
				end
			end
		else
			Citizen.Wait(500)
		end
        Citizen.Wait(7)
    end
end)
```
(removes infinite jerry can and fire extinguisher ammo)

# Key Features
* NoPixel style animation for refueling
* Gas station polyzone areas targeted with qb-target
* Fuel price is fully calulated before purchase including taxes
* Progressbar is synced with refueling amount left for vehicle
* Buy jerry can from pump
* Refuel jerry can from pump

#
# Previews
### resource ms
![resource ms](https://user-images.githubusercontent.com/91661118/139408600-4ce062a2-c302-46a9-a1f1-210a1cee402a.png)
### refueling animation
https://user-images.githubusercontent.com/91661118/139377251-82a357e4-8ebc-43e4-bf1b-47210cb6a971.mp4
### refueling vehicle jerry can
![refueling vehicle jerry can](https://user-images.githubusercontent.com/91661118/139378188-be90c869-73d8-4034-a0c6-70d987eb037b.png)
### polyzones around map
![polyzones](https://user-images.githubusercontent.com/91661118/139377336-53a84080-3178-4511-9030-0306e4999fda.png)
### refuel interact
![qb-target interact](https://user-images.githubusercontent.com/91661118/139377384-0ab4a5f7-c760-4111-8512-bf8760e8d61a.png)
### menu price calculation
![qb-target interact](https://user-images.githubusercontent.com/91661118/139377384-0ab4a5f7-c760-4111-8512-bf8760e8d61a.png)
### pump interaction
![qb-target pump interaction](https://user-images.githubusercontent.com/91661118/139377494-de7de1b5-b8e7-4c72-9b63-493ee34279bd.png)
#

# My CSS Edits to Dependencies
* [qb-target](https://github.com/loljoshie/qb-target)
* [progressbar](https://github.com/loljoshie/progressbar)
* [qb-menu](https://github.com/loljoshie/qb-menu)

# Credit
* ImpulseFPS for PolyZone and global tax idea [original version](https://github.com/ImpulseFPS/irp-fuel)

# Issues and Suggestions
Please use the GitHub issues system to report issues or make suggestions, when making suggestion, please keep [Suggestion] in the title to make it clear that it is a suggestion.
