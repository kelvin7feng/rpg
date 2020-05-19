doNameSpace("pkgLanguageMgr")

function FormatStr(str, ...)
    local args = {...}
    return string.gsub(str, "{([%d]+)}", function(index)
        return args[tonumber(index)]
    end)
end

function GetStringById(dLanguageStringId, ...)
    if not dLanguageStringId then
        print("dLanguageStringId is nil")
        return ""
    end
    local tbLanguageCfg = _cfg.language[dLanguageStringId]
    if not tbLanguageCfg then
        print("can't find the id:", dLanguageStringId)
        return dLanguageStringId
    end
    
    local str =  tbLanguageCfg[pkgGlobalConfig.DefaulutLanguage]
    return FormatStr(str, ...)
end
