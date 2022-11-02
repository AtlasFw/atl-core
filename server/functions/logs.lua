local STATUS_CODES = {
	[202] = 'Accepted: the request has been accepted for processing',
	[400] = 'Bad request (likely an issue in the payload formatting)',
	[401] = 'Unauthorized (likely a missing API Key)',
	[403] = 'Permission issue (likely using an invalid API Key)',
	[408] = 'Request Timeout, request should be retried after some time',
	[413] = 'Payload too large (batch is above 5MB uncompressed)',
	[429] = 'Too Many Requests, request should be retried after some time',
	[500] = 'Internal Server Error, the server encountered an unexpected condition that prevented it from fulfilling the request, request should be retried after some time',
	[503] = 'Service Unavailable, the server is not ready to handle the request probably because it is overloaded, request should be retried after some time',
}

function Logger(resourceName, debug)
	local self = setmetatable({
		resourceName = resourceName,
		debug = debug,
	}, Logger)

	function self:Success(msg)
		CheckType(msg, 'string')
		SendLog('^2SUCCESS^7', msg, self.resourceName, self.debug)
	end

	function self:Error(msg)
		CheckType({msg, 'string'})
		SendLog('^3ERROR^7', msg, self.resourceName, self.debug)
	end

	function self:Info(msg)
		CheckType({msg, 'string'})
		SendLog('^2INFO^7', msg, self.resourceName, self.debug)
	end

	function self:Warn(msg)
		CheckType({msg, 'string'})
		SendLog('^1WARN^7', msg, self.resourceName, self.debug)
	end

	function self:Debug(msg)
		if type(msg) == 'table' then
			msg = json.encode(msg, {indent = true})
		end
		print(msg)
	end

	return self
end

function SendLog(type, message, resourceName, debug)
	if Server.DDApiKey == '' then
		TriggerServerEvent('txaLogger:CommandExecuted', message)
		if debug then
			print(('[%s] [%s]: %s'):format(resourceName, type, message))
		end
		return
	end
	PerformHttpRequest('https://http-intake.logs.datadoghq.com/api/v2/logs', function(errorCode, resultData, resultHeaders)
		if errorCode ~= 202 then
			local errorMessage = STATUS_CODES[errorCode] or 'Unknown error'
			print(('Error sending log to Datadog (%s): %s'):format(errorCode, errorMessage))
		end
	end, 'POST', json.encode {
		hostname = GetConvar('sv_projectName', 'Atlas Default Host'),
		service = resourceName,
		message = message,
		ddsource = 'lua',
		ddtags = type,
	}, {
		['Content-Type'] = 'application/json',
		['DD-API-KEY'] = Server.DDApiKey
	})
end

exports('Logger', Logger)