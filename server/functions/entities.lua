ATL.DeleteEntity = function(netId)
	CheckType({netId, 'number'})

	local entity = NetworkGetEntityFromNetworkId(netId)
	if entity > 0 then
		DeleteEntity(entity)
		return true
	end
	return false
end