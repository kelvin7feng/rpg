doNameSpace("pkgDownloadMgr")

le_dowonLoad_list = le_dowonLoad_list or {}
le_downLoad_timer_id = le_downLoad_timer_id or nil

function getHttpType()
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		return "https"
	end
	return "http"
end

local function onDownLoadTimer()
    local tbCompleteList = {}
    local tbErrorList = {}
    local www = nil
    for strUrl, tbInfo in pairs(le_dowonLoad_list) do
        www = tbInfo.www
        if www.isNetworkError or www.isHttpError then
            tbErrorList[strUrl] = tbInfo
        else
            if www.isDone then
                tbCompleteList[strUrl] = tbInfo
            end
            local processCallback = tbInfo.processCallback
            if processCallback then
                processCallback(www.downloadProgress)
            end
        end
	end

    for strUrl, tbInfo in pairs(tbErrorList) do
		local funcErrorCallback = tbInfo.errorCallback
        if funcErrorCallback then
			funcErrorCallback(tbInfo.www)
			tbInfo.www:Dispose()
        end
		le_dowonLoad_list[strUrl] = nil
    end
    
	for strUrl, tbInfo in pairs(tbCompleteList) do
		local funcCompleteCb = tbInfo.completeCb
		if funcCompleteCb then
			funcCompleteCb(tbInfo.www)
			tbInfo.www:Dispose()
		end
		le_dowonLoad_list[strUrl] = nil
	end	

	if not next(le_dowonLoad_list) and le_downLoad_timer_id then
		pkgTimer.DeleteTimer(le_downLoad_timer_id)
		le_downLoad_timer_id = nil
	end
end

function download(strUrl, completeCb, processCallback, errorCallback)
	local strHttpType = getHttpType()
	local strHttpUrl = string.format("%s://%s", strHttpType, strUrl)
	if le_dowonLoad_list[strHttpUrl] then
		return
	end
	
	local www = UnityEngine.Networking.UnityWebRequest.Get(strHttpUrl) 
    le_dowonLoad_list[strHttpUrl] = {}
    le_dowonLoad_list[strHttpUrl].www = www
    le_dowonLoad_list[strHttpUrl].completeCb = completeCb
    le_dowonLoad_list[strHttpUrl].processCallback = processCallback
    le_dowonLoad_list[strHttpUrl].errorCallback = errorCallback
    www:SendWebRequest()

    if not le_downLoad_timer_id then
        le_downLoad_timer_id = pkgTimer.AddRepeatTimer("downloadTimer", 0.1, onDownLoadTimer)
    end
end