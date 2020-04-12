doNameSpace("pkgSocket")

socketCore = require "socket.core"
strIp = nil
dPort = 0
socket = nil
dReceiveTimer = nil
dHeaderLength = 20

-- 接收内容缓冲区
strReceiveData = ""
dReceiveLength = 0

ERROR_TIPS = {
    [1]                     = "拒绝",
    [2]                     = "拒绝连接",
    [3]                     = "服务器主动断开",
    [4]                     = "没有权限",
    [5]                     = "超时",
    [6]                     = "未知错误",
    [7]                     = "未知服务器",
}

ERROR_CODE = {
    ["refuse"]              = 1,
    ["connection refused"]  = 2,
    ["closed"]              = 3,
    ["permission denied"]   = 4,
    ["timeout"]             = 5,
    ["unknown error"]       = 6,
    ["unknown host"]        = 7,
}

local function connect(address, port)

    --[[local ip = socketCore.dns.toip(address)
    if ip == nil then
        print("Unkown Host: ", address)
        return nil, "unknown host"
    end--]]

    local sock, err = socketCore.tcp()
    if not sock then return nil, err end
    local res, err = sock:connect(address, port)
    if not res then return nil, err end
    sock:settimeout(0)
    sock:setoption("keepalive", true)
    sock:setoption("tcp-nodelay", true)
    return sock
end

local function shutdown()
    print("shut down")
    socket:shutdown()
    socket = nil
    strReceiveData = ""
end

function ReceiveMsg()
    if not socket then
        return
    end
    
    local bRet = xpcall(
        function()
            local data, status, partial = socket:receive("*a")
            if status == "closed" then
                print("receive error:", ERROR_TIPS[ERROR_CODE[status]])
                shutdown()
                return
            end

            local strAppend = (data or partial)
            if strAppend then
                strReceiveData = strReceiveData .. strAppend
                dReceiveLength = dReceiveLength + #strAppend
            end

            if dReceiveLength >= dHeaderLength then
                print("dReceiveLength >= dHeaderLength:", dReceiveLength , dHeaderLength)
                local dStartSize, dTotolPacketSize = string.unpack(strReceiveData,"<I")
                if dReceiveLength >= dTotolPacketSize then
                    -- 如果是一个完整包,就处理
                    print("dReceiveLength >= dBodySize:", dReceiveLength, dTotolPacketSize)
                    local strBody = string.sub(strReceiveData, dHeaderLength+1, dTotolPacketSize)
                    local tb = cjson.decode(strBody)
                    LOG_INFO("receive:"..string.len(strBody).."|"..strBody.."|")
                    LOG_TABLE(tb)

                    pkgEventManager.PostEvent(unpack(tb))
                    -- delete current pack
                    strReceiveData = string.sub(strReceiveData, dTotolPacketSize + 1)
                    dReceiveLength = #strReceiveData
                end
            end
        end, __TRACKBACK__)

	if not bRet then
		LOG_ERROR("ReceiveMsg error:", bRet)
    end
end

function IsConnected()
    return pkgSocket.socket
end

function ConnectToServer(strIp, dPort)
    local session, err = connect(strIp, dPort)
    if not session then
        print("connect error:", ERROR_TIPS[ERROR_CODE[err]])
        return false
    end

    socket = session
    strIp = strIp
    dPort = dPort

    print(string.format("connect to %s:%d succeefully.", strIp, dPort))

    return true
end

function Reconnect()
    if socket then
        Disconnect()
    end
    return ConnectToServer(pkgGlobalConfig.GATEWAT_IP, pkgGlobalConfig.GATEWAY_PORT)
end

function SendToLogic(dProtocolId, ...)
    local tb = {dProtocolId,{...}}
    local strJson = cjson.encode(tb)

    pkgSocket.Send(pkgGlobalConfig.ServerType.LOGIC, strJson)
end

function Send(dServerType, strData)
    if not IsConnected() then
        local bRet = Reconnect()
        if not Reconnect() then
            print("reconnect failed")
            return false
        end
    end
    
    local strBody = string.pack("<P", strData)
    local strFixHeader = string.pack("<I<I<I<I<I", dHeaderLength + #strBody, dServerType, 0, 0, 0)

    local sendResult = socket:send(strFixHeader .. strBody)
    if sendResult then
        print("send to server:"..string.len(strData).."|"..strData.."|".."total:"..sendResult)
    end
end

function Disconnect()
    if IsConnected() and socket then
        print("Disconnect() ==================== ")
        socket:shutdown()
        socket = nil
    end
end