doNameSpace("pkgUIPetMainMgr")

m_panelPet = m_panelPet or nil
m_tbEquipSlot = m_tbEquipSlot or {}
m_tbPetModel = m_tbPetModel or nil
m_dShowPetId = m_dShowPetId or nil

function InitPetList()
    local tbPetList = pkgPetDataMgr.GetPetTeam()
    for i, strPetId in ipairs(tbPetList) do
        local btnSlot = m_panelPet.transform:Find("Panel/BtnPanel/BtnSlot"..i)
        m_tbEquipSlot[i] = btnSlot

        local function onClickPetSlotBtn(btnGo)
            pkgUIRedPointMgr.RemoveRedPoint("pet_slot_red_point")
            pkgUIBaseViewMgr.showByViewPath("game/pet/pkgUISelectPet", nil, i) 
        end

        local function onClickDetail(btnGo)
            m_dShowPetId = strPetId
            InitModel()
            pkgUIRedPointMgr.RemoveRedPoint("pet_slot_red_point")
            pkgUIBaseViewMgr.showByViewPath("game/pet/pkgUISelectPet", nil, i)
        end

        -- set icon
        local bIsPetAt = pkgPetLogic.IsPetAt(i)
        
        local goIcon = btnSlot.transform:Find("icon")
        if bIsPetAt then
            local dPetId = tonumber(strPetId)
            local tbPetCfg = pkgPetCfgMgr.GetPetCfg(dPetId)
            if pkgUITool.isNull(goIcon) then
                pkgUITool.CreateIcon(dPetId, btnSlot, nil, {onClick = onClickDetail, size = pkgUITool.ICON_SIZE_TYPE.SMALL, iconType = pkgUITool.IconType.CHARACTER_ICON})
            else
                pkgUITool.UpdateIcon(goIcon, dPetId, nil, {onClick = onClickDetail, size = pkgUITool.ICON_SIZE_TYPE.SMALL, iconType = pkgUITool.IconType.CHARACTER_ICON})
            end
            if not m_dShowPetId then
                m_dShowPetId = dPetId
            end
        else
            if not pkgUITool.isNull(goIcon) then
                UnityEngine.Object.Destroy(goIcon.gameObject)
            end
            pkgButtonMgr.AddBtnListener(btnSlot, onClickPetSlotBtn)
        end
        
        if pkgPetLogic.CanShowRedPoint(i) then
            local objRedPoint = btnSlot.transform:Find("redPoint")
            if pkgUITool.isNull(objRedPoint) then
                pkgUIRedPointMgr.AddRedPoint(btnSlot.gameObject, "pet_slot_red_point")
            end
        end
    end
end

function InitModel()
    local rtParams = {width = 1080, height = 1080}
    local panelPetModel = m_panelPet.transform:Find("Panel/PanelModel")
    local panelAttrPanent = m_panelPet.transform:Find("Panel/PanelAttr")
    if panelPetModel then
        if m_dShowPetId then
            m_tbPetModel = pkgUI3DModel.showModelOnUI(panelPetModel.gameObject, nil, false, rtParams)
            local tbPetCfg = pkgPetCfgMgr.GetPetCfg(m_dShowPetId)
            pkgUI3DModel.changeCharacterModel(m_tbPetModel, tbPetCfg.modelBundleName, tbPetCfg.modelName)

            local tbAttr = pkgAttrCfgMgr.GetAttrDescList(tbPetCfg.attrId)
            local panelAttr = m_panelPet.transform:Find("Panel/PanelAttr/AttrPanel")
            pkgUIAttrMgr.UpdateAttrPanel(panelAttr, tbAttr)

            pkgUITool.SetActive(panelPetModel, true)
            pkgUITool.SetActive(panelAttrPanent, true)
        else
            pkgUITool.SetActive(panelPetModel, false)
            pkgUITool.SetActive(panelAttrPanent, false)
        end
    end
end

function Init(panelPet, dShowPetId)

    if not panelPet then
        return
    end

    m_dShowPetId = strPetId
    m_panelPet = panelPet

    InitPetList()

    InitModel()
end