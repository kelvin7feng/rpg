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

function OnWearEquip(dSlotId, strId)
    pkgUserDataManager.SetEquipSlot(dSlotId, strId)
    pkgEventManager.PostEvent(CLIENT_EVENT.UPDATE_WEAR_EQUIP, dSlotId)
end

function WearEquip(dSlotId, strId)
    pkgSocket.SendToLogic(EVENT_ID.EQUIP.WEAR_EQUIP, dSlotId, strId)
end

function OnTakeOff(dSlotId)
    pkgUserDataManager.SetEquipSlot(dSlotId, 0)
    pkgEventManager.PostEvent(CLIENT_EVENT.UPDATE_TAKE_OFF_EQUIP, dSlotId)
end

function TakeOff(dSlotId, strId)
    pkgSocket.SendToLogic(EVENT_ID.EQUIP.TAKE_OFF, dSlotId, strId)
end
