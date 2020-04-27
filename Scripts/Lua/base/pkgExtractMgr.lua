doNameSpace("pkgExtractMgr")

le_bUnziping = false

EXTRACT_PATH = string.format("%s", UnityEngine.Application.persistentDataPath)

function getExtractDirPath()
    return EXTRACT_PATH
end

function getUpdateZipPath(strFileName)
    return string.format("%s/%s", __patchPath, strFileName)
end

function unzipFile(strZipPath)
    
    if le_bUnziping then
        return
    end

    local function unzipProgress( dCurrent, dTotal )
        local str = string.format("progress:%0.2f%%", dCurrent/dTotal * 100)
        print(str)
    end

    local function unzipComplete()
        le_bUnziping = false
    end
    
    local function errorCallback( strMsg )
        le_bUnziping = false
    end

    le_bUnziping = true
    local strDownloadPath = getExtractDirPath()
    pkgZipMgr.unzip(strZipPath, strDownloadPath, unzipProgress, unzipComplete, errorCallback)
end