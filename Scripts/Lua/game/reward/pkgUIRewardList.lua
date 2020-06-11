doNameSpace("pkgUIRewardList")

assetbundleTag = "ui"
prefabFile = "RewardList"

m_scrollView = m_scrollView or nil

local sortReward = function(a, b)
	if a == nil or b == nil then 
		return false 
    end
    local cfg1 = pkgGoodsCfgMgr.GetGoodsCfg(a[1])
    local cfg2 = pkgGoodsCfgMgr.GetGoodsCfg(b[1])
    return cfg1.id > cfg2.id
end

function init()
    m_scrollView = gameObject.transform:Find("Panel/imBg/Scroll View/Viewport/Content")
end

function show(tbRewardList)
	if not tbRewardList or #tbRewardList <= 0 then
        return
    end

    table.sort(tbRewardList, sortReward)

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