doNameSpace("pkgHotfixedMgr")

le_tbLastestCfg = le_tbLastestCfg or {}
le_tbDownloadFile = le_tbDownloadFile or {}
le_tbExtractFile = le_tbExtractFile or {}

function CheckUpdate()
    local function completeCb(www)
        le_tbLastestCfg = cjson.decode(www.downloadHandler.text)
        local tbLocalCfg = pkgHotFixedCfg.GetLocalUpdateCfg()
        local dLocalVersion = tbLocalCfg.version
        local dLastestVersion = le_tbLastestCfg.version
        if dLastestVersion > dLocalVersion then
            pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_DOWNLOAD, true)
        else
            pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_DOWNLOAD, false)
        end
    end

    local function processCallback(dProcess)
        
    end
    
    local function errorCallback(www)
        local tbParam = {
            strContent  = "检查更新失败,请检查网络",   -- 显示文字
        }
        pkgUIBaseViewMgr.showByViewPath("game/alert/pkgUIAlert", nil, tbParam)
    end

    pkgDownloadMgr.download(pkgHotFixedCfg.GetUpdateCfgURL(), completeCb, processCallback, errorCallback)
end

function DownloadPatchFile()
    local tbLocalCfg = pkgHotFixedCfg.GetLocalUpdateCfg()
    local dLocalVersion = tbLocalCfg.version
    local dLastestVersion = le_tbLastestCfg.version

    le_tbDownloadFile = {}
    for i = dLocalVersion + 1, dLastestVersion do
        local strName = string.format("update%d.zip",i)
        local strUrl = string.format("%s/%s",tbLocalCfg.webURL, strName)
        table.insert(le_tbDownloadFile, {strName = strName, strUrl = strUrl})
    end

    StartDownload()
end

function StartDownload()
    local strUrl = le_tbDownloadFile[1].strUrl
    local strName = le_tbDownloadFile[1].strName

    local function completeCb(www)
        local patchFileBytes = www.downloadHandler.data
        local strSavePath = pkgHotFixedCfg.GetSavePath(strName)
        KG.CustomFile.SaveFile(strSavePath, patchFileBytes)
        table.remove(le_tbDownloadFile, 1)
        table.insert(le_tbExtractFile, {filePath = strSavePath})

        if #le_tbDownloadFile > 0 then
            StartDownload()
        else
            www:Dispose()
            pkgEventManager.PostEvent(pkgClientEventDefination.DOWNLOAD_COMPLETE)
        end
    end

    local function processCallback(dProcess)
        pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_DOWNLOAD_PROCESS, strName, dProcess)
    end
    
    local function errorCallback(www)
        print("handler error")
        www:Dispose()
    end

    pkgDownloadMgr.download(strUrl, completeCb, processCallback, errorCallback)
end

function UnzipPatchFile()
    if not le_tbExtractFile or #le_tbExtractFile <= 0 then
        pkgEventManager.PostEvent(pkgClientEventDefination.EXTRACT_COMPLETE)
        return
    end
    
    StartToUnzip()
end

function StartToUnzip()
    local strFilePath = le_tbExtractFile[1].filePath

    local function unzipComplete()
        table.remove(le_tbExtractFile, 1)
        if #le_tbExtractFile > 0 then
            StartToUnzip()
        else
            UpdateLocalCfg()
            KG.CustomFile.DeleteFile(strFilePath)
            pkgEventManager.PostEvent(pkgClientEventDefination.EXTRACT_COMPLETE)
        end
    end
    
    pkgExtractMgr.unzipFile(strFilePath, nil, unzipComplete)
end

function UpdateLocalCfg()
    local tbLocalCfg = pkgHotFixedCfg.GetLocalUpdateCfg()
    tbLocalCfg.version = le_tbLastestCfg.version
    pkgHotFixedCfg.SaveLocalUpdateCfg(tbLocalCfg)
end

function RequireFile()
    
    _G.__loading = true
    pkgTimer.clear()
    pkgTimerMgr.deleteAll()

    clearNameSpace()
    package.loaded["share/load"] = nil
    require("share/load")
    require("startHeader")

    pkgTimer.Init()
	pkgGlobalGoMgr.Init()
	pkgPoolManager.Init()
	pkgLuaManager.Init()
	pkgCanvasMgr.Init()
	pkgTriggerManager.Init()
	pkgProtocolManager.Init()
    pkgSysBattle.Init()
    
    _G.__loading = false
end

function OnUpdateFinish()
    
end
