---@param source integer
---@param fishName string
---@param amount integer
local MarketPrices = {}

-- Função para atualizar os preços do mercado (Variação de 20% ou min/max)
local function UpdateMarketPrices()
    for name, data in pairs(Config.fish) do
        if type(data.price) == 'number' then
            local variation = data.price * 0.20
            MarketPrices[name] = math.random(math.floor(data.price - variation), math.ceil(data.price + variation))
        else
            MarketPrices[name] = math.random(data.price.min, data.price.max)
        end
    end
    print('^2[lunar_fishing]^7 Preços do mercado de peixes atualizados!')
end

-- Thread para atualizar a cada 1 hora
CreateThread(function()
    UpdateMarketPrices()
    while true do
        Wait(60 * 60 * 1000) -- 60 minutos
        UpdateMarketPrices()
    end
end)

lib.callback.register('lunar_fishing:sellFish', function(source, fishName, amount)
    local item = Config.fish[fishName]
    if not item or amount <= 0 then return end

    local price = MarketPrices[fishName] or (type(item.price) == 'number' and item.price or item.price.min)
    
    local player = Framework.getPlayerFromId(source)

    if not player then return end

    if player:getItemCount(fishName) >= amount then
        player:removeItem(fishName, amount)
        player:addAccountMoney(Config.ped.sellAccount, price * amount)
        return true
    end

    return false
end)

---@param source integer
---@param amount integer
lib.callback.register('lunar_fishing:buy', function(source, data, amount)
    local type, index = data.type, data.index

    if type ~= 'fishingRods' and type ~= 'baits' then return false end

    local item = Config[type][index]
    if not item or amount <= 0 then return false end

    local price = item.price * amount

    local player = Framework.getPlayerFromId(source)
    if not player then return false end

    local playerSkills = exports["cw-rep"]:fetchSkills(source)
    local playerLevel = playerSkills and playerSkills.fishing or 0

    if playerLevel < item.minLevel then
        return 'level'
    end

    local balance = player:getAccountMoney(Config.ped.buyAccount)
    local usingBank = false

    -- If player is low on cash, check the bank balance
    if balance < price and Config.ped.buyAccount == 'money' then
        local bankBalance = player:getAccountMoney('bank')
        if bankBalance >= price then
            balance = bankBalance
            usingBank = true
        end
    end

    if balance >= price then
        if usingBank then
            player:removeAccountMoney('bank', price)
        else
            player:removeAccountMoney(Config.ped.buyAccount, price)
        end
        player:addItem(item.name, amount)
        return true
    else
        return 'money'
    end
end)

lib.callback.register('lunar_fishing:getTabletData', function(source)
    local player = Framework.getPlayerFromId(source)
    if not player then return false end

    local playerSkills = exports["cw-rep"]:fetchSkills(source)
    
    return true, {
        player = {
            balance = player:getAccountMoney(Config.ped.buyAccount),
            level = playerSkills and playerSkills.fishing or 0,
            xp = playerSkills and playerSkills.fishing_xp or 0, 
            nextLevelXp = playerSkills and (playerSkills.fishing + 1) * 100 or 100,
            totalCaught = 0, -- Placeholder
            biggestCatch = '-' -- Placeholder
        },
        marketPrices = MarketPrices
    }
end)

lib.callback.register('lunar_fishing:sellAllFish', function(source, fishName)
    local player = Framework.getPlayerFromId(source)
    if not player then return false end

    local amount = player:getItemCount(fishName)
    if amount <= 0 then return false end

    local item = Config.fish[fishName]
    local price = MarketPrices[fishName] or (type(item.price) == 'number' and item.price or item.price.min)

    player:removeItem(fishName, amount)
    player:addAccountMoney(Config.ped.sellAccount, price * amount)
    
    return true
end)