---Loads dictionary
---@param dict string
ATL.RequestDict = function(dict)
  local timeout = false
  SetTimeout(5000, function()
    timeout = true
  end)

  repeat
    RequestAnimDict(dict)
    Wait(50)
  until HasAnimDictLoaded(dict) or timeout
end

---Loads model/prop
---@param model string
ATL.RequestModel = function(model)
  local timeout = false
  SetTimeout(5000, function()
    timeout = true
  end)

  local hashModel = GetHashKey(model)
  repeat
    RequestModel(hashModel)
    Wait(50)
  until HasModelLoaded(hashModel) or timeout
end

---Loads animset/walk
---@param walk string
ATL.RequestWalk = function(walk)
  local timeout = false
  SetTimeout(5000, function()
    timeout = true
  end)

  repeat
    RequestAnimSet(walk)
    Wait(50)
  until HasAnimSetLoaded(walk) or timeout
end

---Loads particle effects
---@param asset string
ATL.RequestParticleFx = function(asset)
  local timeout = false
  SetTimeout(5000, function()
    timeout = true
  end)

  repeat
    RequestNamedPtfxAsset(asset)
    Wait(50)
  until HasNamedPtfxAssetLoaded(asset) or timeout
end
