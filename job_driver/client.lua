local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
job = Tunnel.getInterface("job_driver")

local inService = false
local init = { 
    { 
        ['x'] = 453.66,
        ['y'] = -600.59,
        ['z'] = 28.59,
        ['h'] = 268.58,
        ['hash'] = 0x2E420A24,
        ['hash2'] = 'csb_reporter'
    }
}
local deliveries = {
    [1] = {
        ['x'] = 309.95,
        ['y'] = -760.52,
        ['z'] = 30.09
    },
	[2] = {
        ['x'] = 69.59,
        ['y'] = -974.80,
        ['z'] = 30.14
    },
	[3] = {
        ['x'] = 95.00,
        ['y'] = -634.89,
        ['z'] = 45.02
    },
	[4] = {
        ['x'] = 58.27,
        ['y'] = -283.32,
        ['z'] = 48.20
    },
	[5] = {
        ['x'] = 47.74,
        ['y'] = -160.44,
        ['z'] = 56.03
    },
	[6] = {
        ['x'] = 323.93,
        ['y'] = -267.58,
        ['z'] = 54.71
    },
	[7] = {
        ['x'] = 443.75,
        ['y'] = 119.16,
        ['z'] = 100.41
    },
	[8] = {
        ['x'] = 125.62,
        ['y'] = -4.42,
        ['z'] = 68.48
    },
	[9] = {
        ['x'] = -524.08,
        ['y'] = 133.59,
        ['z'] = 63.91
    },
	[10] = {
        ['x'] = -586.64,
        ['y'] = 268.39,
        ['z'] = 83.24
    },
	[11] = {
        ['x'] = -640.38,
        ['y'] = -163.16,
        ['z'] = 38.49
    },
	[12] = {
        ['x'] = -597.89,
        ['y'] = -361.27,
        ['z'] = 35.77
    },
	[13] = {
        ['x'] = -646.06,
        ['y'] = -804.09,
        ['z'] = 25.78
    },
	[14] = {
        ['x'] = -932.63,
        ['y'] = -1199.67,
        ['z'] = 5.91
    },
	[15] = {
        ['x'] = -1234.65,
        ['y'] = -1080.87,
        ['z'] = 9.12
    },
	[16] = {
        ['x'] = -1373.99,
        ['y'] = -793.23,
        ['z'] = 20.09
    },
	[17] = {
        ['x'] = -2011.25,
        ['y'] = -160.04,
        ['z'] = 29.40
    },
	[18] = {
        ['x'] = -2981.70,
        ['y'] = 404.50,
        ['z'] = 15.75
    },
	[19] = {
        ['x'] = -3101.58,
        ['y'] = 1112.65,
        ['z'] = 21.28
    },
	[20] = {
        ['x'] = -2556.10,
        ['y'] = 2322.01,
        ['z'] = 33.89
    },
	[21] = {
        ['x'] = -1094.86,
        ['y'] = 2675.87,
        ['z'] = 20.08
    },
	[22] = {
        ['x'] = -72.63,
        ['y'] = 2813.83,
        ['z'] = 54.60
    },
	[23] = {
        ['x'] = 540.55,
        ['y'] = 2685.25,
        ['z'] = 43.20
    },
	[24] = {
        ['x'] = 1119.93,
        ['y'] = 2682.04,
        ['z'] = 39.31
    },
	[25] = {
        ['x'] = 1470.51,
        ['y'] = 2725.47,
        ['z'] = 38.48
    },
	[26] = {
        ['x'] = 2002.62,
        ['y'] = 2603.65,
        ['z'] = 55.07
    },
	[27] = {
        ['x'] = 379.58,
        ['y'] = -599.20,
        ['z'] = 29.58
    }
}

Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        
        if not inService and not IsPedInAnyVehicle(ped) then
            local coords = GetEntityCoords(ped)

            for k,v in pairs(init) do
                local distance = #(coords - vector3(v.x,v.y,v.z))

                if distance <= 2.0 then
                    timeDistance = 4
                    DrawText3Ds(v.x,v.y,v.z + 0, 'PRESSIONE  ~b~E~w~  PARA  INICIAR')
                    if IsControlJustPressed(0, 38) then
                        inService = true
                        destiny = 1
                        createBlip(deliveries,destiny)
                    end
                end
            end
        end
        Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()

        if inService then
            local coords = GetEntityCoords(ped)
            local distance = #(coords - vector3(deliveries[destiny].x,deliveries[destiny].y,deliveries[destiny].z))
            local rainbow = RGBRainbow(1)

            if distance <= 50.0 then
                timeDistance = 4
                DrawMarker(30,deliveries[destiny].x,deliveries[destiny].y,deliveries[destiny].z - 0.50,0,0,0,0,180.0,130.0,0.6,0.8,0.5,rainbow.r,rainbow.g,rainbow.b,150,1,0,0,1)
                if distance <= 5.0 then
                    DrawText3Ds(deliveries[destiny].x,deliveries[destiny].y,deliveries[destiny].z - 0.10, 'PRESSIONE  ~b~E~w~  PARA  FINALIZAR  A  PARADA')
                    if IsControlJustPressed(0,38) and IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey('coach')) then
                        RemoveBlip(blip)
                        if destiny == 27 then
                            job.payment(1000)
                            destiny = 1
                        else
                            job.payment(0)
                            destiny = destiny + 1
                        end
                        createBlip(deliveries, destiny)
                    end
                end
            end
        end
        Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
	for k,v in pairs(init) do
		RequestModel(GetHashKey(v.hash2))
		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Wait(10)
		end

		local ped = CreatePed(4,v.hash,v.x,v.y,v.z-1,v.h,false,true)
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
	end
end)

RegisterCommand('finalizar',function(source,args)
	if inService then
        inService = false
        RemoveBlip(blip)
	end
end)

function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )

	return result
end

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry('STRING')
	SetTextCentre(1)
	AddTextComponentString(text)
    DrawText(_x,_y)
    
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.060+factor,0.03,0,0,0,80)
end

function createBlip(deliveries,destiny)
	blip = AddBlipForCoord(deliveries[destiny].x,deliveries[destiny].y,deliveries[destiny].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Rota de Motorista')
	EndTextCommandSetBlipName(blip)
end