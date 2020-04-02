doNameSpace("pkgUIGoodsMain")

assetbundleTag = "ui"
prefabFile = "GoodsUI"

event_listener = {
    
}

m_scrollView = m_scrollView or nil
m_defaultPanel = m_defaultPanel or nil

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

function show()
    local tbBagInfo = pkgUserDataManager.GetBag()
    if #tbBagInfo <= 0 then
        m_defaultPanel.gameObject:SetActive(true)
        return
    end

    local function onLoadCompelte(prefab)
        for i, tbGoodsInfo in ipairs(tbBagInfo) do
            local strKey = "goods" .. i
            local goNow = m_scrollView.transform:Find(strKey)
            if pkgUITool.isNull(goNow) then
                goNow = UnityEngine.Object.Instantiate(prefab)
                goNow.name = strKey
                goNow.transform:SetParent(m_scrollView.transform, false)
            end
            goNow.gameObject:SetActive(true)

            pkgUITool.SetStringByName(goNow, "Count", tbGoodsInfo.count)
            local imgGoods = goNow.transform:Find("Image")
            if imgGoods then
                pkgUITool.ResetImage(tbGoodsInfo.assets, tostring(tbGoodsInfo.id), imgGoods)
            end
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "GoodsIcon", onLoadCompelte)
    
end

function destroyUI()
    
end

function close()
    
end