doNameSpace("pkgEquipMgr")

function OnUpdateData(tbEquipList)
	
    if not tbEquipList then
        return
    end

    for strId, tbEquip in pairs(tbEquipList) do
        pkgUserDataManager.SetEquip(strId, tbEquip)
    end

    pkgEventManager.PostEvent(CLIENT_EVENT.UPDATE_EQUIP)
end