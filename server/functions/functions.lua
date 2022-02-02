ATL.GetLicense = function(playerId, cb)
    local identifiers = GetPlayerIdentifiers(playerId)
    local matchingIdentifier = "license:"
    for i=1, #identifiers do
        if identifiers[i]:match(matchingIdentifier) then
            if not cb then
                return identifiers[i]
            end
            return cb(identifiers[i])
        end
    end
    if not cb then
        return false
    end
    return cb(false)
end