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

    for i, tbGoodsInfo in ipairs(tbBagInfo) do
        local dGoodsId = tonumber(tbGoodsInfo.id)
        local dCfgCount = tonumber(tbGoodsInfo.count)
        if dGoodsId > 0 and dCfgCount > 0 then
            local strIconName = "goods".. i
            local goIcon = m_scrollView.transform.transform:Find(strIconName)
            local tbArgs = {iconName = strIconName, count = dCfgCount, tbGoodsInfo = tbGoodsInfo, bIsBag = true}
            if pkgUITool.isNull(goIcon) then
                pkgUITool.CreateIcon(dGoodsId, m_scrollView.transform, nil, tbArgs)
            else
                pkgUITool.UpdateIcon(goIcon, dGoodsId, nil, tbArgs)
            end
        end
    end
    
end

function destroyUI()
    
end

function close()
    
end