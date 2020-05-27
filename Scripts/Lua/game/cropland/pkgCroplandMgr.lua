doNameSpace("pkgCroplandMgr")

function GetLandState(dIndex)
    local tbInfo = pkgCroplandDataMgr.GetLandInfoByIndex(dIndex)
    return tbInfo.dState
end

function CanPlant(dIndex, dId)

    if dIndex < 0 or dIndex > pkgCroplandCfgMgr.CROPLAND_COUNT then
        return false
    end

    local dState = GetLandState(dIndex)
    if dState ~= pkgCroplandCfgMgr.State.EMPTY then
        return false
    end

    if pkgUserDataManager.GetBagVal(dId) <= 0 then
        return false
    end

    return true
end

function Plant(dIndex, dId)
    if not CanPlant(dIndex, dId) then
        Toast(pkgLanguageMgr.GetStringById(30001))
        return false
    end

    pkgSocket.SendToLogic(EVENT_ID.CROPLAND.PLANT, dIndex, dId)
end

function OnPlant(tbLandInfo)
    LOG_TABLE(tbLandInfo)
    pkgCroplandDataMgr.SetLandInfo(tbLandInfo)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_PLANT_CROP, tbLandInfo)
end

function CanHarvest(dIndex)

    if dIndex < 0 or dIndex > pkgCroplandCfgMgr.CROPLAND_COUNT then
        return false
    end

    local tbLandInfo = pkgCroplandDataMgr.GetLandInfoByIndex(dIndex)
    if not tbLandInfo then
        return
    end
    
    local dState = tbLandInfo.dState
    if dState ~= pkgCroplandCfgMgr.State.PLANTING then
        return false
    end

    local tbCropCfg = pkgCroplandCfgMgr.GetCropCfg(tbLandInfo.dId)
    if not tbCropCfg then
        return false
    end
    
    local dCfgGrowTime = tbCropCfg.growTime
    local dPlantTime = tbLandInfo.dPlantTime
    local dEndTime = dPlantTime + dCfgGrowTime
    if os.time() < dEndTime then
        return false
    end

    return true
end