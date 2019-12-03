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