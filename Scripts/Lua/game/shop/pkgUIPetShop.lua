doNameSpace("pkgUIPetShop")

assetbundleTag = "ui"
prefabFile = "PetShopUI"

event_listener = {
    {pkgClientEventDefination.ON_BUY_PET, "onBuyPet"}
}

m_dShopType = pkgShopCfgMgr.ShopType.PET
m_dGoodsIndex = m_dGoodsIndex or 1

m_txtPetName = m_txtPetName or nil
m_txtPetDesc = m_txtPetDesc or nil
m_panelConsume = m_panelConsume or nil
m_txtRemainingTime = m_txtRemainingTime or nil
m_dUpdateTimerId = m_dUpdateTimerId or nil
m_panelPetModel = m_panelPetModel or nil
m_tbPetModel = m_tbPetModel or nil
m_tbPetShopInfo = m_tbPetShopInfo or nil
m_txtOriginPrice = m_txtOriginPrice or nil
m_imgOriginCurrency = m_imgOriginCurrency or nil
m_txtPrice = m_txtPrice or nil
m_imgCurrency = m_imgCurrency or nil
m_tbPetShopInfo = m_tbPetShopInfo or nil
m_tbPetShopInfo = m_tbPetShopInfo or nil

function init()
    m_txtRemainingTime = gameObject.transform:Find("Panel/BasePanel/TxtCountDown")
    m_btnBuy = gameObject.transform:Find("Panel/BuyPanel/BtnBuy")
    m_txtPetName = gameObject.transform:Find("Panel/BuyPanel/TxtPetName")
    m_txtPetDesc = gameObject.transform:Find("Panel/BuyPanel/TxtPetDesc")
    m_imgCurrency = gameObject.transform:Find("Panel/BuyPanel/BtnBuy/ImgCurrency")
    m_txtPrice = gameObject.transform:Find("Panel/BuyPanel/BtnBuy/TxtPrice")
    m_imgOriginCurrency = gameObject.transform:Find("Panel/BuyPanel/ImgCurrency")
    m_txtOriginPrice = gameObject.transform:Find("Panel/BuyPanel/TxtOriginPrice")
    m_panelPetModel = gameObject.transform:Find("Panel/PetModel")

    local function onClickBuy(btnGo)
        local function confirm()
            pkgUIBaseViewMgr.destroyUI(pkgUIAlert)
            pkgShopMgr.BuyPet(m_dShopType, m_dGoodsIndex)
        end
        local tbParam = {
            strContent  = "确定要购买吗？",                  -- 显示文字
            bConfirm    = true,                             -- 确定按钮
            strConfirm  = "确定",                           -- 确定按钮文字
            funcConfirm = confirm,                          -- 确定
        }
        pkgUIBaseViewMgr.showByViewPath("game/alert/pkgUIAlert", nil, tbParam)
    end

    pkgButtonMgr.AddBtnListener(m_btnBuy, onClickBuy)

    m_tbPetShopInfo = pkgShopDataMgr.GetShopInfo(m_dShopType)
end

function onBuyPet(strId)
    print("onBuyPet ==================== ", strId)
end

function updateShop()
    local tbGoodsInfo = m_tbPetShopInfo.tbGoodsList[m_dGoodsIndex]
    local dPetId = tbGoodsInfo.id
    local dPrice = tbGoodsInfo.price
    local dCurrency = tbGoodsInfo.currency
    local tbCfg = pkgPetCfgMgr.GetPetCfg(dPetId)
    local tbGoodsCfg = pkgGoodsCfgMgr.GetGoodsCfg(dCurrency)
    
    if tbCfg then
        local rtParams = {width = 1080, height = 1080}
        m_tbPetModel = pkgUI3DModel.showModelOnUI(m_panelPetModel.gameObject, nil, false, rtParams)
        pkgUI3DModel.changeCharacterModel(m_tbPetModel, tbCfg.modelBundleName, tbCfg.modelName)
    end
    
    pkgUITool.SetGameObjectString(m_txtPetName, tbCfg.name)
    pkgUITool.SetGameObjectString(m_txtPetDesc, tbCfg.name)

    pkgUITool.ResetImage(tbGoodsCfg.assetBundle, tostring(tbGoodsCfg.assetName), m_imgOriginCurrency)
    pkgUITool.ResetImage(tbGoodsCfg.assetBundle, tostring(tbGoodsCfg.assetName), m_imgCurrency)
    pkgUITool.SetGameObjectString(m_txtPrice, dPrice)
    pkgUITool.SetGameObjectString(m_txtOriginPrice, dPrice * 2)

    updateRemainingTime(m_tbPetShopInfo.dLastUpdateTime)
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

function updateBaseInfo()
    
end

function onUpgrade()
    show()
end

function show()
    updateShop()
end

function deleteTimer()
    if m_dUpdateTimerId then
        pkgTimerMgr.delete(m_dUpdateTimerId)
        m_dUpdateTimerId = nil
    end
end

function destroyUI()
    deleteTimer()
    pkgUIBaseViewMgr.destroyUI(pkgUIPetShop)
end

function close()
    
end