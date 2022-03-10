-- We are not supporting discord webhook logs. You must use DataDog logs or implement your own logs.
-- We will also not accept pull requests implementing discord logs. However, we are open to
-- pull requests for DataDog logs or other log options.
-- If you need help setting up DataDog logs, please read the documentation or ask on the discord.
-- https://atlasfw.live/documentation

local DEBUG_COLORS = {
  ['ERROR'] = '\x1b[31m',
  ['SUCCESS'] = '\x1b[32m',
  ['WARN'] = '\x1b[33m',
}

local STATUS_CODES = {
  [202] = 'Accepted: the request has been accepted for processing',
  [400] = 'Bad request (likely an issue in the payload formatting)',
  [401] = 'Unauthorized (likely a missing API Key)',
  [403] = 'Permission issue (likely using an invalid API Key)',
  [408] = 'Request Timeout, request should be retried after some time',
  [413] = 'Payload too large (batch is above 5MB uncompressed)',
  [429] = 'Too Many Requests, request should be retried after some time',
  [500] = 'Internal Server Error, the server encountered an unexpected condition that prevented it from fulfilling the request, request should be retried after some time',
  [503] = 'Service Unavailable, the server is not ready to handle the request probably because it is overloaded, request should be retried after some time',
}

function Debug(msg, type)
  if not msg then
    return nil
  end
  if not type then
    type = 'INFO'
  end

  Citizen.Trace(
    '\x1b[38;5;33m[ATL]^0 '
      .. DEBUG_COLORS[type:upper()]
      .. '['
      .. type:upper()
      .. ']^0 '
      .. msg
      .. '^0'
  )
end

---Sends a log to your DataDog account.
---@param tag string - Tag for the log (error, info, success, etc)
---@param message string - Message to send
---@return boolean - True if successful, false if not
ATL.SendLog = function(tag, message)
  if type(tag) ~= 'string' or type(message) ~= 'string' then
    error 'ATL: SendLog: tag and message must be a string'
  end

  if Server.Logs.API_KEY ~= '' then
    PerformHttpRequest(
      'https://http-intake.logs.datadoghq.com/api/v2/logs',
      function(errorCode, resultData, resultHeaders)
        if Server.Logs.SHOW_IN_CONSOLE then
          if errorCode == 202 then
            Debug('Log [' .. tag .. '] - ' .. message)
          else
            Debug('Log error ' .. STATUS_CODES[errorCode], 'SUCCESS')
          end
        end
      end,
      'POST',
      json.encode {
        hostname = GetConvar('sv_projectName', ''),
        service = GetInvokingResource() or 'atl-core',
        message = message,
        ddsource = 'lua',
        ddtags = tag,
      },
      {
        ['Content-Type'] = 'application/json',
        ['DD-API-KEY'] = Server.Logs.API_KEY,
      }
    )
    return true
  end
  return false
end
