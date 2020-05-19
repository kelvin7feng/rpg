doNameSpace("pkgEquipMgr")

function OnUpdateData(tbEquipList)
	
    if not tbEquipList then
        return
    end

    for strId, tbEquip in pairs(tbEquipList) do
        pkgUserDataManager.SetEquip(strId, tbEquip)
    end

    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_EQUIP)
end

function OnDeleteEquip(tbEquipList)
	
    if not tbEquipList then
        return
    end

    for _, strId in pairs(tbEquipList) do
        pkgUserDataManager.SetEquip(strId, nil)
    end

    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_EQUIP)
end

function OnWearEquip(dSlotId, strId)
    Toast(pkgLanguageMgr.GetStringById(20003))
    pkgUserDataManager.SetEquipSlot(dSlotId, strId)
    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_WEAR_EQUIP, dSlotId)
end

function WearEquip(dSlotId, strId)
    pkgSocket.SendToLogic(EVENT_ID.EQUIP.WEAR_EQUIP, dSlotId, strId)
end

function OnTakeOff(dSlotId)
    Toast(pkgLanguageMgr.GetStringById(20004))
    pkgUserDataManager.SetEquipSlot(dSlotId, 0)
    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_TAKE_OFF_EQUIP, dSlotId)
end

function TakeOff(dSlotId, strId)
    pkgSocket.SendToLogic(EVENT_ID.EQUIP.TAKE_OFF, dSlotId, strId)
end

function LevelUp(strId, tbConsumeEquip)
    pkgSocket.SendToLogic(EVENT_ID.EQUIP.LEVEL_UP, strId, tbConsumeEquip)
end

function OnLevelUp(strId, dLevel, dLevelUpExp)
    Toast(pkgLanguageMgr.GetStringById(20002))
    local tbEquip = pkgUserDataManager.GetEquip(strId)
    tbEquip.dLevel = dLevel
    tbEquip.dLevelUpExp = dLevelUpExp
    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_LEVEL_UP_EQUIP, strId)
end
