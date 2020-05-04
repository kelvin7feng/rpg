doNameSpace("pkgUIHouse")

assetbundleTag = "ui"
prefabFile = "HouseUI"

event_listener = {
    
}

m_txtName = m_txtName or nil
m_txtCurLevel = m_txtCurLevel or nil
m_panelConsume = m_panelConsume or nil

function init()
    m_txtName = gameObject.transform:Find("Panel/BasePanel/HouseName")
    m_txtCurLevel = gameObject.transform:Find("Panel/LevelUpPanel/TxtLevel")
    m_panelConsume = gameObject.transform:Find("Panel/LevelUpPanel/ConsumePanel")
end

function resetScrollViewItem()
    for i=0, m_panelConsume.transform.childCount - 1 do
        local goChild = m_panelConsume.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function show()

    resetScrollViewItem()

    --[[local tbReward = pkgAchievementCfgMgr.getRewardCfg(tbCfg.id)
            
    for i, tbGoods in ipairs(tbReward) do
        local dGoodsId, dCfgCount = unpack(tbGoods)
        if dGoodsId > 0 and dCfgCount > 0 then
            local strIconName = "goods".. i
            local goIcon = panelReward.transform:Find(strIconName)
            local tbArgs = {iconName = strIconName, count = dCfgCount, size = pkgUITool.ICON_SIZE_TYPE.MINI}
            if pkgUITool.isNull(goIcon) then
                pkgUITool.CreateIcon(dGoodsId, panelReward, nil, tbArgs)
            else
                pkgUITool.UpdateIcon(goIcon, dGoodsId, nil, tbArgs)
            end
        end
    end--]]
    
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIHouse)
end

function close()
    
end