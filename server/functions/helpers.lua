function CheckType(...)
	local args = {...}
	for i = 1, #args do
		if type(args[i]) ~= 'table' then
			error('Argument ' .. i .. ' is not a table')
		end

		local val, valType = args[i][1], args[i][2]
		if type(val) ~= valType then
			error('Expected "' .. valType .. '" got ' .. type(val))
		end
	end
	return setmetatable(args, {
		__tostring = function()
			local str = ''
			for i = 1, #args do
				str = str .. args[i][1] .. ', '
			end
			return str:sub(1, -3)
		end
	})
end

function GetIdentifier(playerId, identifierType)
	local identifiers = GetPlayerIdentifiers(playerId)
	if not identifierType then
		return identifiers
	end

	for i = 1, #identifiers do
		if identifiers[i]:match(identifierType .. ':') then
			return identifiers[i]
		end
	end
	error('No identifier of type "' .. identifierType .. '" found')
end

exports('CheckType', CheckType)
exports('GetIdentifier', GetIdentifier)