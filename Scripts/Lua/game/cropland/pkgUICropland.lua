doNameSpace("pkgUICropland")

assetbundleTag = "ui"
prefabFile = "CroplandUI"

event_listener = {
    
}

m_tbBtn = m_tbBtn or {}
m_dCurBtnIndex = nil

local function onClickCropland(btnGo, i)
    m_dCurBtnIndex = i
    local dState = pkgCroplandDataMgr.GetLandState(i)
    if dState == pkgCroplandCfgMgr.State.EMPTY then
        pkgUIBaseViewMgr.showByViewPath("game/cropland/pkgUISelecteSeed")
    elseif dState == pkgCroplandCfgMgr.State.PLANTING then

    elseif dState == pkgCroplandCfgMgr.State.HARVEST then

    else

    end
end

function init()
    
    for i=1, pkgCroplandCfgMgr.CROPLAND_COUNT do
        local objBtn = gameObject.transform:Find("Panel/CroplandPanel/Cropland"..i)
        m_tbBtn[i] = objBtn
        pkgButtonMgr.AddBtnListener(objBtn, onClickCropland, i)
    end
end

function show()

end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUICropland)
end

function close()
    
end