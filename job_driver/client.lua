local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

job = {}
Tunnel.bindInterface("job_driver", job)
vSERVER = Tunnel.getInterface("job_driver")

local inService = false
local inSelected = 0
local inCheckpoint = 0
local inPoint = 0
local deliveries = {
    [1] = {
        ["start"] = { 453.66, -600.59, 28.59, 268.58, 0x2E420A24, "csb_reporter" },
        ["points"] = 27,
        ["coords"] = {
            { 309.95, -760.52, 30.09 },
	        { 69.59, -974.80, 30.14 },
	        { 95.00, -634.89, 45.02 },
	        { 58.27, -283.32, 48.20 },
	        { 47.74, -160.44, 56.03 },
	        { 323.93, -267.58, 54.71 },
	        { 443.75, 119.16, 100.41 },
	        { 125.62, -4.42, 68.48 },
	        { -524.08, 133.59, 63.91 },
	        { -586.64, 268.39, 83.24 },
	        { -640.38, -163.16, 38.49 },
	        { -597.89, -361.27, 35.77 },
	        { -646.06, -804.09, 25.78 },
	        { -932.63, -1199.67, 5.91 },
	        { -1234.65, -1080.87, 9.12 },
	        { -1373.99, -793.23, 20.09 },
	        { -2011.25, -160.04, 29.40 },
	        { -2981.70, 404.50, 15.75 },
	        { -3101.58, 1112.65, 21.28 },
	        { -2556.10, 2322.01, 33.89 },
	        { -1094.86, 2675.87, 20.08 },
	        { -72.63, 2813.83, 54.60 },
	        { 540.55, 2685.25, 43.20 },
	        { 1119.93, 2682.04, 39.31 },
	        { 1470.51, 2725.47, 38.48 },
	        { 2002.62, 2603.65, 55.07 },
	        { 379.58, -599.20, 29.58 }
        }
    }
}

RegisterCommand("finalizar",function(source, args)
    if inService then
        inService = false
    end
end)

Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()

        local coords = GetEntityCoords(ped)

        if inService then
            local distance = #(coords - vector3(deliveries[inSelected]["coords"][inCheckpoint][1],deliveries[inSelected]["coords"][inCheckpoint][2],deliveries[inSelected]["coords"][inCheckpoint][3]))

            if distance <= 50.0 then
                timeDistance = 4
                dwText("~b~PONTOS:~w~ "..inPoint.." / "..deliveries[inSelected]["points"], 0.94)
                DrawMarker(21,deliveries[inSelected]["coords"][inCheckpoint][1],deliveries[inSelected]["coords"][inCheckpoint][2],deliveries[inSelected]["coords"][inCheckpoint][3]+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,42,137,255,50,1,0,0,1)
                if distance <= 5.0 and IsVehicleModel(GetVehiclePedIsUsing(ped), GetHashKey("coach")) then
                    if IsControlJustPressed(0, 38) then
                        if inCheckpoint >= #deliveries[inSelected]["coords"] then
                            if inPoint >= deliveries[inSelected]["points"] then
                                PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
                                vSERVER.finishWork()
                                inService = false
                            end
                        else
                            inCheckpoint = inCheckpoint + 1
                            inPoint = inPoint + 1

                            SetNewWaypoint(deliveries[inSelected]["coords"][inCheckpoint][1],deliveries[inSelected]["coords"][inCheckpoint][2])
                        end
                    end
                end
            end
        else
            for k,v in pairs(deliveries) do
                local distance = #(coords - vector3(v["start"][1],v["start"][2],v["start"][3]))

                if distance <= 1.5 then
                    timeDistance = 4
                    DrawText3Ds(v["start"][1],v["start"][2],v["start"][3] + 0, "PRESSIONE  ~b~E~w~  PARA  INICIAR")
                    if IsControlJustPressed(0, 38) then
                        inService = true
                        inSelected = tonumber(k)
                        inCheckpoint = 1
                        inPoint = 1

                        SetNewWaypoint(deliveries[inSelected]["coords"][inCheckpoint][1],deliveries[inSelected]["coords"][inCheckpoint][2])
                    end
                end
            end
        end
        Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(deliveries) do
        RequestModel(GetHashKey(v["start"][6]))
        while not HasModelLoaded(GetHashKey(v["start"][6])) do
            Wait(10)
        end

        local ped = CreatePed(4,v["start"][5],v["start"][1],v["start"][2],v["start"][3]-1,v["start"][4],false,true)
        FreezeEntityPosition(ped,true)
        SetEntityInvincible(ped,true)
    end
end)

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
    DrawText(_x,_y)
    
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.060+factor,0.03,0,0,0,80)
end

function dwText(text,height)
	SetTextFont(4)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5,height)
end