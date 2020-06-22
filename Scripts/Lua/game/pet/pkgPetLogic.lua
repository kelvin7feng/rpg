doNameSpace("pkgPetLogic")

function CanShowRedPoint(i)
    return false
end

function IsPetAt(i)
    local tbList = pkgPetDataMgr.GetPetTeam()
    if tbList[i] and tbList[i] ~= 0 then
        return true
    end
    return false
end

function IsSlotEmpty(dSlotId)
    local strId = pkgPetDataMgr.GetPetSlot(dSlotId)
    return IsStringEmpty(strId) and true or false
end

function PetBattle(dCurrentSlot, strPetId)
    pkgSocket.SendToLogic(EVENT_ID.PET.BATTLE, dCurrentSlot, strPetId)
end

function OnPetBattle(dCurrentSlot, strPetId)
    local player = pkgActorManager.GetMainPlayer()
    if not IsSlotEmpty(dCurrentSlot) then
        local strId = pkgPetDataMgr.GetPetSlot(dCurrentSlot)
        local pet = pkgPetTeam.GetPlayPet(player, dCurrentSlot)
        if pet then
            pkgSysPlayer.Destory(pet)
        end
        pkgPetDataMgr.SetPetRest(dCurrentSlot, strId)
    end
    
    local function funcCallback()
        pkgPetDataMgr.SetPetSlot(strPetId, dCurrentSlot)
        pkgPetDataMgr.SetTeamPos(dCurrentSlot, strPetId)
        pkgAttrLogic.CalcPlayerAttr(player)
        pkgEventManager.PostEvent(pkgClientEventDefination.ON_PET_PLAY, dCurrentSlot)
    end

    local dPetId = tonumber(strPetId)
    pkgPetTeam.CreateOnePet(player, dCurrentSlot, dPetId, funcCallback)
end

function PetRest(dCurrentSlot)
    pkgSocket.SendToLogic(EVENT_ID.PET.REST, dCurrentSlot)
end

function OnPetRest(dCurrentSlot)
    local player = pkgActorManager.GetMainPlayer()
    local strPetId = pkgPetDataMgr.GetPetSlot(dCurrentSlot)
    local pet = pkgPetTeam.GetPlayPet(player, dCurrentSlot)
    if pet then
        pkgSysPlayer.Destory(pet)
    end
    pkgPetDataMgr.SetPetRest(dCurrentSlot, strPetId)
    pkgAttrLogic.CalcPlayerAttr(player)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_PET_REST, dCurrentSlot)
end
