doNameSpace("pkgGoodsCfgMgr")

function GetGoodsCfg(dId)
    return _cfg.goods[tonumber(dId)]
end