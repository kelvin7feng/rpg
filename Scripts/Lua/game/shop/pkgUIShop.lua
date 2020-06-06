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

function resetScrollViewItem()
    for i=0, m_scrollView.transform.childCount - 1 do
        local goChild = goParent.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function updateShopInfo(dShopType, tbShopInfo)
    print("updateShopInfo =================== ", dShopType)
end

function updateGoodsInfo(dShopType, tbShopInfo)
    print("updateGoodsInfo =================== ", dShopType)
end

function show()
    
    resetScrollViewItem()

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
        end
    end
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIShop)
end

function close()
    
end