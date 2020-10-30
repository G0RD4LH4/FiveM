Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        
        if GetPedArmour(ped) > 0 then
            if GetPedDrawableVariation(ped, 9) ~= 6 then
                SetPedComponentVariation(ped, 9, 6, 1, 2)
            end
        else
            SetPedComponentVariation(ped, 9, 0, 1, 2)
        end
        
        Wait(timeDistance)
    end
end)