doNameSpace("pkgEquipCfgMgr")

AttrLanguage = {
    attr1           = 1001,
    attr2           = 1002,
    attr3           = 1003,
    attr4           = 1004,
    attr5           = 1005,
    attr6           = 1006,
    attr7           = 1007,
    attr8           = 1008,
    attr9           = 1009,
    attr10          = 1010,
    attr11          = 1011,
}

function GetEquipCfg(dId)
    return _cfg.equip[dId]
end

function GetAttrDescList(dId)
    local tbAttr = {}
    local tbCfg = GetEquipCfg(dId)
    if not tbCfg then
        return tbAttr
    end

    local dAttr = nil
    local dUnit = 0
    local dLId = 0
    for i=1,11 do
        dAttr = tbCfg["attr"..i]
        dUnit = tbCfg["unit"..i]
        dLId = AttrLanguage["attr"..i]
        if dAttr > 0 then
            if dUnit == 1 then
                dAttr = dAttr
                table.insert(tbAttr, string.format(pkgLanguageMgr.GetStringById(dLId),dAttr))
            else
                dAttr = dAttr * 0.01
                table.insert(tbAttr, string.format(pkgLanguageMgr.GetStringById(dLId),dAttr) .. "%")
            end
        end
    end

    return tbAttr
end