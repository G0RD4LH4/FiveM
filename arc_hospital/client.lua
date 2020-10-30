local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local hospital = {
    { 
    	vec3(348.82, -583.36, 43.31), 
    	vec3(349.71, -583.56, 44.01), 
    	heading = 330.0 
    },
    { 
    	vec3(344.24, -582.21, 43.31),
    	vec3(344.66, -580.87, 44.01),
    	heading = 70.0 
	},
	{
		vec3(352.31 ,-584.43, 43.31),
		vec3(353.10, -584.77, 44.10),
		heading = 330.0
	},
	{
		vec3(355.82, -585.73, 43.31),
		vec3(356.56, -585.94, 44.10),
		heading = 330.0
	},
	{
		vec3(359.60, -586.81, 43.31),
		vec3(360.55, -587.08, 44.01),
		heading = 330.0
	},
	{
		vec3(346.12, -590.31, 43.31),
		vec3(346.99, -590.55, 44.10),
		heading = 150.0
	},
	{
		vec3(349.93, -591.46, 43.31),
		vec3(350.78, -591.64, 44.10),
		heading = 150.0
	},
	{
		vec3(353.42, -592.40, 43.31),
		vec3(354.26, -592.52, 44.10),
		heading = 150.0
	},
	{
		vec3(356.51, -593.99, 43.31),
		vec3(357.42, -594.50, 44.10),
		heading = 150.0
	},
	{
		vec3(333.69, -579.32, 43.31),
		vec3(334.00, -578.37, 44.00),
		heading = 70.0
	},
	{
		vec3(326.08, -576.07, 43.31),
		vec3(326.92, -576.15, 44.02),
		heading = 330.0
	},
	{
		vec3(322.88, -574.99, 43.31),
		vec3(323.69, -575.05, 44.02),
		heading = 330.0
	}
}

CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()

        if not IsPedInAnyVehicle(ped) then
            local coords = GetEntityCoords(ped)

            for k,v in pairs(hospital) do
                local deitarPosition = v[1]
                local distance = #(coords - deitarPosition)
                if distance < 1.2 then
                    timeDistance = 4
                    drawTxt("PRESSIONE  ~b~E~w~  PARA  DEITAR",4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,38) then
                        local macaPosition = v[2]
                        local macaHeading = v.heading
                        SetEntityCoords(ped, macaPosition)
                        SetEntityHeading(ped, macaHeading)
                        vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
                    end
                end
            end
        end
        Wait(timeDistance)
    end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end