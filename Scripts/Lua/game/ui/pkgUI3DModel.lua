doNameSpace("pkgUI3DModel")

le_dScaleFixed = 1--108.0299

--角色模型
function changeCharacterModel(tbModelShow, assetBundleName, strPrefabName)
    if not tbModelShow then
        return
    end
    if tbModelShow.taiziGo then
        tbModelShow.taiziGo:SetActive(true)
    end

    local function initModel(modelGo)
        local animator = nil

        local root = modelGo.gameObject.transform:Find("model/root")        
        if root then
            animator = root.gameObject:GetComponent(ue.Animator)
            animator.enabled = true
            -- animator.speed = pkgBattleConst.c_battleTimeScale
            -- 当前帧强制执行动作切换
            -- animator:Update(0)
        end
        
        pkgUtilMgr.changeLayersRecursively(modelGo, "3DUI")

        return modelGo
    end

    local modelCanvas = tbModelShow.modelCanvas
    local function onComplete(prefab)
        if pkgUtilMgr.isNull(modelCanvas) then
            print_w("modelCanvas is null")
            return
        end
        local modelOld = modelCanvas.transform:Find("modelContain/model")
        local modelGo = UnityEngine.Object.Instantiate(prefab)
        pkgUtilMgr.replaceGameObject(modelOld.gameObject, modelGo)
        local modelGo = initModel(modelGo)
        tbModelShow.modelGo = modelGo.gameObject

        pkgUtilMgr.changeLayersRecursively(modelGo, "3DUI")
    end

    pkgAssetBundleMgr.LoadAssetBundle(assetBundleName, strPrefabName, onComplete)
end

local function initRenderTexture(tbModelShow, params) 
    local modelCanvas = tbModelShow.modelCanvas
    params = params or {}

    local camera = modelCanvas.transform:Find("UIModelCamera")
    local oldPos = camera.transform.localPosition 
    local cameraCpt = camera.gameObject:GetComponent(ue.Camera)
    tbModelShow.cameraCpt = cameraCpt

    if not params.bNotUseRt then
        local defaultRTSize = 1024

        --[[if pkgQualityMgr and pkgQualityMgr.getQualityLevel() >= pkgQualityMgr.le_tbQualityLevel.Medium then
            defaultRTSize = 2048
        end--]]

        local renderTexture = pkgUtilMgr.getTempRenderTexture(modelCanvas, "uimodel", 
        params.width or (defaultRTSize), params.height or (defaultRTSize), params.depthBuffer or (16), params.rtFormat)
        renderTexture.autoGenerateMips = false
        renderTexture.useMipMap = false

        camera.transform.localPosition = oldPos * le_dScaleFixed
        cameraCpt.nearClipPlane = 0.6
        cameraCpt.farClipPlane = 1000
        cameraCpt.targetTexture = renderTexture

        if params.cameraFoV then
            cameraCpt.fieldOfView = params.cameraFoV
        end

        local rawImage = tbModelShow.imgModelTrans --modelCanvas.transform:Find("imgModel")
        rawImage.gameObject:SetActive(true)
        rawImage.transform:GetComponent(ue.UI.RawImage).texture = renderTexture

        -- if not params.ignoreNativeSize then
        --     rawImage.transform:GetComponent(ue.UI.RawImage):SetNativeSize()
        -- end

        if params.setNativeSize then
            rawImage.transform:GetComponent(ue.UI.RawImage):SetNativeSize()
        end

        if params.imageSizeWidth and params.imageSizeHeight then
            local imageRectTransform = rawImage.transform:GetComponent(ue.RectTransform)
            imageRectTransform.sizeDelta = ue.Vector2(params.imageSizeWidth, params.imageSizeHeight)
        end
    else
        local rawImage = tbModelShow.imgModelTrans
        rawImage.gameObject:SetActive(false)
        cameraCpt.depth = 100
        cameraCpt.clearFlags = ue.CameraClearFlags.Depth
        if params.dCameraPosX then
            camera.transform.localPosition = ue.Vector3(params.dCameraPosX, oldPos.y, oldPos.z)
        end
    end
end

-- to do
function doShowAction(tbModelShow)
    
end

local function initTouchModel( tbModelShow )
    local modelCanvas = tbModelShow.modelCanvas

    local imgModel = tbModelShow.imgModelTrans--modelCanvas.transform:Find("imgModel")
    local btnModel = tbModelShow.imgModelTrans.transform:Find("btnModel")--modelCanvas.transform:Find("imgModel/btnModel")

    local sizeOld = imgModel:GetComponent(ue.RectTransform).sizeDelta
    imgModel:GetComponent(ue.RectTransform).sizeDelta = ue.Vector2(sizeOld.x * (tbModelShow.params.dImgModelSizeX or 1), sizeOld.y * (tbModelShow.params.dImgModelSizeY or 1))
    btnModel:GetComponent(ue.RectTransform).sizeDelta = ue.Vector2(sizeOld.x * (tbModelShow.params.dTouchSizeX or 0.6), sizeOld.y * (tbModelShow.params.dTouchSizeY or 0.6))

    local function OnPointerDown(go, pointerEventData)
        if tbModelShow.pointerClickFunc then
            tbModelShow.pointerClickFunc(pointerEventData)
        end

        if tbModelShow.pointerClickIgnoreDrag and not tbModelShow.bIsDraging then
            tbModelShow.pointerClickIgnoreDrag(pointerEventData)
        end

        if not tbModelShow._noShowClickAnim then
            doShowAction(tbModelShow)
        end
    end

    local function OnDrag(go, pointerEventData)
        tbModelShow.bIsDraging = true
        if tbModelShow.dragFunc then
            tbModelShow.dragFunc(pointerEventData)
        else
            local transform = modelCanvas.transform:Find("modelContain/model")
            transform:Rotate(ue.Vector3.down * pointerEventData.delta.x)
            if tbModelShow.taiziGo then
                taiziTransform = tbModelShow.taiziGo.transform
                taiziTransform:Rotate(ue.Vector3.down * pointerEventData.delta.x)
            end
        end
    end

    local function OnEndDrag(go, pointerEventData)
        tbModelShow.bIsDraging = false
        if tbModelShow.endDragFunc then
            tbModelShow.endDragFunc(pointerEventData)
        end
    end

    KG.EventTriggerListener.Get(btnModel.gameObject).onPointerUp = OnPointerDown
    KG.EventTriggerListener.Get(btnModel.gameObject).onDrag = OnDrag
    KG.EventTriggerListener.Get(btnModel.gameObject).onEndDrag = OnEndDrag
end

--创建模型显示, gameObject 为模型所放位置
--dOffsetY用于不同界面同时显示2个模型时有重叠情况
function showModelOnUI(gameObject, dOffsetY, bUseInTeam, params)
    
    if pkgUITool.isNull(gameObject) then
        return 
    end

    local prefab = pkgAssetBundleMgr.LoadAssetBundleSync("3dmodel", "ModelCanvas")
    if not prefab then
        return
    end

    params = params or {}
    local tbModelShow = {}
    tbModelShow.params = params

    local modelCanvas = UnityEngine.Object.Instantiate(prefab)

    pkgUtilMgr.replaceGameObject(gameObject, modelCanvas)

    local imgModel = modelCanvas.transform:Find("imgModel")
    pkgUtilMgr.setPosition(imgModel.gameObject, 0, 0)
    tbModelShow.imgModelTrans = imgModel

    tbModelShow.modelCanvas = modelCanvas
    local modelContain = modelCanvas.transform:Find("modelContain")
    tbModelShow.modelContain = modelContain
    if dOffsetY or params.cameraModelOffsetX or params.cameraModelOffsetZ then
        dOffsetY = dOffsetY or 0
        local dOffsetX = params.cameraModelOffsetX or 0
        local dOffsetZ = params.cameraModelOffsetZ or 0
        local uiModelCamera = modelCanvas.transform:Find("UIModelCamera")
        local oldPos = uiModelCamera.transform.localPosition
        uiModelCamera.transform.localPosition = ue.Vector3(oldPos.x + dOffsetX, oldPos.y + dOffsetY, oldPos.z + dOffsetZ)
        tbModelShow.uiModelCamera = uiModelCamera

        oldPos = modelContain.transform.localPosition
        modelContain.transform.localPosition = ue.Vector3(oldPos.x + dOffsetX, oldPos.y + dOffsetY, oldPos.z)
    end

    initTouchModel(tbModelShow)
    initRenderTexture(tbModelShow, params)

    if params.createLight == false then
        local lightTrans = modelCanvas.transform:Find('Directional light')
        if lightTrans then
            lightTrans.gameObject:SetActive(false)
        end
    end

    if ue.Camera.main then
        local dOldCullingMask = ue.Camera.main.cullingMask
        local newCullingMask = pkgUITool.DelCullingMask(dOldCullingMask, "3DUI")
        ue.Camera.main.cullingMask = newCullingMask
    end

    return tbModelShow
end
