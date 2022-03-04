local function handleHotReloadStop(resource)
    if resource ~= GetCurrentResourceName() then return false end
    SetResourceKvp("resources", json.encode(ATL.Resources))
end

local function handleHotReloadStart(resource)
    if resource ~= GetCurrentResourceName() then return false end
    CreateThread(function ()
        local p = promise.new()
        local resources = json.decode(GetResourceKvpString("resources"))
        if not resources then return end
        for _, resource in pairs(resources) do
            StopResource(resource)
            StartResource(resource)
        end
        SetResourceKvp("resources", "")
        ATL.Resources = {}
        p:resolve(true)
        Citizen.Await(p)
    end)
end

AddEventHandler("onServerResourceStop", handleHotReloadStop)
AddEventHandler("onServerResourceStart", handleHotReloadStart)