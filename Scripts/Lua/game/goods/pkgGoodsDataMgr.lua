doNameSpace("pkgGoodsDataMgr")

function GetGold()
    return pkgUserDataManager.GetBagVal(GOODS_DEF.GOLD)
end

function GetDiamond()
    return pkgUserDataManager.GetBagVal(GOODS_DEF.DIAMOND)
end

function GetExp()
    return pkgUserDataManager.GetBagVal(GOODS_DEF.EXP)
end