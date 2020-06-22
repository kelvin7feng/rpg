doNameSpace("pkgUITool")

ICON_SIZE_TYPE = {
    BIG             =   1,    
    SMALL           =   2,
    MINI            =   3,
}

local Text = UnityEngine.UI.Text

function isNull(gameObject)
    if not gameObject or Slua.IsNull(gameObject) then
        return true
    end
end

function SetStringByName(gameObject, name, strText)
    if isNull(gameObject) then
        LOG_WARN("setStringByName gameObject is null, name is "..name)
        return
    end
    local go = gameObject.transform:Find(name)
    if isNull(go) then
        LOG_WARN(name .. " is null")
        return
    end
    go.gameObject:SetActive(true)
    local textCom = go:GetComponent(Text)
    if not textCom then return end
    textCom.text = strText
end

function SetGameObjectString(go, strText)
    if isNull(go) then
        LOG_WARN("setStringByName gameObject is null, name is "..name)
        return
    end

    go.gameObject:SetActive(true)
    local textCom = go:GetComponent(Text)
    if not textCom then return end
    textCom.text = strText
end

function SetActiveByName(gameObject, strName, bActive)
    if isNull(gameObject) then
        LOG_WARN("setActiveByName gameObject is null")
        return
    end
    local go = gameObject.transform:Find(strName)
    if isNull(go) then
        LOG_WARN("setActiveByName "..strName.." is null")
        return
    end
    go.gameObject:SetActive(bActive)
end

function GetCenterPoint()
    return UnityEngine.Vector3(UnityEngine.Screen.width/2,UnityEngine.Screen.height/2,0)
end

function AutoScaleUI(gameObject)
    local sizeDelta = UnityEngine.Vector2(pkgGlobalConfig.ReferenceResolutionWidth,pkgGlobalConfig.ReferenceResolutionHeight * GetResolutionScaleY())
    local rectTransform = gameObject:GetComponent(UnityEngine.RectTransform)
    rectTransform.sizeDelta = sizeDelta
    rectTransform.position = GetCenterPoint()
end

function AutoScaleUIWidth(gameObject)
    local rectTransform = gameObject:GetComponent(UnityEngine.RectTransform)
    local sizeDelta = UnityEngine.Vector2(pkgGlobalConfig.ReferenceResolutionWidth,rectTransform.rect.height)
    rectTransform.sizeDelta = sizeDelta
end

function SetActive(gameObject, bIsVisibel)
    if gameObject and IsBoolean(bIsVisibel) then
        gameObject.gameObject:SetActive(bIsVisibel)
    end
end

function GetResolutionScaleY()
    local dLocalScaleY = 1
    local dScreeenWidth = UnityEngine.Screen.width
    local dScreeenHeight = UnityEngine.Screen.height
    local dReferenceRatio = pkgGlobalConfig.ReferenceResolutionHeight / pkgGlobalConfig.ReferenceResolutionWidth
    local dRealRatio = dScreeenHeight / dScreeenWidth
    if dRealRatio > dReferenceRatio then
        dLocalScaleY = dRealRatio/dReferenceRatio
    end
    return dLocalScaleY
end

function UpdateText(gameObject, strChildName, dLanguageStringId, ...)

    if not gameObject then
        print("UpdateText gameobject is nil")
        return
    end
    
    if not strChildName then
        print("UpdateText strChildName is nil")
        return
    end

    local childGo = gameObject.transform:Find(strChildName)
    if not childGo then
        return
    end

    local txtComponent = childGo.gameObject:GetComponent(UnityEngine.UI.Text)
    if not txtComponent then
        print("can't find UI.Text Component")
        return
    end

    txtComponent.text = pkgLanguageMgr.GetStringById(dLanguageStringId, ...)
end

function UpdateGameObjectText(gameObject, dLanguageStringId, ...)

    if not gameObject then
        print("UpdateText gameobject is nil")
        return
    end

    local txtComponent = gameObject.gameObject:GetComponent(UnityEngine.UI.Text)
    if not txtComponent then
        print("can't find UI.Text Component")
        return
    end

    txtComponent.text = pkgLanguageMgr.GetStringById(dLanguageStringId, ...)
end

m_resetImageGo2Func = {}

function ResetImage(assetBundleName, imageName, gameObject, callback, tbParams)
    if not gameObject then
        return
    end
    tbParams = tbParams or  {}

	local function onLoadComplete( prefab )
        if m_resetImageGo2Func[gameObject:GetInstanceID()] ~= tostring(onComplete) then
            return
        end
        
        m_resetImageGo2Func[gameObject:GetInstanceID()] = nil
        if not prefab then return end
        if Slua.IsNull(gameObject) then
            return
        end

        local sprite = nil
        if prefab:GetType().Name == "Texture2D" then
            local rect = UnityEngine.Rect(0, 0, prefab.width, prefab.height)
            local border = tbParams.border or UnityEngine.Vector4.zero
            sprite = UnityEngine.Sprite.Create(prefab, rect, UnityEngine.Vector2(0.5, 0.5), 100, 0, UnityEngine.SpriteMeshType.Tight, border)
        else
            sprite = UnityEngine.Object.Instantiate(prefab)
        end
        
        local image = gameObject:GetComponent(UnityEngine.UI.Image)
        if not image then
            image = gameObject:AddComponent(UnityEngine.UI.Image)
        end
        
        image.sprite = sprite
        if tbParams.bSetNative then
            image:SetNativeSize()
        end
        gameObject.gameObject:SetActive(true)
        if callback then
            callback(gameObject)
        end
    end

    m_resetImageGo2Func[gameObject:GetInstanceID()] = tostring(onComplete)
    pkgAssetBundleMgr.LoadAssetBundle(assetBundleName, imageName, onLoadComplete)
end

IconType = {
    NORMAL_GOODS        = 1,
    SHOP_ITEM           = 2,
    CHARACTER_ICON      = 3,
}

-- to do:show goods info
local function onDefaultClick(go, tbParams)

    tbParams.bIsBag = true

    local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(tbParams.id)
    if tbGoodsInfo and tbParams.strEquipId then
        pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUIEquipDetail", nil, tbParams)
    else
        pkgUIBaseViewMgr.showByViewPath("game/goods/pkgUIGoodsDetail", nil, tbParams)
    end
end

local function onLoadShopItemComplete(prefab, tbParams)

    if not prefab then 
        return 
    end

    local objIcon = UnityEngine.Object.Instantiate(prefab)
    objIcon.name = tbParams.iconName or "icon"
    objIcon.gameObject:SetActive(true)

    local parent = tbParams.parent
    if parent then
        objIcon.transform:SetParent(parent.transform, false)
    end
    
    local tbGoodsCfg = pkgGoodsCfgMgr.GetGoodsCfg(tbParams.id)
    local imgGoods = objIcon.transform:Find("Image")
    if imgGoods then
        pkgUITool.ResetImage(tbGoodsCfg.assetBundle, tostring(tbGoodsCfg.assetName), imgGoods)
        pkgUITool.SetActive(imgGoods, true)
    end

    local tbItem = tbParams.tbItem
    if tbItem.count and tbItem.count > 1 then
        pkgUITool.SetActiveByName(objIcon, "Count", true)
        pkgUITool.SetStringByName(objIcon, "Count", tbItem.count)
    else
        pkgUITool.SetActiveByName(objIcon, "Count", false)
    end

    if not tbItem.remaining or tbItem.remaining <= 0 then
        pkgUITool.SetActiveByName(objIcon, "SoldOut", true)
        pkgUITool.SetActiveByName(objIcon, "Info", false)
    else
        pkgUITool.SetActiveByName(objIcon, "SoldOut", false)
        pkgUITool.SetActiveByName(objIcon, "Info", true)
    end

    local imgCurrency = objIcon.transform:Find("Info/ImgCurrency")
    pkgUITool.ResetImage("goods", tbItem.currency, imgCurrency)
    pkgUITool.SetStringByName(objIcon, "Info/TxtPrice", tbItem.price)

    local callback = tbParams.callback
    if callback then
        callback(objIcon)
    end

    if tbParams.onClick then
        pkgButtonMgr.AddBtnListener(objIcon, tbParams.onClick, tbParams)
    else
        pkgButtonMgr.AddBtnListener(objIcon, onDefaultClick, tbParams)
    end
end

function fillGoodsIcon(objIcon, tbParams)
    local tbGoodsCfg = pkgGoodsCfgMgr.GetGoodsCfg(tbParams.id)
    local imgGoods = objIcon.transform:Find("Image")
    if imgGoods then
        pkgUITool.ResetImage(tbGoodsCfg.assetBundle, tostring(tbGoodsCfg.assetName), imgGoods)
    end

    if tbParams.count then
        pkgUITool.SetActiveByName(objIcon, "Count", true)
        pkgUITool.SetStringByName(objIcon, "Count", tbParams.count)
    else
        pkgUITool.SetActiveByName(objIcon, "Count", false)
    end

    if tbParams.level then
        pkgUITool.SetActiveByName(objIcon, "Level", true)
        pkgUITool.SetStringByName(objIcon, "Level", tbParams.level)
    else
        pkgUITool.SetActiveByName(objIcon, "Level", false)
    end

    if tbParams.onClick then
        pkgButtonMgr.AddBtnListener(objIcon, tbParams.onClick, tbParams)
    else
        pkgButtonMgr.AddBtnListener(objIcon, onDefaultClick, tbParams)
    end
end

local function onLoadNormalComplete(prefab, tbParams)

    if not prefab then 
        return 
    end

    local parent = tbParams.parent
    
    local objIcon = UnityEngine.Object.Instantiate(prefab)
    objIcon.name = tbParams.iconName or "icon"
    objIcon.gameObject:SetActive(true)

    if parent then
        objIcon.transform:SetParent(parent.transform, false)
    end

    local tbGoodsCfg = pkgGoodsCfgMgr.GetGoodsCfg(tbParams.id)
    local imgGoods = objIcon.transform:Find("Image")
    if imgGoods then
        pkgUITool.ResetImage(tbGoodsCfg.assetBundle, tostring(tbGoodsCfg.assetName), imgGoods)
    end

    if tbParams.count then
        pkgUITool.SetActiveByName(objIcon, "Count", true)
        pkgUITool.SetStringByName(objIcon, "Count", tbParams.count)
    else
        pkgUITool.SetActiveByName(objIcon, "Count", false)
    end

    if tbParams.level then
        pkgUITool.SetActiveByName(objIcon, "Level", true)
        pkgUITool.SetStringByName(objIcon, "Level", tbParams.level)
    else
        pkgUITool.SetActiveByName(objIcon, "Level", false)
    end

    UpdateIconSize(objIcon, tbParams)

    local callback = tbParams.callback
    if callback then
        callback(objIcon)
    end

    if tbParams.onClick then
        pkgButtonMgr.AddBtnListener(objIcon, tbParams.onClick, tbParams)
    else
        pkgButtonMgr.AddBtnListener(objIcon, onDefaultClick, tbParams)
    end
end

local function onLoadCharacterComplete(prefab, tbParams)

    if not prefab then 
        return 
    end

    local parent = tbParams.parent
    
    local objIcon = UnityEngine.Object.Instantiate(prefab)
    objIcon.name = tbParams.iconName or "icon"
    objIcon.gameObject:SetActive(true)

    if parent then
        objIcon.transform:SetParent(parent.transform, false)
    end

    local tbCharaterCfg = pkgMonsterCfgMgr.GetMonsterCfg(tbParams.id)
    local imgIcon = objIcon.transform:Find("Image")
    if imgIcon then
        pkgUITool.ResetImage(tbCharaterCfg.assetBundle, tostring(tbCharaterCfg.assetName), imgIcon)
    end

    UpdateIconSize(objIcon, tbParams)

    local callback = tbParams.callback
    if callback then
        callback(objIcon)
    end

    if tbParams.onClick then
        pkgButtonMgr.AddBtnListener(objIcon, tbParams.onClick, tbParams)
    else
        pkgButtonMgr.AddBtnListener(objIcon, onDefaultClick, tbParams)
    end
end

function CreateIcon(dGoodsId, parent, callback, tbParams)
    
    if not dGoodsId then
        return
    end
    
    tbParams = tbParams or {}
    tbParams.id = dGoodsId
    tbParams.parent = parent
    tbParams.callback = callback

    local dIconType = tbParams.iconType or IconType.NORMAL_GOODS
    pkgAssetBundleMgr.LoadAssetBundle(IconMap[dIconType].assetBundle, IconMap[dIconType].assetName, IconMap[dIconType].callback, tbParams)

end

function UpdateIcon(objIcon, dGoodsId, callback, tbParams)
    
    if not objIcon then
        return
    end
    
    if not dGoodsId then
        return
    end
    
    local tbCfg = nil
    local dIconType = tbParams.iconType or IconType.NORMAL_GOODS
    if dIconType == IconType.CHARACTER_ICON then
        tbCfg = pkgMonsterCfgMgr.GetMonsterCfg(dGoodsId)
    else
        tbCfg = pkgGoodsCfgMgr.GetGoodsCfg(dGoodsId)
    end
    
    if not tbCfg then
        return
    end
    
    tbParams = tbParams or  {}

    objIcon.gameObject:SetActive(true)

    local imgGoods = objIcon.transform:Find("Image")
    if imgGoods then
        pkgUITool.ResetImage(tbCfg.assetBundle, tostring(tbCfg.assetName), imgGoods)
        pkgUITool.SetActive(imgGoods, true)
    end

    if dIconType == IconType.NORMAL_GOODS then
        if tbParams.count then
            pkgUITool.SetActiveByName(objIcon, "Count", true)
            pkgUITool.SetStringByName(objIcon, "Count", tbParams.count)
        else
            pkgUITool.SetActiveByName(objIcon, "Count", false)
        end

        if tbParams.level then
            pkgUITool.SetActiveByName(objIcon, "Level", true)
            pkgUITool.SetStringByName(objIcon, "Level", tbParams.level)
        else
            pkgUITool.SetActiveByName(objIcon, "Level", false)
        end
    elseif dIconType == IconType.SHOP_ITEM then
        local tbItem = tbParams.tbItem
        if tbItem.count and tbItem.count > 1 then
            pkgUITool.SetActiveByName(objIcon, "Count", true)
            pkgUITool.SetStringByName(objIcon, "Count", tbItem.count)
        else
            pkgUITool.SetActiveByName(objIcon, "Count", false)
        end

        if not tbItem.remaining or tbItem.remaining <= 0 then
            pkgUITool.SetActiveByName(objIcon, "SoldOut", true)
            pkgUITool.SetActiveByName(objIcon, "Info", false)
        else
            pkgUITool.SetActiveByName(objIcon, "SoldOut", false)
            pkgUITool.SetActiveByName(objIcon, "Info", true)
        end

        local imgCurrency = objIcon.transform:Find("Info/ImgCurrency")
        pkgUITool.ResetImage("goods", tbItem.currency, imgCurrency)
        pkgUITool.SetStringByName(objIcon, "Info/TxtPrice", tbItem.price)
    end

    if callback then
        callback(objIcon, tbParams)
    end

    pkgButtonMgr.RemoveGameObjectListeners(objIcon)

    if tbParams.onClick then
        pkgButtonMgr.AddBtnListener(objIcon, tbParams.onClick, tbParams)
    else
        pkgButtonMgr.AddBtnListener(objIcon, onDefaultClick, tbParams)
    end

end

function UpdateIconSize(objIcon, tbParams)
    objIcon.transform.anchorMin = UnityEngine.Vector2(0.5,0.5)
    objIcon.transform.anchorMax = UnityEngine.Vector2(0.5,0.5)
    objIcon.transform.localPosition = UnityEngine.Vector3(0,0,0)
    local rect = objIcon.gameObject:GetComponent(UnityEngine.RectTransform)
    if tbParams.size then
        if tbParams.size == ICON_SIZE_TYPE.BIG then
            objIcon.transform.sizeDelta = UnityEngine.Vector2(rect.rect.width * 1.1 ,rect.rect.height * 1.1)
        elseif tbParams.size == ICON_SIZE_TYPE.SMALL then
            objIcon.transform.sizeDelta = UnityEngine.Vector2(rect.rect.width * 0.6 ,rect.rect.height * 0.6)
        elseif tbParams.size == ICON_SIZE_TYPE.MINI then 
            objIcon.transform.sizeDelta = UnityEngine.Vector2(rect.rect.width * 0.4 ,rect.rect.height * 0.4)
        end 
    end
end

--copy gameObject
function CopyGameObject(oldGameObject)
    local newGameObject = UnityEngine.Object.Instantiate(oldGameObject)
    newGameObject.transform:SetParent(oldGameObject.transform.parent)
    newGameObject.transform.rotation = oldGameObject.transform.rotation
    newGameObject.transform.position = oldGameObject.transform.position
    newGameObject.transform.name= oldGameObject.transform.name
    newGameObject.transform.localScale= oldGameObject.transform.localScale
    return newGameObject
end

function ChangeLayersRecursively(parent, name)
    local trans = parent:GetComponentsInChildren(UnityEngine.Transform)
    local dLayer = UnityEngine.LayerMask.NameToLayer(name)
    for child in Slua.iter(trans) do
        child.gameObject.layer = dLayer
    end
end

function RemoveChild(gameObject, strChildName)
    if isNull(gameObject) then
        print(strChildName.."is null")
        return
    end
    local child = gameObject.transform:Find(strChildName)
    if isNull(child) then return end
	UnityEngine.GameObject.Destroy(child.gameObject)
end

function CreateImg(assetBundleName, imageName, gameObject, callback, tbParams)
    
    gameObject = gameObject or UnityEngine.GameObject()
    local tbParams = tbParams or {}

    local function onLoadComplete(prefab)
        
        if not prefab then return end

        if isNull(gameObject) then
            return
        end

        local sprite = nil
        if prefab:GetType().Name == "Texture2D" then
            local rect = UnityEngine.Rect(0, 0, prefab.width, prefab.height)
            sprite = UnityEngine.Sprite.Create(prefab, rect, UnityEngine.Vector2(0.5, 0.5))
        else
            sprite = UnityEngine.Object.Instantiate(prefab)
        end

        local newImage = gameObject:GetComponent(UnityEngine.UI.Image)
        if not newImage then
            newImage = gameObject:AddComponent(UnityEngine.UI.Image)
        end
        if not newImage then
            print_w("newImage is null")
            return
        end
        newImage.sprite = sprite
        if tbParams.bSetNative then
            newImage:SetNativeSize()
        end

        if callback then
            callback(gameObject, tbParams)
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle(assetBundleName, imageName, onLoadComplete)
end

IconMap = {
    [IconType.NORMAL_GOODS] = {assetBundle = "ui", assetName = "GoodsIcon", callback = onLoadNormalComplete},
    [IconType.SHOP_ITEM] = {assetBundle = "ui", assetName = "ShopItem", callback = onLoadShopItemComplete},
    [IconType.CHARACTER_ICON] = {assetBundle = "ui", assetName = "CharacterIcon", callback = onLoadCharacterComplete},
}

function DelCullingMask(dOldCullingMask, cullingMask)
    if type(cullingMask) == "string" then
        cullingMask = UnityEngine.LayerMask.NameToLayer(cullingMask)
    end
    if type(cullingMask) ~= "number" then
        return
    end
    local b = (bit.lshift(1, cullingMask))
    local bb = bit.band(dOldCullingMask, b)
    if bb ~= 0 then
        return dOldCullingMask - b
    else --已经排除了
        return dOldCullingMask
    end
end