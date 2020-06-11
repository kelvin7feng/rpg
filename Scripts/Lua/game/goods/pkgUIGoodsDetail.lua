doNameSpace("pkgUIGoodsDetail")

assetbundleTag = "ui"
prefabFile = "GoodsDetail"

event_listener = {

}

m_txtName = m_txtName or nil
m_txtCategory = m_txtCategory or nil
m_panelIcon = m_panelIcon or nil
m_txtGoodsDesc = m_txtGoodsDesc or nil
m_txtPrice = m_txtPrice or nil
m_imgCurrency = m_imgCurrency or nil
m_btnBuy = m_btnBuy or nil
m_panelEquip = m_panelEquip or nil
m_panelAttr = m_panelAttr or nil

function init()
    local goParent = gameObject.transform:Find("Panel/DetailPanel")
    m_txtName = goParent.transform:Find("TxtName")
    m_txtCategory = goParent.transform:Find("TxtCategory")
    m_panelIcon = goParent.transform:Find("Icon")
    m_txtGoodsDesc = goParent.transform:Find("TxtGoodsDesc")
    m_btnBuy = goParent.transform:Find("BtnPanel/BtnBuy")
    m_txtPrice = goParent.transform:Find("BtnPanel/BtnBuy/TxtPrice")
    m_imgCurrency = goParent.transform:Find("BtnPanel/BtnBuy/ImgCurrency")
    m_panelEquip = goParent.transform:Find("PanelVar/PanelEquip")
    m_panelAttr = goParent.transform:Find("PanelVar/PanelEquip/AttrPanel")

    pkgUITool.SetActive(m_btnBuy, false)
end

function resetAttrItem()
    for i=0, m_panelAttr.transform.childCount - 1 do
        local goChild = m_panelAttr.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function show(tbParams)
    
    local dCfgId = tbParams.dCfgId
    local bIsShop = tbParams.bIsShop
    local bIsBag = tbParams.bIsBag

    local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(dCfgId)
    pkgUITool.SetGameObjectString(m_txtName, tbGoodsInfo.name)
    pkgUITool.SetGameObjectString(m_txtCategory, tbGoodsInfo.category)
    pkgUITool.SetGameObjectString(m_txtGoodsDesc, tbGoodsInfo.desc)
    
    local function onClickIcon()
        
    end

    local strIconName = "icon"
    local icon = m_panelIcon.transform:Find(strIconName)
    if pkgUITool.isNull(icon) then
        pkgUITool.CreateIcon(dCfgId, m_panelIcon, nil, {onClick = onClickIcon, size = pkgUITool.ICON_SIZE_TYPE.BIG})
    end

    if bIsShop then
        pkgUITool.SetActive(m_btnBuy, true)
        local dCurrency = tbParams.tbItem.currency
        local dPrice = tbParams.tbItem.price
        pkgUITool.ResetImage("goods", dCurrency, m_imgCurrency)
        pkgUITool.SetGameObjectString(m_txtPrice, dPrice)

        local function onClickBuy()
            tbParams.funcBuy()
            destroyUI()
        end
        pkgButtonMgr.AddBtnListener(m_btnBuy, onClickBuy)
    end

    if bIsBag then

    end

    if pkgGoodsCfgMgr.IsEquip(dCfgId) then
        resetAttrItem()
        pkgUITool.SetActive(m_panelEquip, true)

        local tbAttr = pkgEquipCfgMgr.GetAttrDescList(dCfgId)
        for i, strAttr in ipairs(tbAttr) do
            pkgUITool.SetStringByName(m_panelAttr, "TxtAttr"..i, strAttr)
            pkgUITool.SetActiveByName(m_panelAttr, "TxtAttr"..i, true)
        end
    end
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIGoodsDetail)
end

function close()
    
end