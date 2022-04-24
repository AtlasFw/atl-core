ATL.CreateCoordsBlip = function(data)
	if type(data) ~= "table" then
		return
	end

	local blip = AddBlipForCoord(data.coords)
	SetBlipSprite(blip, data.sprite or 76)
	SetBlipDisplay(blip, data.display or 2)
	SetBlipScale(blip, data.scale or 0.8)
	SetBlipColour(blip, data.color or 63)
	SetBlipAlpha(blip, data.alpha or 255)
	SetBlipAsShortRange(blip, data.shortRange or false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(data.label or "Atlas Blip")
	EndTextCommandSetBlipName(blip)
	print("asd")
	return blip
end

ATL.CreateRadiusBlip = function(data)
	if type(data) ~= "table" then
		return
	end

	local blip = AddBlipForRadius(data.coords, data.radius)
	SetBlipSprite(blip, data.sprite or 76)
	SetBlipDisplay(blip, data.display or 2)
	SetBlipColour(blip, data.color or 63)
	SetBlipAlpha(blip, data.alpha or 255)
	SetBlipAsShortRange(blip, data.shortRange or false)

	return blip
end

ATL.CreateAreaBlip = function(data)
	if type(data) ~= "table" then
		return
	end

	local blip = AddBlipForArea(data.coords, data.weight, data.height)
	SetBlipDisplay(blip, data.display or 2)
	SetBlipColour(blip, data.color or 63)
	SetBlipAlpha(blip, data.alpha or 255)
	SetBlipAsShortRange(blip, data.shortRange or false)

	return blip
end

ATL.CreateEntityBlip = function(data)
	if type(data) ~= "table" then
		return
	end

	local blip = AddBlipForEntity(data.entity)
	SetBlipSprite(blip, data.sprite or 76)
	SetBlipDisplay(blip, data.display or 2)
	SetBlipScale(blip, data.scale or 0.8)
	SetBlipColour(blip, data.color or 63)
	SetBlipAlpha(blip, data.alpha or 255)
	SetBlipAsShortRange(blip, data.shortRange or false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(data.label or "Atlas Blip")
	EndTextCommandSetBlipName(blip)

	return blip
end
