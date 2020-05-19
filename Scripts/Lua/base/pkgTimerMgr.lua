doNameSpace("pkgTimerMgr")

le_timerDict = le_timerDict or {}

function once( dDelayTime, funcCallback )
	local dTimerId = LuaTimer.Add(dDelayTime, funcCallback)
	le_timerDict[dTimerId] = true
	return dTimerId
end

function add( dIntervalTime, funcCallback )
	local dTimerId = LuaTimer.Add(dIntervalTime, dIntervalTime, funcCallback)
	le_timerDict[dTimerId] = true
	return dTimerId
end

function addWithoutDelay( dIntervalTime, funcCallback )
	local dTimerId = LuaTimer.Add(0, dIntervalTime, funcCallback)
	le_timerDict[dTimerId] = true
	return dTimerId
end

function delete( dTimerId )
    if not dTimerId then return end
	LuaTimer.Delete(dTimerId)
	le_timerDict[dTimerId] = nil
end

function deleteAll()
	for dTimerId, _ in pairs(le_timerDict) do
		delete(dTimerId)
	end
end
