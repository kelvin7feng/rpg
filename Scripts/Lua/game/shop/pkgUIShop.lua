doNameSpace("pkgUIShop")

assetbundleTag = "ui"
prefabFile = "ShopUI"

event_listener = {
    {pkgClientEventDefination.ON_UPDATE_SHOP_INFO, "show"},
    {pkgClientEventDefination.ON_BUY_GOODS, "updateGoodsInfo"},
}

m_scrollView = m_scrollView or nil
m_dShopType = pkgShopCfgMgr.ShopType.NORMAL

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
end

function updateShopInfo(dShopType, tbShopInfo)
    print("updateShopInfo =================== ", dShopType)
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
    else
        pkgUITool.SetActiveByName(objIcon, "SoldOut", false)
        pkgUITool.SetActiveByName(objIcon, "Info", true)
    end
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
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIShop)
end

function close()
    
end