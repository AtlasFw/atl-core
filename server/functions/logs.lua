-- We are not supporting discord webhook logs. You must use DataDog logs or implement your own logs.
-- We will also not accept pull requests implementing discord logs. However, we are open to
-- pull requests for DataDog logs or other log options.
-- If you need help setting up DataDog logs, please read the documentation or ask on the discord.
-- https://atlasfw.live/documentation

---Sends a log to your DataDog account.
---@param tag string - Tag for the log (error, info, success, etc)
---@param message string - Message to send
---@return boolean - True if successful, false if not
ATL.SendLog = function(tag, message)
  if type(tag) ~= 'string' or type(message) ~= 'string' then error('ATL: SendLog: tag and message must be a string') end

  if Config.Logs.API_KEY ~= '' then
    PerformHttpRequest('https://http-intake.logs.datadoghq.com/api/v2/logs', function (errorCode, resultData, resultHeaders)
      print('Returned error code:' .. tostring(errorCode))
      print('Returned data:' .. tostring(resultData))
      print('Returned result Headers:' .. tostring(resultHeaders))
    end, 'POST', json.encode({
      hostname = GetConvar('sv_projectName', ''),
      service = GetInvokingResource() or 'atl-core',
      message = message,
      ddsource = 'lua',
      ddtags = tag
    }), {
      ['Content-Type'] = 'application/json',
      ['DD-API-KEY'] = Config.Logs.API_KEY
    })
    return true
  end
  return false
end