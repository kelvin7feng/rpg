doNameSpace("pkgUICropCollection")

assetbundleTag = "ui"
prefabFile = "CropCollectionUI"

event_listener = {
    {pkgClientEventDefination.ON_COLLECTION_NEW_CROP, "onCollectNewCrop"}
}

m_scrollView = m_scrollView or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
end

function resetScrollViewItem()
    for i=0, m_scrollView.transform.childCount - 1 do
        local goChild = goParent.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function onCollectNewCrop(tbCollection)
    local goIcon = m_scrollView.transform:Find(tbCollection.dId)
    if goIcon then
        pkgUIImageMgr.SetGrayRecursive(objIcon, false)
    else
        show()
    end
end

function show()
    
    local tbAllCrop = pkgGoodsCfgMgr.GetAllCropCfg()

    resetScrollViewItem()

    local function onLoadComplete(prefab)
        for i, tbGoodsInfo in ipairs(tbAllCrop) do
    
            local function onComplete(objIcon)
                if not pkgCollectionMgr.HaveCropCollection(tbGoodsInfo.id) then
                    pkgUIImageMgr.SetGrayRecursive(objIcon, true)
                end
            end
    
            local strIconName = tbGoodsInfo.id
            local goIcon = m_scrollView.transform:Find(strIconName)
            local tbArgs = {onClick = onClick, iconName = strIconName, size = pkgUITool.ICON_SIZE_TYPE.BIG, tbGoodsInfo = tbGoodsInfo, bIsBag = true}
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
    pkgUIBaseViewMgr.destroyUI(pkgUICropCollection)
end

function close()
    
end