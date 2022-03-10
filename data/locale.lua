local Locales = {}

local lang = Shared.Locale or 'en'
local file = LoadResourceFile(GetCurrentResourceName(), ('data/locales/%s.lua'):format(lang))
if file then
  local func, err = load(file)
  if func then
    Locales = func()
  else
    error('[ATL Core] Error loading locale: ' .. err)
  end
else
  error('[ATL Core] Error loading locale: file not found')
end

---Exportable function that returns
---the specified locale.
---@param key string - Key of the locale
---@param ... any - Values to replace in the locale (args)
---@return any - The locale value (string/table/number/etc)
function GetLocale(key, ...)
  local val = Locales[key]
  if type(key) ~= 'string' or not val then return 'Key does not exist' end

  if type(val) == 'string' then
    return (val or ''):format(...)
  else
    return val
  end
end

---Instead of doing exports('GetLocale', GetLocale)
---We return the function so that the following can be done.
---local customName = exports['atl-core']:GetLocale()
---Now you can simply use your customName instead of
--- Having to use the export every time.
exports('GetLocale', function()
  return GetLocale
end)