doNameSpace("pkgUISelectPet")

assetbundleTag = "ui"
prefabFile = "PetSelect"

event_listener = {
   {pkgClientEventDefination.ON_PET_REST, "onPetChange"},
   {pkgClientEventDefination.ON_PET_PLAY, "onPetChange"},
}

m_scrollView = m_scrollView or nil
m_panelNoPet = m_panelNoPet or nil
m_panelNoSelectedPet = m_panelNoSelectedPet or nil
m_panelPetingPanel = m_panelPetingPanel or nil
m_dCurrentSlot = m_dCurrentSlot or 0

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
    m_panelNoPet = gameObject.transform:Find("Panel/NoPet")
    m_panelNoPet.gameObject:SetActive(false)
    m_panelNoSelectedPet = gameObject.transform:Find("Panel/NoSelectedPet")
    m_panelNoSelectedPet.gameObject:SetActive(false)
    m_panelPetingPanel = gameObject.transform:Find("Panel/UsingPanel")
    m_panelPetingPanel.gameObject:SetActive(false)
end

local function onClickRest(btnGo, dSlotId)
    pkgPetLogic.PetRest(m_dCurrentSlot, dSlotId)
end

function onPetChange(dSlotId)
    show(dSlotId)
end

function updatePlayingPet(dSlotId)
    
    local strId = pkgPetDataMgr.GetPetSlot(dSlotId)
    if pkgPetLogic.IsSlotEmpty(dSlotId) then
        m_panelNoSelectedPet.gameObject:SetActive(true)
        m_panelPetingPanel.gameObject:SetActive(false)
        return
    end
    
    m_panelNoSelectedPet.gameObject:SetActive(false)
    m_panelPetingPanel.gameObject:SetActive(true)

    local function onLoadCompelte(prefab)
        local strKey = "petSelector"
        local goNow = m_panelPetingPanel.transform:Find(strKey)
        if pkgUITool.isNull(goNow) then
            goNow = UnityEngine.Object.Instantiate(prefab)
            goNow.name = strKey
            goNow.transform:SetParent(m_panelPetingPanel.transform, false)
        end
        goNow.gameObject:SetActive(true)

        local tbPetInfo = pkgPetDataMgr.GetPet(strId)
        local tbPetCfg = pkgPetCfgMgr.GetPetCfg(tbPetInfo.cfgId)
        pkgUITool.SetStringByName(goNow, "Name", tbPetCfg.name)
        local objIconParent = goNow.transform:Find("PetIcon/Icon")
        local objIcon = goNow.transform:Find("PetIcon/Icon/icon")
        if pkgUITool.isNull(objIcon) then
            pkgUITool.CreateIcon(tbPetInfo.cfgId, objIconParent, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, iconType = pkgUITool.IconType.CHARACTER_ICON})
        else
            pkgUITool.UpdateIcon(objIcon, tbPetInfo.cfgId, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, iconType = pkgUITool.IconType.CHARACTER_ICON})
        end
        
        pkgUITool.SetActiveByName(goNow, "Battle", false)
        pkgUITool.SetActiveByName(goNow, "Rest", true)

        pkgButtonMgr.RemoveListeners(goNow, "Rest")
        pkgButtonMgr.AddListener(goNow, "Rest", onClickRest, dSlotId)
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "PetSelector", onLoadCompelte)
end

local function onClickBattle(btnGo, strPetId)
    pkgPetLogic.PetBattle(m_dCurrentSlot, strPetId)
end

function resetScrollViewItem()
    for i=0, m_scrollView.transform.childCount - 1 do
        local goChild = m_scrollView.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function updateFreePet(dSlotId)
    local tbPetList = pkgPetDataMgr.GetFreePetList()

    resetScrollViewItem()
    
    if #tbPetList <= 0 then
        m_panelNoPet.gameObject:SetActive(true)
    else
        local function onLoadCompelte(prefab)
            for i, tbPetInfo in ipairs(tbPetList) do
                local strKey = "petSelector" .. i
                local goNow = m_scrollView.transform:Find(strKey)
                if pkgUITool.isNull(goNow) then
                    goNow = UnityEngine.Object.Instantiate(prefab)
                    goNow.name = strKey
                    goNow.transform:SetParent(m_scrollView.transform, false)
                end
                goNow.gameObject:SetActive(true)

                local tbPetCfg = pkgPetCfgMgr.GetPetCfg(tbPetInfo.cfgId)
                pkgUITool.SetStringByName(goNow, "Name", tbPetCfg.name)
                local objIconParent = goNow.transform:Find("PetIcon/Icon")
                local objIcon = goNow.transform:Find("PetIcon/Icon/icon")
                if pkgUITool.isNull(objIcon) then
                    pkgUITool.CreateIcon(tbPetInfo.cfgId, objIconParent, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, iconType = pkgUITool.IconType.CHARACTER_ICON})
                else
                    pkgUITool.UpdateIcon(objIcon, tbPetInfo.cfgId, nil, {size = pkgUITool.ICON_SIZE_TYPE.SMALL, iconType = pkgUITool.IconType.CHARACTER_ICON})
                end

                pkgUITool.SetActiveByName(goNow, "Battle", true)
                pkgUITool.SetActiveByName(goNow, "Rest", false)

                pkgButtonMgr.RemoveListeners(goNow, "Battle")
                pkgButtonMgr.AddListener(goNow, "Battle", onClickBattle, tbPetInfo.cfgId)
            end
        end
    
        pkgAssetBundleMgr.LoadAssetBundle("ui", "PetSelector", onLoadCompelte)
    end
end

function show(dSlotId)

    m_dCurrentSlot = dSlotId
    updatePlayingPet(dSlotId)
    updateFreePet(dSlotId)
    
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUISelectPet)
end

function close()
    m_scrollView = nil
    m_panelNoPet = nil
    m_panelNoSelectedPet = nil
    m_panelPetingPanel = nil
    m_dCurrentSlot = 0
end