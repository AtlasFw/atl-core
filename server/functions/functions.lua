ATL.GetLicense = function (id, cb)
    local identifiers = GetPlayerIdentifiers(id)
    local matchingIdentifier = "license:"
    for i=1, #identifiers do
        if identifiers[i]:match(matchingIdentifier) then
            if not cb then
                return identifiers[i]
            end
            return cb(identifiers[i])
        end
    end
end