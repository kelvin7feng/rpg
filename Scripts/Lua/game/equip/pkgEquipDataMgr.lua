doNameSpace("pkgEquipDataMgr")

function GetEquipingBaseCfg()
    local tbEquiping = {}
    local tbSlots = pkgUserDataManager.GetEquipSlots()
    for i, strEquipId in ipairs(tbSlots) do
        local tbEquip = pkgUserDataManager.GetEquip(strEquipId)
        if tbEquip then
            table.insert(tbEquiping, tbEquip.cfgId)
        end        
    end

    return tbEquiping
end