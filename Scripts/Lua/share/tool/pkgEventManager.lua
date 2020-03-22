doNameSpace("pkgEventManager")

m_tbRegisterEvent = m_tbRegisterEvent or {};
m_dEventCount = 0

-- 反注册函数
function Unregister(dHandlerId)
	if m_tbRegisterEvent[dHandlerId] then
		m_tbRegisterEvent[dHandlerId] = nil
	end
end

-- 注册函数
function Register(strEventType, funcCallback, objCall)
	
	if not strEventType then
		__TRACKBACK__("Register Event Failed: strEventType is nil");
		return false;
	end

	-- 检查回调函数，可不检查回调函数的对象，可以兼容全局函数的使用
	--[[if not IsFunction(funcCallback) then
		LOG_ERROR("Register Event Failed: funcCallback is nil");
		return false;
	end--]]

	m_dEventCount = m_dEventCount + 1

	local tbEvent = {id = m_dEventCount, obj = objCall, callback = funcCallback, eventType = strEventType}
	m_tbRegisterEvent[tbEvent.id] = tbEvent
	
	return m_dEventCount
end

-- 触发事件
function PostEvent(strEventName, ...)
	for _, tbEvent in pairs(m_tbRegisterEvent) do
		if tbEvent.eventType == strEventName then
			local obj = tbEvent.obj
			local callback = tbEvent.callback

			if obj then
				obj[callback](...)
				-- callback(obj, ...)
			else
				if IsFunction(callback) then
					callback(...)
				else
					print("I can't help you")
					_G[callback]()
				end
			end
		end
	end
end

-- 打印事件
function PrintEvent()
	for id, tbEvent in pairs(m_tbRegisterEvent) do
		LOG_INFO("key:" .. id .. ",value:" .. tbEvent.eventType)
	end
end