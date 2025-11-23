TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
RegisterNetEvent("md_dispatch:CreateDispatchCommand", function(allowedJobs, anonymous, msg, title, pos, blip)
    local xPlayer = ESX.GetPlayerFromId(source)
    local firstname = xPlayer.get('firstName')
    local lastname = xPlayer.get('lastName')
    local src = source
    local dispMsg = ''
    if not anonymous then
        dispMsg = "["..src..']'..firstname.." "..lastname.." : " ..msg
    else 
        dispMsg = "["..src..']'.."Anonymous call : " ..msg
    end
    local t = os.date("*t")
    TriggerClientEvent("md_dispatch:showDispatch", -1, allowedJobs, dispMsg, title, pos, t, blip)
end)

RegisterNetEvent("md_dispatch:panicpressed", function(pos, callsign)
    local t = os.date("*t")
    local xPlayer = ESX.GetPlayerFromId(source)
    local firstname = xPlayer.get('firstName')
    local lastname = xPlayer.get('lastName')
    local dispMsg = "["..source.."] "..callsign.." "..firstname.." "..lastname.. " needs assistance"
    TriggerClientEvent("md_dispatch:panicsound", -1, dispMsg, pos, t)
end)
RegisterNetEvent("md_dispatch:now", function()
    local t = os.date("*t")
    TriggerClientEvent("md_dispatch:nowIs", source, t)
end)

RegisterNetEvent("md_dispatch:CreateDispatch", function(allowedJobs, dispMsg, title, pos, blip)
    local t = os.date("*t")
    TriggerClientEvent("md_dispatch:showDispatch", -1, allowedJobs, dispMsg, title, pos, t, blip)
end)

RegisterNetEvent("md_dispatch:playAllPanic", function(coords)
    TriggerClientEvent("md_dispatch:playAllPanicClient",-1, coords)
end)