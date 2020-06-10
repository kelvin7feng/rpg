doNameSpace("pkgUIShop")

assetbundleTag = "ui"
prefabFile = "ShopUI"

event_listener = {
    {pkgClientEventDefination.ON_UPDATE_SHOP_INFO, "show"},
    {pkgClientEventDefination.ON_BUY_GOODS, "updateGoodsInfo"},
    {pkgClientEventDefination.ON_BUY_GOODS, "updateValPanel"},
}

m_scrollView = m_scrollView or nil
m_dShopType = pkgShopCfgMgr.ShopType.NORMAL
m_txtDiamond = m_txtDiamond or nil
m_txtRemainingTime = m_txtRemainingTime or nil
m_dUpdateTimerId = m_dUpdateTimerId or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
    m_txtDiamond = gameObject.transform:Find("Panel/ValuePanel/Diamond/Bg/Text")
    m_txtGold = gameObject.transform:Find("Panel/ValuePanel/Gold/Bg/Text")
    m_txtRemainingTime = gameObject.transform:Find("Panel/ValuePanel/Remaing/TxtRemaingTime")
end

function updateGoodsInfo(dShopType, dId, tbGoodsInfo)
    -- 商店已切换类型，不需要更新
    if dShopType ~= m_dShopType then
        return
    end
    
    local strIconName = "item" .. dId
    local objIcon = m_scrollView.transform:Find(strIconName)
    if not tbGoodsInfo.remaining or tbGoodsInfo.remaining <= 0 then
        pkgUITool.SetActiveByName(objIcon, "SoldOut", true)
        pkgUITool.SetActiveByName(objIcon, "Info", false)
        pkgButtonMgr.RemoveGameObjectListeners(objIcon)
    else
        pkgUITool.SetActiveByName(objIcon, "SoldOut", false)
        pkgUITool.SetActiveByName(objIcon, "Info", true)
    end
end

function updateValPanel()
    local txtDiamondComponent = m_txtDiamond.gameObject:GetComponent(UnityEngine.UI.Text)
    txtDiamondComponent.text = pkgUserDataManager.GetDiamond()
    
    local txtGoldComponent = m_txtGold.gameObject:GetComponent(UnityEngine.UI.Text)
    txtGoldComponent.text = pkgUserDataManager.GetGold()
end

function updateRemainingTime(dLastUpdateTime)
    local function onUpdateTime()
        local dRemainingTime = pkgTimeMgr.GetTomorrowStartTime(dLastUpdateTime) - os.time()
        if dRemainingTime < 0 then
            return
        end
        pkgUITool.SetGameObjectString(m_txtRemainingTime, pkgTimeMgr.FormatTimestamp(dRemainingTime))
    end

    deleteTimer()
    m_dUpdateTimerId = pkgTimerMgr.addWithoutDelay(1000, onUpdateTime)
end

function show()

    local tbShopInfo = pkgShopDataMgr.GetShopInfo(m_dShopType)

    local function onClickIcon(objIcon, tbParams)
        local function confirm()
            pkgShopMgr.BuyGoods(m_dShopType, tbParams.id)
            pkgUIBaseViewMgr.destroyUI(pkgUIAlert)
        end
        local tbItem = tbParams.tbItem
        if not tbItem.remaining or tbItem.remaining <= 0 then
            return
        end
        local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(tbItem.currency)
        local tbTargetInfo = pkgGoodsCfgMgr.GetGoodsCfg(tbItem.id)
        local tbParam = {
            strContent  = pkgLanguageMgr.GetStringById(2003, tbItem.price, tbGoodsInfo.name,  tbTargetInfo.name),
            bConfirm    = true,                    
            strConfirm  = "确定",                     
            funcConfirm = confirm,
        }
        pkgUIBaseViewMgr.showByViewPath("game/alert/pkgUIAlert", nil, tbParam)
    end

    for i, tbGoodsInfo in ipairs(tbShopInfo.tbGoodsList) do
        local strIconName = "item" .. i
        local goNow = m_scrollView.transform:Find(strIconName)
        if pkgUITool.isNull(goNow) then
            pkgUITool.CreateIcon(tbGoodsInfo.id, m_scrollView, nil, {onClick = onClickIcon, iconName = strIconName, iconType = pkgUITool.IconType.SHOP_ITEM, tbItem = tbGoodsInfo, id = i})
        else
            pkgUITool.UpdateIcon(goNow, tbGoodsInfo.id, nil, {onClick = onClickIcon, iconName = strIconName, iconType = pkgUITool.IconType.SHOP_ITEM, tbItem = tbGoodsInfo, id = i})
        end
    end

    updateRemainingTime(tbShopInfo.dLastUpdateTime)
    updateValPanel()
end

function deleteTimer()
    if m_dUpdateTimerId then
        pkgTimerMgr.delete(m_dUpdateTimerId)
        m_dUpdateTimerId = nil
    end
end

function destroyUI()
    deleteTimer()
    pkgUIBaseViewMgr.destroyUI(pkgUIShop)
end

function close()
    
end