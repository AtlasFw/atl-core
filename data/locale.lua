local Locales = {}

local function LoadLang()
    local lang = Config.Shared.Locale or 'en'
    local file = LoadResourceFile(GetCurrentResourceName(), ('data/locales/%s.lua'):format(lang))
    if file then
        local func, err = load(file)
        if func then
            return func()
        else
            error('[ATL Core] Error loading locale: ' .. err)
        end
    else
        error('[ATL Core] Error loading locale: file not found')
    end
    return {}
end

Locales = LoadLang()

function GetLocale(key, ...)
    if type(key) ~= 'string' or not Locales[key] then return 'Key does not exist' end
    return (Locales[key] or ''):format(...)
end

exports('GetLocale', function()
    return GetLocale
end)