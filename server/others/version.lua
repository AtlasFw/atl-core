function checkVersion()
  PerformHttpRequest('https://api.github.com/repos/AtlasFw/atl-core/releases/latest', function(code, response, headers)
    if code ~= 200 then
      Debug('Failed to fetch latest version', 'WARN')
      return
    end
    local latestVersion = json.decode(response).tag_name:sub(2)
    local currentVersion = GetResourceMetadata('atl-core', 'version', 0)

    if latestVersion > currentVersion then
      Debug(
        'New version available: ' .. latestVersion .. ' (https://github.com/AtlasFw/atl-core/releases/tag/' .. latestVersion .. ')',
        'WARN'
      )
    else
      Debug('You are running the latest version', 'SUCCESS')
    end
  end)
end

AddEventHandler('onServerResourceStart', checkVersion)
