doNameSpace("pkgHeartbeatMgr")

HEARTBEAT_TIME = 2000

m_dHeartbeatTimer = m_dHeartbeatTimer or nil
m_dHeartbeatCount = 0
m_dResponseCount = 0

function DeleteTimer()
    if m_dHeartbeatTimer then
        pkgTimerMgr.delete(m_dHeartbeatTimer)
        m_dHeartbeatTimer = nil
    end
end

function StopHeartbeat()
    m_dHeartbeatCount = 0
    m_dResponseCount = 0

    DeleteTimer()
end

function Heartbeat()
    m_dHeartbeatCount = m_dHeartbeatCount + 1
    pkgSocket.SendToLogic(EVENT_ID.NET.HEART_BEAT_1)
    if m_dHeartbeatCount > m_dResponseCount + 1 then
        -- 落后2次了,认为断线,停止心跳
        StopHeartbeat()

        pkgSocket.Disconnect()
        pkgSocket.Reconnect()
    end
end

function OnHeartbeat()
    m_dResponseCount = m_dResponseCount + 1
end

function StartToSend()
    if m_dHeartbeatTimer then
        return
    end

    StopHeartbeat()

    m_dHeartbeatTimer = pkgTimerMgr.add(HEARTBEAT_TIME, function()
        Heartbeat()
    end)
end