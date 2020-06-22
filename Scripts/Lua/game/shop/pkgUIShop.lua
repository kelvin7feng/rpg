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
m_tbTableView = m_tbTableView or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View")
    m_txtDiamond = gameObject.transform:Find("Panel/ValuePanel/Diamond/Bg/Text")
    m_txtGold = gameObject.transform:Find("Panel/ValuePanel/Gold/Bg/Text")
    m_txtRemainingTime = gameObject.transform:Find("Panel/ValuePanel/Remaing/TxtRemaingTime")
end

function updateGoodsInfo(dShopType, dId, tbGoodsInfo)
    -- 商店已切换类型，不需要更新
    if dShopType ~= m_dShopType then
        return
    end
    
    local objIcon = pkgUITableViewMgr.getItem(m_tbTableView, dId)
    if objIcon then
        if not tbGoodsInfo.remaining or tbGoodsInfo.remaining <= 0 then
            pkgUITool.SetActiveByName(objIcon, "SoldOut", true)
            pkgUITool.SetActiveByName(objIcon, "Info", false)
            pkgButtonMgr.RemoveGameObjectListeners(objIcon)
        else
            pkgUITool.SetActiveByName(objIcon, "SoldOut", false)
            pkgUITool.SetActiveByName(objIcon, "Info", true)
        end
    end
end

function updateValPanel()
    local txtDiamondComponent = m_txtDiamond.gameObject:GetComponent(UnityEngine.UI.Text)
    txtDiamondComponent.text = pkgStringMgr.ConvertNumber2Short(pkgUserDataManager.GetDiamond())
    
    local txtGoldComponent = m_txtGold.gameObject:GetComponent(UnityEngine.UI.Text)
    txtGoldComponent.text = pkgStringMgr.ConvertNumber2Short(pkgUserDataManager.GetGold())
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


function getTableViewData()
    return pkgShopDataMgr.GetShopInfo(m_dShopType).tbGoodsList
end

function createTableViewCard()
    local function onComplete(prefab)
        if not prefab then return end

        local delegateSource = {
            dOffsetStart = 25,  --开头的偏移
            dOffsetCell = 10,   --每个cell的间隔
            dCellInterval = 10, --每行的间距
        }

        local dataSource = {}

        local tbData = getTableViewData()

        function dataSource.column()
            return 4
        end

        function dataSource.total()
            return #tbData
        end
        function dataSource.tbData()
            return tbData
        end

        function delegateSource.scrollView()
            return m_scrollView
        end

        function delegateSource.onItemClicked(cell, dIndexInData)
            local function confirm()
                pkgShopMgr.BuyGoods(m_dShopType, dIndexInData)
            end
            local tbItem = tbData[dIndexInData]
            if not tbItem.remaining or tbItem.remaining <= 0 then
                return
            end
            local tbParams = 
            {
                id = tbItem.id,
                tbItem = tbItem,
                bIsShop = true,
                funcBuy = confirm,
            }
            pkgUIBaseViewMgr.showByViewPath("game/goods/pkgUIGoodsDetail", nil, tbParams)
        end

        function delegateSource.setDataAtCell(cell, dIndexInData, _tbData)
            local tbGoodsInfo = _tbData[dIndexInData]
            local tbParams = {
                id = tbGoodsInfo.id,
                tbItem = tbGoodsInfo,
            }
            pkgUITool.FillShopItem(cell, tbParams)
        end

        function delegateSource.cellByPrefab()
            return prefab
        end
        
        m_tbTableView = pkgUITableViewMgr.createTableView(delegateSource, dataSource)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "ShopItem", onComplete)
end

function show()
    local tbShopInfo = pkgShopDataMgr.GetShopInfo(m_dShopType)
    updateRemainingTime(tbShopInfo.dLastUpdateTime)
    updateValPanel()
    createTableViewCard()
end

function deleteTimer()
    if m_dUpdateTimerId then
        pkgTimerMgr.delete(m_dUpdateTimerId)
        m_dUpdateTimerId = nil
    end
end

function destroyUI()
    deleteTimer()
    m_tbTableView = nil
    pkgUIBaseViewMgr.destroyUI(pkgUIShop)
end

function close()
    
end