doNameSpace("pkgHotFixedCfg")

UPDATE_CFG_NAME = "game.json"
SAVE_PATH = string.format("%s",__downloadPath)

function Init()
    KG.CustomFile.CreateDir(SAVE_PATH)
end

function GetUpdateCfgURL()
    local tbLocalCfg = GetLocalUpdateCfg()
    local strURL = string.format("%s/%s", tbLocalCfg.webURL, UPDATE_CFG_NAME)
    return strURL
end

function GetLocalUpdateCfg()
    local strFilePath = GetUpdateCfgPath()
    local strLocalCfg = KG.CustomFile.ReadAllText(strFilePath)
    local tbLocalCfg = cjson.decode(strLocalCfg)
    return tbLocalCfg
end

function GetUpdateCfgPath()
    local strFilePath = string.format("%s/%s", __streamingAssetsPath, UPDATE_CFG_NAME)
    if not KG.CustomFile.IsFileExits(strFilePath) then
        strFilePath = string.format("%s/%s", __persistentDataPath, UPDATE_CFG_NAME)
    end

    return strFilePath
end

function GetSavePath(strFileName)
    if not strFileName then
        return nil
    end

    return string.format("%s/%s", SAVE_PATH, strFileName)
end

Init()