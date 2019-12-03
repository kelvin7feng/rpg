doNameSpace("pkgEventManager")

m_tbRegisterEvent = m_tbRegisterEvent or {};

-- 注册函数
function Register(strEventType, funcCallback, objCall)
	
	if not strEventType then
		__TRACKBACK__("Register Event Failed: strEventType is nil");
		return false;
	end

	-- 检查回调函数，可不检查回调函数的对象，可以兼容全局函数的使用
	if not IsFunction(funcCallback) then
		LOG_ERROR("Register Event Failed: funcCallback is nil");
		return false;
	end

	if m_tbRegisterEvent[strEventType] then
		LOG_ERROR("Register Event Failed: Event duplicate...Please check event type");
		return false;
	end
	
	m_tbRegisterEvent[strEventType] = {obj = objCall, callback = funcCallback};
end

-- 触发事件
function PostEvent(strEventName, tbParam)

	local tbEvent = m_tbRegisterEvent[strEventName];
	if not tbEvent then
		LOG_ERROR(string.format("Event [%s] does not register...", strEventName))
		return;
	end
	
	local obj = tbEvent.obj;
	local callback = tbEvent.callback;

	if obj then
		return callback(obj, tbParam);
	else
		return callback(tbParam);
	end
end

-- 分发客户端事件
function DispatcherEvent(nHandlerId, nEventId, tbParam)

	local tbEvent = m_tbRegisterEvent[nEventId];
	if not tbEvent then
		LOG_ERROR(string.format("Event [%d] does not register...", nEventId))
		return ERROR_CODE.SYSTEM.EVENT_ID_ERROR;
	end
	
	local obj = tbEvent.obj;
	local callback = tbEvent.callback;
	
	if obj then
		return callback(obj, nHandlerId, unpack(tbParam));
	else
		return callback(nHandlerId, unpack(tbParam));
	end

end

-- 打印事件
function PrintEvent()
	for key,value in pairs(m_tbRegisterEvent) do
		LOG_INFO("key:" .. key .. ",value:" .. json.encode(value))
	end
end