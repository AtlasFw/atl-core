exports('get', function()
  local resourceName = GetInvokingResource()
  if not ATL.Resources[resourceName] then
      ATL.Resources[resourceName] = GetInvokingResource()
  end
  return ATL
end)