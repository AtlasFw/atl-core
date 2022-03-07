ATL.SendLog = function(tag, message)
  if type(tag) ~= "string" or type(message) ~= "string" then error("ATL: SendLog: tag and message must be a string") end

  if Config.Logs.API_KEY ~= '' then
    PerformHttpRequest("https://http-intake.logs.datadoghq.com/api/v2/logs", function (errorCode, resultData, resultHeaders)
      print("Returned error code:" .. tostring(errorCode))
      print("Returned data:" .. tostring(resultData))
      print("Returned result Headers:" .. tostring(resultHeaders))
    end, "POST", json.encode({
      hostname = GetConvar("sv_projectName", ""),
      service = GetInvokingResource() or 'atl-core',
      message = message,
      ddsource = 'lua',
      ddtags = tag
    }), {
      ["Content-Type"] = "application/json",
      ['DD-API-KEY'] = Config.Logs.API_KEY
    })
  end
end