doNameSpace("pkgLanguageMgr")

function GetStringById(dLanguageStringId)
    if not dLanguageStringId then
        print("dLanguageStringId is nil")
        return ""
    end
    local tbLanguageCfg = _cfg.language[dLanguageStringId]
    if not tbLanguageCfg then
        print("can't find the id:", dLanguageStringId)
        return dLanguageStringId
    end
    
    return tbLanguageCfg[pkgGlobalConfig.DefaulutLanguage]
end
