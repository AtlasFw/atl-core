---Loads dictionary
---@param dict string
ATL.RequestDict = function(dict)
  local maxTime = GetGameTimer() + 250
  while not HasAnimDictLoaded(dict) do
    if GetGameTimer() > maxTime then
      return
    end
    RequestAnimDict(dict)
    Wait(0)
  end
end

---Loads model/prop
---@param model string
ATL.RequestModel = function(model)
  local maxTime = GetGameTimer() + 250
  local hashModel = joaat(model)
  while not HasModelLoaded(hashModel) do
    if GetGameTimer() > maxTime then
      return
    end
    RequestModel(hashModel)
    Wait(0)
  end
end

---Loads animset/walk
---@param walk string
ATL.RequestWalk = function(walk)
  local maxTime = GetGameTimer() + 250
  while not HasAnimSetLoaded(walk) do
    if GetGameTimer() > maxTime then
      return
    end
    RequestAnimSet(walk)
    Wait(0)
  end
end

---Loads particle effects
---@param asset string
ATL.RequestParticleFx = function(asset)
  local maxTime = GetGameTimer() + 250
  while not HasNamedPtfxAssetLoaded(asset) do
    if GetGameTimer() > maxTime then
      return
    end
    RequestNamedPtfxAsset(asset)
    Wait(0)
  end
end
