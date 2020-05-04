doNameSpace("pkgExtractMgr")

le_bUnziping = false

EXTRACT_PATH = string.format("%s", UnityEngine.Application.persistentDataPath)

function getExtractDirPath()
    return EXTRACT_PATH
end

function unzipFile(strZipPath, unzipProgress, unzipComplete, errorCallback)
    
    if le_bUnziping then
        return
    end

    local tbStr = string.split(strZipPath, "/")
    local strFileName = tbStr[#tbStr]

    local function unzipDefaultProgress(dCurrent, dTotal)
        pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_EXTRACT_PROCESS, strFileName or "", dCurrent/dTotal)
        if unzipProgress then
            unzipProgress()
        end
    end

    local function unzipDefaultComplete()
        le_bUnziping = false
        if unzipComplete then
            unzipComplete()
        end
    end
    
    local function errorCallback(strMsg)
        le_bUnziping = false
    end

    le_bUnziping = true
    local strDownloadPath = getExtractDirPath()
    pkgZipMgr.unzip(strZipPath, strDownloadPath, unzipDefaultProgress, unzipDefaultComplete, errorCallback)
end