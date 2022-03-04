--[[ function checkVersion()
  print("check version")
  PerformHttpRequest(Config.GitHub, function(code, response, headers)
    if code ~= 200 then
      print('[ATL] Failed to fetch latest version.')
      return
    end
    local latestVersion = json.decode(response).tag_name:sub(2)
    local currentVersion = GetResourceMetadata("atl-core", "version", 0)
    print("latestVersion: " .. latestVersion)
    print("currentVersion: " .. currentVersion)
    if latestVersion > currentVersion then
      print("new version available")
    else 
      print("ATL is up to date")
    end
  end)
end
checkVersion() ]]