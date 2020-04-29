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

    txtComponent.text = string.format(pkgLanguageMgr.GetStringById(dLanguageStringId),unpack({...}))
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

    txtComponent.text = string.format(pkgLanguageMgr.GetStringById(dLanguageStringId),unpack({...}))
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

function CreateIcon(dGoodsId, parent, callback, tbParams)
    
    if not dGoodsId then
        return
    end
    
    local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(dGoodsId)
    if not tbGoodsInfo then
        return
    end

    tbParams = tbParams or  {}

    -- to do:show goods info
    local function onDefaultClick(go)
        
    end

	local function onLoadComplete( prefab )

        if not prefab then return end

        local objIcon = UnityEngine.Object.Instantiate(prefab)
        objIcon.name = tbParams.iconName or "icon"
        objIcon.gameObject:SetActive(true)

        if parent then
            objIcon.transform:SetParent(parent.transform, false)
        end

        local imgGoods = objIcon.transform:Find("Image")
        if imgGoods then
            pkgUITool.ResetImage(tbGoodsInfo.assetBundle, tostring(tbGoodsInfo.id), imgGoods)
        end

        if tbParams.count then
            pkgUITool.SetActiveByName(objIcon, "Count", true)
            pkgUITool.SetStringByName(objIcon, "Count", tbParams.count)
        else
            pkgUITool.SetActiveByName(objIcon, "Count", false)
        end

        UpdateIconSize(objIcon, tbParams)

        if callback then
            callback(objIcon)
        end

        if tbParams.onClick then
            pkgButtonMgr.AddBtnListener(objIcon, tbParams.onClick)
        else
            pkgButtonMgr.AddBtnListener(objIcon, onDefaultClick)
        end
    end

    print("assetBundleName, fileName:", parent.name, tbGoodsInfo.assetBundle, tostring(dGoodsId))

    pkgAssetBundleMgr.LoadAssetBundle("ui", "GoodsIcon", onLoadComplete)
end

function UpdateIcon(objIcon, dGoodsId, callback, tbParams)
    
    if not objIcon then
        return
    end

    if not dGoodsId then
        return
    end
    
    local tbGoodsInfo = pkgGoodsCfgMgr.GetGoodsCfg(dGoodsId)
    if not tbGoodsInfo then
        return
    end

    tbParams = tbParams or  {}

    -- to do:show goods info
    local function onDefaultClick(go)
        
    end

    objIcon.gameObject:SetActive(true)

    local imgGoods = objIcon.transform:Find("Image")
    if imgGoods then
        pkgUITool.ResetImage(tbGoodsInfo.assetBundle, tostring(tbGoodsInfo.id), imgGoods)
    end

    if tbParams.count then
        pkgUITool.SetActiveByName(objIcon, "Count", true)
        pkgUITool.SetStringByName(objIcon, "Count", tbParams.count)
    else
        pkgUITool.SetActiveByName(objIcon, "Count", false)
    end

    if callback then
        callback(objIcon)
    end

    -- pkgButtonMgr.RemoveGameObjectListeners(objIcon)

    --[[if tbParams.onClick then
        pkgButtonMgr.AddBtnListener(objIcon, tbParams.onClick)
    else
        pkgButtonMgr.AddBtnListener(objIcon, onDefaultClick)
    end--]]

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