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