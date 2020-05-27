doNameSpace("pkgUICropland")

assetbundleTag = "ui"
prefabFile = "CroplandUI"

event_listener = {
    {pkgClientEventDefination.ON_PLANT_CROP, "updateOneLand"}
}

m_tbCropland = m_tbCropland or {}
m_tbTimer = m_tbTimer or {}
m_dCurBtnIndex = nil

local function onClickCropland(btnGo, i)
    m_dCurBtnIndex = i
    local dState = pkgCroplandMgr.GetLandState(i)
    if dState == pkgCroplandCfgMgr.State.EMPTY then
        pkgUIBaseViewMgr.showByViewPath("game/cropland/pkgUISelecteSeed", nil, i)
    elseif dState == pkgCroplandCfgMgr.State.PLANTING then
        local bCanHarvest = pkgCroplandMgr.CanHarvest(i)
        if bCanHarvest then
            pkgCroplandMgr.Harvest(i)
        else
            Toast(pkgLanguageMgr.GetStringById(30002))
        end
    end
end

function updateOneLand(tbLandInfo)
    
    if not tbLandInfo then
        return
    end

    local dLandId = tbLandInfo.dLandId
    local objCropland = m_tbCropland[dLandId]
    if not objCropland then
        return
    end

    local tbCropCfg = pkgCroplandCfgMgr.GetCropCfg(tbLandInfo.dId)

    local dState = tbLandInfo.dState
    if dState == pkgCroplandCfgMgr.State.EMPTY then
        pkgUITool.SetActiveByName(objCropland, "ImgCrop", false)
        pkgUITool.SetActiveByName(objCropland, "Process", false)
        pkgUITool.SetActiveByName(objCropland, "ImgHand", false)
        pkgUITool.SetActiveByName(objCropland, "ImgHarvest", false)
    elseif dState == pkgCroplandCfgMgr.State.PLANTING then
        local dCfgGrowTime = tbCropCfg.growTime
        local dPlantTime = tbLandInfo.dPlantTime
        local dEndTime = dPlantTime + dCfgGrowTime
        
        local function setHarvest()
            local imgHarvest = objCropland.transform:Find("ImgHarvest")
            pkgUITool.ResetImage(tbCropCfg.harvestIconBundle, tbCropCfg.harvestIconName, imgHarvest)
            pkgUITool.SetActiveByName(objCropland, "ImgHand", true)
            pkgUITool.SetActive(imgHarvest, true)
        end

        local function setPlantingState(bActive)
            pkgUITool.SetActiveByName(objCropland, "ImgCrop", bActive)
            pkgUITool.SetActiveByName(objCropland, "Process", bActive)
            pkgUITool.SetActiveByName(objCropland, "ImgHand", not bActive)   
        end

        if os.time() < dEndTime then
            local objSlider = objCropland.transform:Find("Process")
            local sliderCmpt = objSlider:GetComponent(UnityEngine.UI.Slider)
            local dTimerId = nil
            sliderCmpt.maxValue = dCfgGrowTime
            dTimerId = pkgTimerMgr.addWithoutDelay(1000, function()
                if dEndTime - os.time() > 0 then
                    pkgUITool.SetStringByName(objCropland, "Process/Text", dEndTime - os.time())
                    sliderCmpt.value = dCfgGrowTime - (dEndTime - os.time())
                else
                    pkgTimerMgr.delete(dTimerId)
                    pkgUITool.SetStringByName(objCropland, "Process/Text", "")
                    setPlantingState(false)
                    setHarvest()
                    sliderCmpt.value = dCfgGrowTime
                end
            end)

            if m_tbTimer[dLandId] then
                pkgTimerMgr.delete(m_tbTimer[dLandId])
                m_tbTimer[dLandId] = nil
            end

            m_tbTimer[dLandId] = dTimerId

            local imgCrop = objCropland.transform:Find("ImgCrop")
            pkgUITool.ResetImage(tbCropCfg.plantIconBundle, tbCropCfg.plantIconName, imgCrop)
            setPlantingState(true)
        else
            setHarvest()
        end
    end
end

function init()
    
    for i=1, pkgCroplandCfgMgr.CROPLAND_COUNT do
        local objCropland = gameObject.transform:Find("Panel/CroplandPanel/Cropland"..i)
        m_tbCropland[i] = objCropland
        pkgButtonMgr.AddBtnListener(objCropland, onClickCropland, i)
    end

end

function show()
    local tbAllInfo = pkgCroplandDataMgr.GetLandInfo()
    if not tbAllInfo or #tbAllInfo <= 0 then
        return
    end

    for i, tbLandInfo in ipairs(tbAllInfo) do
        updateOneLand(tbLandInfo)
    end
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUICropland)

    for dLandId, dTimerId in pairs(m_tbTimer) do
        pkgTimerMgr.delete(dTimerId)
    end

    m_tbCropland = {}
end

function close()

end