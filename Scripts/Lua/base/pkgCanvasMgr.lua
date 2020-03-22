doNameSpace("pkgCanvasMgr")

le_tbCanvasObj = le_tbCanvasObj or {}
le_objUICamera = le_objUICamera or nil

function Init()
    for dIndex, canvasCfg in ipairs(pkgCanvasDefination.DefaultCanvas) do
        local strCanvasName = canvasCfg.name
        local dontDestroyOnLoad = canvasCfg.dontDestroyOnLoad
        local dRenderMode = canvasCfg.renderMode
        local dUIScaleMode = canvasCfg.UIScaleMode
        local dOrder = canvasCfg.order or dIndex
        local canvasGo = UnityEngine.GameObject()
        local canvasObj = CreateCanvas(canvasGo, strCanvasName, dOrder, dontDestroyOnLoad, dRenderMode, dUIScaleMode)
        le_tbCanvasObj[strCanvasName] = canvasObj
    end
end

function CreateCanvasUI(canvasGo, strCanvasName, dOrder, dontDestroyOnLoad, dRenderMode, dUIScaleMode)
    dontDestroyOnLoad = dontDestroyOnLoad or false
    dRenderMode = dRenderMode or UnityEngine.RenderMode.ScreenSpaceOverlay
    dUIScaleMode = dUIScaleMode or UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize

    local canvasObj = CreateCanvas(canvasGo, strCanvasName, dOrder, dontDestroyOnLoad, dRenderMode, dUIScaleMode)
    le_tbCanvasObj[strCanvasName] = canvasObj

    return canvasObj
end

function CreateCanvas(canvasGo, strCanvasName, dOrder, dontDestroyOnLoad, dRenderMode, dUIScaleMode)

    if GetCanvasObject(strCanvasName) then
        return le_tbCanvasObj[strCanvasName]
    end

    if not canvasGo then
        canvasGo = UnityEngine.GameObject()
    end

    canvasGo.name = strCanvasName
    -- canvasGo.layer = XS.Layers.UI

    if dontDestroyOnLoad then
        UnityEngine.GameObject.DontDestroyOnLoad(canvasGo)
    end

    local canvasComponent = canvasGo:GetComponent(UnityEngine.Canvas)
    if not canvasComponent then
        canvasComponent = canvasGo:AddComponent(UnityEngine.Canvas)
    end

    canvasComponent.renderMode = dRenderMode or UnityEngine.RenderMode.ScreenSpaceOverlay
    
    if dRenderMode == UnityEngine.RenderMode.ScreenSpaceCamera then
        if not le_objUICamera then
            le_objUICamera = UnityEngine.GameObject()
            le_objUICamera.name = "UICamera"
            -- le_objUICamera.tag = pkgGlobalDefine.UE_TAG.UICAMERA
            UnityEngine.GameObject.DontDestroyOnLoad(le_objUICamera)
            local cameraComponent = le_objUICamera:AddComponent(UnityEngine.Camera)
            cameraComponent.clearFlags = UnityEngine.CameraClearFlags.Depth
            -- cameraComponent.cullingMask = XS.Layers.Mask_FOR_UI
            cameraComponent.orthographic = true
            cameraComponent.farClipPlane = 110
            cameraComponent.nearClipPlane = 90
        end
        canvasComponent.worldCamera = le_objUICamera:GetComponent(UnityEngine.Camera)
    end

    if dOrder then
        canvasComponent.overrideSorting = true
        canvasComponent.sortingOrder = dOrder
    end

    local canvasScalerComponent = canvasGo:GetComponent(UnityEngine.UI.CanvasScaler)
    if not canvasScalerComponent then
        canvasScalerComponent = canvasGo:AddComponent(UnityEngine.UI.CanvasScaler)
        if dUIScaleMode then
            canvasScalerComponent.uiScaleMode = dUIScaleMode
            if dUIScaleMode == UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize then
                canvasScalerComponent.referenceResolution = UnityEngine.Vector2(pkgCanvasDefination.ReferenceResolutionWidth, pkgCanvasDefination.ReferenceResolutionHeight)
            end
        end
    end

    local graphicRaycasterComponent = canvasGo:GetComponent(UnityEngine.UI.GraphicRaycaster)
    if not graphicRaycasterComponent then
        graphicRaycasterComponent = canvasGo:AddComponent(UnityEngine.UI.GraphicRaycaster)
    end

    return {gameObject = canvasGo, canvas = canvasComponent, canvasScaler = canvasScalerComponent, 
            graphicRaycaster = graphicRaycasterComponent, dontDestroyOnLoad = dontDestroyOnLoad}
end

function DestoryOnLoad()
    for strCanvasName, canvasInfo in pairs(le_tbCanvasObj) do
        if not canvasInfo.dontDestroyOnLoad then
            UnityEngine.Object.Destroy(canvasInfo.gameObject)
            le_tbCanvasObj[strCanvasName] = nil
        end
    end
end

function AddToCanvas(strCanvasName, childGO)
    if not strCanvasName then
        print_e("AddToCanvas strCanvasName is nil")
        return
    end

    if not childGO then
        print_e("AddToCanvas childGO is nil")
        return
    end

    if not childGO.transform then
        print_e("AddToCanvas childGO.transform is nil")
        return
    end

    local canvasComponent = GetCanvasComponent(strCanvasName)
    if not canvasComponent then
        print_e("please add the canvas to pkgCanvasDefination.Canvas:", strCanvasName)
        return
    end

    childGO.transform:SetParent(canvasComponent.transform)
end

function GetCanvasOrder(strCanvasName)
    local dOrder = 0
    local tbCanvasCfg = GetCanvasCfg(strCanvasName)
    if tbCanvasCfg then
        dOrder = tbCanvasCfg.order
    end
    return dOrder
end

function GetCanvasCfg(strCanvasName)
    local tbCfg = nil
    for dIndex, canvasCfg in ipairs(pkgCanvasDefination.DefaultCanvas) do
        if strCanvasName == canvasCfg.name then
            tbCfg = canvasCfg
        end
    end

    return tbCfg
end

function GetCanvasObject(strCanvasName)
    local gameObject = nil
    if le_tbCanvasObj[strCanvasName] then
        gameObject = le_tbCanvasObj[strCanvasName].gameObject
    end
    return gameObject
end

function GetCanvasComponent(strCanvasName)
    local component = nil
    if le_tbCanvasObj[strCanvasName] then
        component = le_tbCanvasObj[strCanvasName].canvas
    end
    return component
end

function GetScalerComponent(strCanvasName)
    local component = nil
    if le_tbCanvasObj[strCanvasName] then
        component = le_tbCanvasObj[strCanvasName].canvasScaler
    end
    return component
end