doNameSpace("pkgUISelecteSeed")

assetbundleTag = "ui"
prefabFile = "SelectSeedUI"

event_listener = {
    
}

m_scrollView = m_scrollView or nil
m_defaultPanel = m_defaultPanel or nil
m_dSelectLandId = m_dSelectLandId or 0

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
    m_defaultPanel = gameObject.transform:Find("Panel/DefaultPage")
    m_defaultPanel.gameObject:SetActive(false)
end

function resetScrollViewItem()
    for i=0, m_scrollView.transform.childCount - 1 do
        local goChild = goParent.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function show(dIndex)
    local tbBagInfo = pkgUserDataManager.GetBag(GOODS_DEF.SEED)
    if #tbBagInfo <= 0 then
        m_defaultPanel.gameObject:SetActive(true)
        return
    end

    m_dSelectLandId = dIndex

    local function onLoadComplete(prefab)
        for i, tbGoodsInfo in ipairs(tbBagInfo) do
            local function onClick(goBtn, tbData)
                pkgCroplandMgr.Plant(m_dSelectLandId, tonumber(tbGoodsInfo.id))
                destroyUI()
            end
    
            local function onComplete(goBtn)
                
            end
    
            local strIconName = tbGoodsInfo.id
            local goIcon = m_scrollView.transform:Find(strIconName)
            local tbArgs = {onClick = onClick, iconName = strIconName, count = tbGoodsInfo.count}
            if pkgUITool.isNull(goIcon) then
                pkgUITool.CreateIcon(tbGoodsInfo.id, m_scrollView, onComplete, tbArgs)
            else
                pkgUITool.UpdateIcon(goIcon, tbGoodsInfo.id, onComplete, tbArgs)
            end
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "GoodsIcon", onLoadComplete)
    
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUISelecteSeed)
end

function close()
    
end