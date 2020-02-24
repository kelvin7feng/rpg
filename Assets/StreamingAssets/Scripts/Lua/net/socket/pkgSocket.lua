doNameSpace("pkgSocket")

socketCore = require "socket.core"
strIp = nil
dPort = 0
socket = nil
dReceiveTimer = nil

local function connect(address, port)
    local sock, err = socketCore.tcp()
    if not sock then return nil, err end
    local res, err = sock:connect(address, port)
    if not res then return nil, err end
    sock:settimeout(0)
    return sock
end

local function receive_msg()
    --print("receive_msg===============")
    local recvt, sendt, status = socketCore.select({socket}, nil, 1)
    if #recvt > 0 then
        local response, receive_status = socket:receive()
        if receive_status ~= "closed" then
            if response then
                print(response)
                recvt, sendt, status = socketCore.select({socket}, nil, 1)
            end
        end
    end
end

function ReceiveMsg()
    if not socket then
        return
    end
    local header = socket:receive(20)
    if header then
        local _, dTotolPacketSize, dServerId, dHandler, _reserver1, _reserver2, str = string.unpack(header,"<I<I<I<I<I")
        local dBodySize = dTotolPacketSize - 20
        local body = socket:receive(dBodySize)
        if body then
            local tb = json.decode(body)
            pkgEventManager.PostEvent(unpack(tb))
        end
    end
end

function IsConnected()
    return pkgSocket.socket
end

function ConnectToServer(strIp, dPort)
    local session, err = connect(strIp, dPort)
    if not session then
        print("connect failed", err)
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

function Send(strData)
    if not IsConnected() then
        local bRet = Reconnect()
        if not Reconnect() then
            print("reconnect failed")
            return false
        end
    end
    local sendResult = socket:send(strData)
    if sendResult then
        print("send ok:", sendResult)
    end
end

function Disconnect()
    if IsConnected() then
        print("Disconnect() ==================== ")
        socket:shutdown()
        socket = nil
    end
end