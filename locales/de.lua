local Translations = {
    notify = {
        ["no_money"] = "Ich habe nicht genug Geld",
        ["refuel_cancel"] = "Tanken abgebrochen",
        ["jerrycan_full"] = "Dieser Kanister ist bereits voll",
        ["vehicle_full"] = "Dieses Fahrzeug ist bereits voll",
    }
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
