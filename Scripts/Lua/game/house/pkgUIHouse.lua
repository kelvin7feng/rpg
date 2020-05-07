doNameSpace("pkgUIHouse")

assetbundleTag = "ui"
prefabFile = "HouseUI"

event_listener = {
    {pkgClientEventDefination.ON_HOUSE_LEVEL_UP,"onLevelUp"},
    {pkgClientEventDefination.ON_HOUSE_UPGRADE,"onUpgrade"},
}

m_txtName = m_txtName or nil
m_txtCurLevel = m_txtCurLevel or nil
m_panelConsume = m_panelConsume or nil
m_btnLevelUp = m_btnLevelUp or nil
m_btnUpgrade = m_btnUpgrade or nil

function init()
    m_txtName = gameObject.transform:Find("Panel/BasePanel/HouseName")
    m_txtCurLevel = gameObject.transform:Find("Panel/LevelUpPanel/TxtLevel")
    m_panelConsume = gameObject.transform:Find("Panel/LevelUpPanel/ConsumePanel")
    m_btnLevelUp = gameObject.transform:Find("Panel/LevelUpPanel/BtnLevelUp")
    m_btnUpgrade = gameObject.transform:Find("Panel/LevelUpPanel/BtnUpgrade")

    local function onClickLevelUp(btnGo)
        pkgHouseMgr.LevelUp()
    end

    local function onClickUpgrade(btnGo)
        pkgHouseMgr.Upgrade()
    end

    pkgButtonMgr.AddBtnListener(m_btnLevelUp, onClickLevelUp)
    pkgButtonMgr.AddBtnListener(m_btnUpgrade, onClickUpgrade)
end

function resetScrollViewItem()
    for i=0, m_panelConsume.transform.childCount - 1 do
        local goChild = m_panelConsume.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function onLevelUp()
    show()
    pkgSysEffect.PlayEffect(pkgPoolDefination.PoolType.HOUSE_LEVEL_UP, m_txtCurLevel.transform)
end

function onUpgrade()
    show()
    pkgSysEffect.PlayEffect(pkgPoolDefination.PoolType.HOUSE_UPGRAD, m_txtCurLevel.transform)
end

function show()

    resetScrollViewItem()
    
    local dLevel = pkgHouseDataMgr.GetLevel()
    pkgUITool.UpdateGameObjectText(m_txtCurLevel, 20101, dLevel)

    local tbCostList = {}
    local dStar = pkgHouseDataMgr.GetStar()
    local bHaveNextLevel = pkgHomeCfgMgr.HaveNextLevel(dStar, dLevel)
    
    if bHaveNextLevel then
        pkgUITool.SetActive(m_btnLevelUp, true)
        pkgUITool.SetActive(m_btnUpgrade, false)
        tbCostList = pkgHomeCfgMgr.GetLevelUpCost(dStar, dLevel)
    else
        local bHaveNextStar = pkgHomeCfgMgr.HaveNextStar(dStar)
        if bHaveNextStar then
            pkgUITool.SetActive(m_btnLevelUp, false)
            pkgUITool.SetActive(m_btnUpgrade, true)
            tbCostList = pkgHomeCfgMgr.GetLevelUpCost(dStar + 1, 0)
        else
            pkgUITool.SetActive(m_btnLevelUp, false)
            pkgUITool.SetActive(m_btnUpgrade, false)
        end
    end

    local tbCfg = pkgHomeCfgMgr.GetLevelUpCfg(dStar, dLevel)
    pkgUITool.SetGameObjectString(m_txtName, tbCfg.name)
     
    for i, tbGoods in ipairs(tbCostList) do
        local dGoodsId, dCfgCount = unpack(tbGoods)
        if dGoodsId > 0 and dCfgCount > 0 then
            local strIconName = "goods".. i
            local goIcon = m_panelConsume.transform:Find(strIconName)
            local tbArgs = {iconName = strIconName, count = dCfgCount, size = pkgUITool.ICON_SIZE_TYPE.SMALL}
            if pkgUITool.isNull(goIcon) then
                pkgUITool.CreateIcon(dGoodsId, m_panelConsume, nil, tbArgs)
            else
                pkgUITool.UpdateIcon(goIcon, dGoodsId, nil, tbArgs)
            end
        end
    end
    
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIHouse)
end

function close()
    
end