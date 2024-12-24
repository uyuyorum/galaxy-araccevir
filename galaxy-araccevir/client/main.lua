RegisterCommand(Config.komut, function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(playerCoords, 3.0, 0, 70)

    if vehicle ~= 0 and DoesEntityExist(vehicle) and not IsVehicleOnAllWheels(vehicle) then
        local animDict = 'mini@repair'
        local animName = 'fixing_a_player'
        
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(10)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, 8.0, -1, 1, 0, false, false, false)

        local success = lib.progressBar({
            duration = 5000,
            label = 'Aracı çeviriyorsun...',
            useWhileDead = false,
            canCancel = false,
            anim = {
                dict = animDict,
                clip = animName
            }
        })

        ClearPedTasksImmediately(playerPed)

        if success then
            local coords = GetEntityCoords(vehicle)
            SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 0.5, false, false, false, true)
            SetEntityRotation(vehicle, 0.0, 0.0, GetEntityHeading(vehicle), 0, false)

            lib.notify({
                title = 'Başarılı!',
                description = 'Araç ters çevrildi.',
                type = 'success',
                position = Config.NotifyKonum
            })
        else
            lib.notify({
                title = 'İptal Edildi',
                description = 'Araç ters çevrilemedi.',
                type = 'error',
                position = Config.NotifyKonum
            })
        end
    else
        lib.notify({
            title = 'Hata',
            description = 'Yanında araç yok veya yeterince yakın değilsin.', -- https://www.cnnturk.com/kultur-sanat/veya-tdk-yazilisi-nasil-ve-ya-nasil-yazilir-birlesik-mi-ayri-mi-1596664
            type = 'error',
            position = Config.NotifyKonum
        })
    end
end)
