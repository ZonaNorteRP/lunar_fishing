local level = 1

---@param l number
local function updated(l)
    if not l then 
        l = 1 -- Usa nível 1 como padrão se não conseguir obter o nível
    end
    
    level = l
    Update(level)
end

-- Inicializa os blips quando o recurso carrega
CreateThread(function()
    Wait(2000) -- Aguarda 2 segundos para garantir que tudo está carregado
    lib.callback('lunar_fishing:getLevel', false, updated)
end)

RegisterNetEvent('esx:playerLoaded', function()
    lib.callback('lunar_fishing:getLevel', 100, updated)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    lib.callback('lunar_fishing:getLevel', 100, updated)
end)

RegisterNetEvent('lunar_fishing:updateLevel', updated)

function GetCurrentLevel()
    return math.floor(level)
end

function GetCurrentLevelProgress()
    return level - math.floor(level)
end
