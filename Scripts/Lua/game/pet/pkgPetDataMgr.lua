doNameSpace("pkgPetDataMgr")

local function sortByQualityDesc(a,b)
    local tbCfg1 = pkgPetCfgMgr.GetPetCfg(a.cfgId)
    local tbCfg2 = pkgPetCfgMgr.GetPetCfg(b.cfgId)
    --[[if tbCfg1.quality ~= tbCfg2.quality then
        return tbCfg1.quality > tbCfg2.quality
    elseif tbCfg1.slot ~= tbCfg2.slot then
        return tbCfg1.slot < tbCfg2.slot
    else
        return tbCfg1.id > tbCfg2.id
    end--]]
    return tbCfg1.id > tbCfg2.id
end


function GetPetTeam()
    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    return tbPetInfo.tbTeam
end

function GetPetList()
    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    return tbPetInfo.tbPetList
end

function GetPet(strId)
    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    return tbPetInfo.tbPetList[strId]
end

function SetPetSlot(strId, dSlot)
    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    tbPetInfo.tbPetList[tostring(strId)].slot = dSlot 
end

function GetPetSlot(i)
    local tbTeam = GetPetTeam()
    local strId = tbTeam[i]
    return strId
end

function SetTeamPos(i, strId)
    if not i or not strId then
        return
    end
    local tbPetInfo = pkgUserDataManager.GetPetInfo()

    tbPetInfo.tbTeam[i] = strId
end

function GetFreePetList()
    local tb = {}
    local tbPetList = GetPetList()
    
    for _, tbPetInfo in pairs(tbPetList) do
        local dSlotPetId = tonumber(tbPetInfo.cfgId)
        if tbPetInfo.slot == 0 then
            table.insert(tb, tbPetInfo)
        end
    end

    table.sort(tb, sortByQualityDesc)
	
    return tb
end

function GetUsingPetAttrList()
    local tbUsing = {}
    local tbSlots = GetPetTeam()
    for i, strPetId in ipairs(tbSlots) do
        if strPetId and strPetId ~= 0 then
            table.insert(tbUsing, pkgPetCfgMgr.GetPetCfg(strPetId).attrId)
        end        
    end

    return tbUsing
end

function SetPetRest(dSlotId, strPetId)
    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    tbPetInfo.tbTeam[dSlotId] = 0
    tbPetInfo.tbPetList[strPetId].slot = 0
end

function SetPetInfo(strId, tbInfo)
    
    if not strId or not tbInfo then
        return false
    end

    strId = tostring(strId)

    local tbPetInfo = pkgUserDataManager.GetPetInfo()
    tbPetInfo.tbPetList[strId] = tbInfo

    return true
end