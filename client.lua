
ESX = nil
PlayerLoaded = false
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    PlayerLoaded = true
end)

local timeout = 0
local job = ''
local dispatches = {}
local CurDispId = 0
local pocet = ""
local titles = {}
local posx = {}
local posy = {}
local posz = {}
local times = {}
local now = 0
local timeoutpanic = 0
local callsign = ""
local locator = 0
local mute = false
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end

    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    PlayerLoaded = true

    SendNUIMessage({
        action = "GetConfig",
        DispatchDeletion = Config.DispatchDeletion;

    })
    for i=1, #Config.Commands do
        RegisterCommand(Config.Commands[i].command, function(source, args, rawCommand)
            if timeout==0 then
                local allowedJobs = Config.Commands[i].jobs
                local msg = table.concat(args, " ")
                local anonymous = Config.Commands[i].anonymous
                local title = Config.Commands[i].title
                local playerPed = PlayerPedId()
                local pos = GetEntityCoords(playerPed, true)
                blip = 409
                TriggerServerEvent("md_dispatch:CreateDispatchCommand", allowedJobs, anonymous, msg, title, pos, blip)
                timeout=1
            end
        end)
    end
    while true do
        Wait(Config.DispatchDeletion)
        deletedispatch()
    end
end)
RegisterNUICallback("closeMenu", function(data, cb)
    SetNuiFocus(false, false)
    cb('')
end)
RegisterCommand("dispatchset", function()
    SetNuiFocus(true, true)
    SendNUIMessage({action="openSet"})
end)
CreateThread(function()
    while timeout do
        Wait(Config.CommandTimeout)
        timeout = 0
    end
end)
CreateThread(function()
    while timeoutpanic do
        Wait(Config.PanicTimeout)
        timeoutpanic = 0
    end
end)
CreateThread(function()
    while true do
        Wait(500)
        TriggerServerEvent("md_dispatch:now")
    end
end)
RegisterNUICallback("user", function(data, cb)
    callsign = data.cs
    locator = data.locator
    mute = data.md
    cb('')
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        ESX.PlayerData = ESX.GetPlayerData()
        job = ESX.PlayerData.job.name
        for i=1, #Config.PoliceJobs do
            if job==Config.PoliceJobs[i] then
                TriggerServerEvent('md_dispatch:updatePosition', coords, callsign)
            end
        end
    end
end)


RegisterNetEvent("md_dispatch:nowIs", function(t)
    if times[CurDispId] then
        now = tonumber(t.min)- tonumber(times[CurDispId])
    end
end)

local cooldownTime = Config.PlayerShootTimeout
function isInsideBox(playerPos, pos1, pos2)
    local minX = math.min(pos1.x, pos2.x)
    local minY = math.min(pos1.y, pos2.y)
    local minZ = math.min(pos1.z, pos2.z)

    local maxX = math.max(pos1.x, pos2.x)
    local maxY = math.max(pos1.y, pos2.y)
    local maxZ = math.max(pos1.z, pos2.z)

    return (playerPos.x >= minX and playerPos.x <= maxX) and
           (playerPos.y >= minY and playerPos.y <= maxY) and
           (playerPos.z >= minZ and playerPos.z <= maxZ)
end
suppressorComponents = {
    `COMPONENT_AT_PI_SUPP`,
    `COMPONENT_AT_PI_SUPP_02`,
    `COMPONENT_AT_AR_SUPP`,
    `COMPONENT_AT_AR_SUPP_02`,
    `COMPONENT_AT_SR_SUPP`
}
function WeaponHasSuppressor(ped)
    local weapon = GetSelectedPedWeapon(ped)

    for _, component in ipairs(suppressorComponents) do
        if HasPedGotWeaponComponent(ped, weapon, component) then
            return true
        end
    end

    return false
end


Citizen.CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(ped)
        local coords = GetEntityCoords(ped)
        if currentWeapon ~= `WEAPON_STUNGUN` and currentWeapon ~= `WEAPON_STUNGUN_MP` then
            if IsPedShooting(ped) and not shootingCooldown and not WeaponHasSuppressor(ped) then
                local ped = PlayerPedId()
                local weapon = GetSelectedPedWeapon(ped)

                
                local insideAnyZone = false

                for i=1, #Config.BlacklistShootingZones do
                    local pos1 = Config.BlacklistShootingZones[i].minPos
                    local pos2 = Config.BlacklistShootingZones[i].maxPos

                    if isInsideBox(coords, pos1, pos2) then
                        insideAnyZone = true
                        break
                    end
                end
                if not insideAnyZone then
                    shootingCooldown = true

                    TriggerServerEvent(
                        "md_dispatch:CreateDispatch",
                        Config.PoliceJobs,
                        Config.ShootingMessage,
                        Config.ShootingTitle,
                        coords,
                        119
                    )

                    Citizen.SetTimeout(cooldownTime, function()
                        shootingCooldown = false
                    end)
                end
            end
        end
    end
end)

local lastDriver = {}
local notified = {}

CreateThread(function()
    while true do
        Wait(100)
        local ped = PlayerPedId()
        if IsPedTryingToEnterALockedVehicle(ped) or IsPedGettingIntoAVehicle(ped) then
            local veh = GetVehiclePedIsTryingToEnter(ped)

            if veh ~= 0 then
                local driver = GetPedInVehicleSeat(veh, -1)

                if driver ~= 0 then
                    lastDriver[veh] = driver
                end
            end
        end

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, -1) == ped then
                if notified[veh] then
                    goto continue
                end
                local original = lastDriver[veh]
                if original and DoesEntityExist(original) and not IsPedAPlayer(original) then
                    local num = math.random(100) 
                    if num<=Config.CarJackChance then
                        local playerPed = PlayerPedId()
                        local coords = GetEntityCoords(playerPed, true)
                        local playerPos = vector3(coords.x, coords.y, coords.z)
                        local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                        modelName = string.lower(modelName)
                        local plate = GetVehicleNumberPlateText(veh)
                        local msg = Config.CarjackMessage:gsub("%^model%^", modelName)
                        local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
                        msg = msg:gsub("%^plate%^", plate)
                        TriggerServerEvent("md_dispatch:CreateDispatch", Config.PoliceJobs,msg, Config.CarjackTitle,  playerPos, 326)
                        notified[veh] = true
                    end
                end
            end
        end

        ::continue::
    end
end)


CreateThread(function()
    while true do
        Wait(0)
        
        if CurDispId > 0 and posx[CurDispId] and posy[CurDispId] and posz[CurDispId] then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed, true)
            local playerPos = vector3(coords.x, coords.y, coords.z)
            local tx = tonumber(posx[CurDispId])
            local ty = tonumber(posy[CurDispId])
            local tz = tonumber(posz[CurDispId])
            if tx and ty and tz then
                local targetPos = vector3(tx, ty, tz)
                local dist = #(playerPos - targetPos)
                local distMiles = dist * 0.000621371
                local distance = 0
                local type = ""
                if distMiles<0.5 then
                    distance = math.floor(dist * 10 + 0.5) / 10
                    type = "meters"
                else 
                    distance = math.floor(distMiles * 10 + 0.5) / 10
                    type = "miles"
                end
                SendNUIMessage({
                    action = "miles",
                    distMiles = distance,
                    type = type,
                    time = now,
                    
                })
                
            end
        end
    end
end)
local lastw = 0

RegisterCommand("md_report:respond", function()
    SendNUIMessage({
        action = "button",
        key = "G"
    })
    if lastw == CurDispId and CurDispId ~= 0 then
        SetWaypointOff()
        lastw = 0
        return
    end

    if CurDispId ~= 0 then
        SetWaypointOff()
        SetNewWaypoint(posx[CurDispId], posy[CurDispId])
        lastw = CurDispId
    end
end)
RegisterCommand("md_report:prev", function()
    if CurDispId<2 then
        CurDispId = #dispatches+1
    end
        CurDispId = CurDispId - 1
        pocet = CurDispId .. "/".. #dispatches
        update()
        SendNUIMessage({
            action = "button",
            key ="L"

        })
end)
RegisterCommand("md_report:next", function()
    if CurDispId==#dispatches then
        CurDispId = 0
    end
    if #dispatches~=0 then
        CurDispId = CurDispId + 1
        pocet = CurDispId .. "/".. #dispatches
        update()
        SendNUIMessage({
            action = "button",
            key ="R"
            
        })
    end
end)
RegisterCommand(Config.PanicCommand, function()
    if timeoutpanic==0 then
        ESX.PlayerData = ESX.GetPlayerData()
        job = ESX.PlayerData.job.name
        local pid = PlayerPedId()
        RequestAnimDict("random")
        RequestAnimDict("random@arrests")
        RequestAnimDict("random@arrests@busted")
        while (not HasAnimDictLoaded("random@arrests@busted")) do Citizen.Wait(0) end
        TaskPlayAnim(pid,"random@arrests","generic_radio_chatter",3.0,-1.0,500,48,1,false,false,false)

        for i = 1, #Config.PanicJobs do
            if Config.PanicJobs[i] == job then
                local playerPed = PlayerPedId()
                local pos = GetEntityCoords(playerPed, true)
                TriggerServerEvent("md_dispatch:panicpressed", pos, callsign)
            end
        end
        timeoutpanic=1
    end
end)
local blips = {}
RegisterNetEvent("md_dispatch:panicsound", function(dispMsg, pos, t)
    ESX.PlayerData = ESX.GetPlayerData()
    job = ESX.PlayerData.job.name
    blip = AddBlipForCoord(pos.x ,pos.y,pos.z)
    SetBlipSprite(blip, 58)
    SetBlipColour(blip, 3)
    SetBlipAlpha(blip, 158)
    SetBlipAsShortRange(blip, false)
    SetBlipDisplay(blip, 1)
    SetBlipScale(blip, 1.5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.PanicTitle)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
    for i = 1, #Config.PanicJobs do
        if Config.PanicJobs[i] == job then
            SetBlipDisplay(blip, 2)
            table.insert(dispatches, dispMsg)
            table.insert(titles, Config.PanicTitle)
            table.insert(posx, pos.x)
            table.insert(posy, pos.y)
            table.insert(posz, pos.z)
            table.insert(times, t.min)
            CurDispId = #dispatches
            pocet = CurDispId .. "/".. #dispatches
            update(true)
        end
    end


end)
RegisterKeyMapping("md_report:respond", "Respond to a call", "keyboard", Config.Respond)
RegisterKeyMapping("md_report:prev", "Previous call", "keyboard", Config.PrevCall)
RegisterKeyMapping("md_report:next", "Next call", "keyboard", Config.NextCall)
RegisterKeyMapping(Config.PanicCommand, "Press Panic Button", "keyboard", "O")

RegisterNetEvent("md_dispatch:showDispatch", function( allowedJobs, dispMsg, title, pos, t, blip) 
    ESX.PlayerData = ESX.GetPlayerData()
    job = ESX.PlayerData.job.name
    local streetHash = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local streetName = GetStreetNameFromHashKey(streetHash)

    dispMsg = dispMsg:gsub("%^street%^", streetName)
    blipp = AddBlipForCoord(pos.x ,pos.y,pos.z)
    SetBlipSprite(blipp, blip)
    SetBlipColour(blipp, 3)
    SetBlipAlpha(blipp, 158)
    SetBlipAsShortRange(blipp, false)
    SetBlipDisplay(blipp, 1)
    SetBlipScale(blipp, 1.5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
    EndTextCommandSetBlipName(blipp)
    table.insert(blips, blipp)
    for i=1, #allowedJobs do
        if job==allowedJobs[i] then
            SetBlipDisplay(blipp, 2)
            table.insert(dispatches, dispMsg)
            table.insert(titles, title)
            table.insert(posx, pos.x)
            table.insert(posy, pos.y)
            table.insert(posz, pos.z)
            table.insert(times, t.min)
            CurDispId = #dispatches
            pocet = CurDispId .. "/".. #dispatches
            update(false)
        end
    end

end)

function deletedispatch()
    table.remove(dispatches, 1)
    table.remove(titles, 1)
    table.remove(posx, 1)
    table.remove(posy, 1)
    table.remove(posz, 1)
    table.remove(times, 1)
    CurDispId = #dispatches
    pocet = CurDispId .. "/".. #dispatches
    update(false)
    RemoveBlip(blips[1])
    table.remove(blips, 1)

end

function update(panic)
    if panic then
        if not mute then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            TriggerServerEvent("md_dispatch:playAllPanic", coords)
        end
    end
    SendNUIMessage({
        action = "GetCall",
        message = dispatches[CurDispId],
        pocet = pocet,
        CurDispId = CurDispId,
        title = titles[CurDispId],
        panic = panic,
    })
end



RegisterNetEvent("md_dispatch:playAllPanicClient", function(coords)
    local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)

        local found = false

        for _, player in ipairs(GetActivePlayers()) do
            local dist = #(myCoords - coords)

            if dist <= 3.0 then
                SendNUIMessage({
                    action = "playPanic",
                })
                break
            end
        end

end)
