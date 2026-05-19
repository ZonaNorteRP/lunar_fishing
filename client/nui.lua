local isTabletOpen = false

function OpenFishingTablet()
    if isTabletOpen then return end
    
    local success, data = lib.callback.await('lunar_fishing:getTabletData', false)
    
    if not success then
        ShowNotification('Erro ao carregar dados do tablet.', 'error')
        return
    end

    isTabletOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = 'open',
        player = data.player,
        config = Config,
        marketPrices = data.marketPrices
    })
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    isTabletOpen = false
    cb('ok')
end)

RegisterNUICallback('buyItem', function(data, cb)
    local formattedData = {
        type = data.type == 'rod' and 'fishingRods' or (data.type == 'bait' and 'baits' or data.type),
        index = (data.index or 0) + 1
    }
    local success = lib.callback.await('lunar_fishing:buy', false, formattedData, 1) -- Buy 1 for now
    
    if success == true then
        -- Refresh player data after buy
        local _, newData = lib.callback.await('lunar_fishing:getTabletData', false)
        SendNUIMessage({
            action = 'open', -- Reuse open to refresh
            player = newData.player,
            config = Config,
            marketPrices = newData.marketPrices
        })
        ShowNotification('Compra realizada com sucesso!', 'success')
    elseif success == 'level' then
        ShowNotification('Nível de pesca insuficiente para comprar este item!', 'error')
    elseif success == 'money' then
        ShowNotification('Você não tem dinheiro suficiente (carteira ou banco)!', 'error')
    else
        ShowNotification('Erro ao processar a compra ou item indisponível.', 'error')
    end
    cb('ok')
end)

RegisterNUICallback('sellItem', function(data, cb)
    -- The NUI sends 'fishName'. In our system, sellFish expects fishName and amount.
    -- We can implement "Sell All" logic here or in server.
    local success = lib.callback.await('lunar_fishing:sellAllFish', false, data.fishName)
    
    if success then
        -- Refresh
        local _, newData = lib.callback.await('lunar_fishing:getTabletData', false)
        SendNUIMessage({
            action = 'open',
            player = newData.player,
            config = Config,
            marketPrices = newData.marketPrices
        })
    end
    cb('ok')
end)

RegisterNUICallback('rentBoat', function(data, cb)
    -- Call the existing rentVehicle function from rent.lua logic
    -- Since rentVehicle is local to rent.lua, we'll trigger a global event or just re-implement
    TriggerEvent('lunar_fishing:client:rentBoatFromNui', (data.index or 0) + 1)
    cb('ok')
end)
