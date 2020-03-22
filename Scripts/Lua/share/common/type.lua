
--类型判断
--检查是否数字,空参数为falase
function IsNumber(t)
	return type(t) == "number"
end

--检查是否为表,空参数为falase
function IsTable(t)
	return type(t) == "table"
end

--检查是否为字符串,空参数为falase
function IsString(t)
	return type(t) == "string"
end

--检查是否为nil
function IsNil(t)
	return type(t) == "nil"
end

--检查是否为函数
function IsFunction(t)
	return type(t) == "function"
end

--检查是否为nil
function IsBoolean(t)
	return type(t) == "boolean"
end

--检查是否浮点数
function IsFloat(t)
	if IsNumber(t) and math.floor(t) < t then
		return true;
	end

	return false;
end

--检查是否为正确错误码
function IsOkCode(t)
	return t == ERROR_CODE.SYSTEM.OK
end

--类型转换
function ConvertType(value,sType)
	local returnValue = nil
	if sType == "string" then
		returnValue = tostring(value)
	elseif sType == "number" then
		returnValue = tonumber(value)
	elseif sType == "boolean" then
		if value == "true" then
			returnValue = true
		else
			returnValue = false
		end
	elseif sType == "json" then
		returnValue = cjson.decode(value)
	elseif sType == "nil" then
		returnValue = nil
	end
	
	return returnValue
end 