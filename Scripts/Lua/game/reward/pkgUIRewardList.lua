doNameSpace("pkgUIRewardList")

assetbundleTag = "ui"
prefabFile = "RewardList"

m_scrollView = m_scrollView or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/imBg/Scroll View/Viewport/Content")
end

function show(tbRewardList)
    local function onLoadCompelte(prefab)
        for i, tbGoodsInfo in ipairs(tbRewardList) do
            local strIconName = "goods"..i
            local dGoodsId, dCount = unpack(tbGoodsInfo)
            local icon = m_scrollView.transform:Find(strIconName)
            if pkgUITool.isNull(icon) then
                pkgUITool.CreateIcon(dGoodsId, m_scrollView, nil, {onClick = onClickIcon, count = dCount, iconName = strIconName})
            end
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "GoodsIcon", onLoadCompelte)
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIRewardList) 
end

function close()
    
end