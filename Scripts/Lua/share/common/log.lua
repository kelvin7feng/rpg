
--日志打印模块
LOG_TYPE = {
	DEBUG = 3,
	WARN = 2,
	ERROR = 1,
	INFO = 0
}

LOG_HEADER = {
	[LOG_TYPE.DEBUG] = "DEBUG",
	[LOG_TYPE.WARN]  = "WARNING",
	[LOG_TYPE.ERROR] = "ERROR",
	[LOG_TYPE.INFO]  = "INFO"
}

-- Debug开关
DEBUG_SWITCH = true;

-- Log level, DEBUG > WARN > ERROR > INFO = 0
LOG_LEVEL = 3;

local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local next = next

--打印函数
local function LOG_DEBUG_CORE(nLevel, ...)

	if nLevel > LOG_LEVEL then
		return;
	end

	local args = {...}
	local strMsg = string.format("Lua %s[%s]: ", LOG_HEADER[nLevel], os.date("%Y-%m-%d %H:%M:%S",os.time()));

	for k,v in ipairs(args) do
		strMsg = strMsg .. tostring(v) .. "\t"
	end

	print(strMsg)
end

--Debug输出
function LOG_DEBUG(...)

	if not DEBUG_SWITCH then return end

	LOG_DEBUG_CORE(LOG_TYPE.DEBUG, ...)
end

--警告输出
function LOG_WARN(...)

	if not DEBUG_SWITCH then return end

	LOG_DEBUG_CORE(LOG_TYPE.WARN, ...)
end

--普通信息输出
function LOG_INFO(...)

	LOG_DEBUG_CORE(LOG_TYPE.INFO, ...)
end

--错误输出
function LOG_ERROR(...)

	LOG_DEBUG_CORE(LOG_TYPE.ERROR, ...)
end

--打印堆栈
function DEBUG_TRACE_BACE(strMessage, nRecursion)
	
	local strError = debug.traceback(strMessage, nRecursion or 3)
	LOG_ERROR(strError)		
end

function OsExit(i)
	os.exit(i)
end

-- 检查是否为错误
function IsError(value, strMessage)

	local bIsError = not value
	
	if bIsError then
		
		if strMessage then			
			LOG_ERROR(strMessage)		
		else
			DEBUG_TRACE_BACE("@:", 3)
		end
		
	end

	return bIsError
end

-- 打印table
function LOG_TABLE(root)
	if not root then
		LOG_INFO("Table is nil")
		return;
	end

	if not IsTable(root) then
		LOG_WARN("Type is not table")
		return;
	end

	local cache = {[root] = "."}
	local function _dump(t,space,name)
		local temp = {}
		for k,v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				tinsert(temp,space .. key .. " {" .. cache[v].."}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				tinsert(temp, space.."+"..key)
				tinsert(temp, _dump(v, space..space, new_key))
			else
				tinsert(temp, space .. key .. " [" .. tostring(v).."]")
			end
		end
		return tconcat(temp,"\n")
 	end
	LOG_INFO("+table\n"..(_dump(root, "|  ","")))
end

-- 报错回调
function __TRACKBACK__(errmsg)
    DEBUG_TRACE_BACE(errmsg);
    return false;
end
