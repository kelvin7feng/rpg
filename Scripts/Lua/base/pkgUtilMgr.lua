doNameSpace("pkgUtilMgr")

local Vector3 = ue.Vector3
local Color = ue.Color
local Text = ue.UI.Text
local colorUnit = Color(1/255, 1/255, 1/255)

local function getTextComponent(go)
    local nonBreak = go:GetComponent("XS.NonBreakingSpaceTextComponent")
    if not nonBreak then
        go.gameObject:AddComponent("XS.NonBreakingSpaceTextComponent")
    end
    return go:GetComponent(Text)
end

function setScale(gameObject, dScale)
	assert(gameObject, "no GameObject")
    assert(dScale)

    gameObject.transform.localScale = Vector3(dScale, dScale, dScale)
end

function setNScale(gameObject, dScale)
    assert(gameObject, "no GameObject")
    assert(dScale)

    local dOldScale = gameObject.transform.localScale
    gameObject.transform.localScale = Vector3(dOldScale.x * dScale, dOldScale.y * dScale, dOldScale.z * dScale)
end


function setNScaleX(gameObject, dScaleX)
    assert(gameObject, "no GameObject")
    assert(dScaleX)

    local dOldScale = gameObject.transform.localScale
    gameObject.transform.localScale = Vector3(dOldScale.x * dScaleX, dOldScale.y, dOldScale.z)
end


function setScaleX(gameObject, dScale)
	assert(gameObject, "no GameObject")
    assert(dScale)

    local dScaleY = gameObject.transform.localScale.y
    gameObject.transform.localScale = Vector3(dScale, dScaleY, 0)
end

function setScaleY(gameObject, dScale)
	assert(gameObject, "no GameObject")
    assert(dScale)

    local dScaleX = gameObject.transform.localScale.x
    gameObject.transform.localScale = Vector3(dScaleX, dScale, 0)
end

function isNull(gameObject)
    if not gameObject or Slua.IsNull(gameObject) then
        return true
    end
end

function setRaycastTarget( gameObject, name, bool )
    if isNull(gameObject) then return end

    local imgTransform = gameObject.transform:Find(name)
    if isNull(imgTransform) then return end

    local imgCpnt = imgTransform:GetComponent(ue.UI.Image)
    if not imgCpnt then return end

    imgCpnt.raycastTarget = bool
end

function setAnchorMin( gameObject, vector2 )
    if isNull(gameObject) then return end
    gameObject:GetComponent(ue.RectTransform).anchorMin = vector2
end

function getAnchorMin( gameObject )
    if isNull(gameObject) then return end
    return gameObject:GetComponent(ue.RectTransform).anchorMin
end

function setAnchorMax( gameObject, vector2 )
    if isNull(gameObject) then return end
    gameObject:GetComponent(ue.RectTransform).anchorMax = vector2
end

function getAnchorMax( gameObject )
    if isNull(gameObject) then return end
    return gameObject:GetComponent(ue.RectTransform).anchorMax
end

function setPivot( gameObject, vector2 )
    if isNull(gameObject) then return end
    local rectTransform = gameObject:GetComponent(ue.RectTransform)
    if rectTransform.pivot.x == vector2.x and rectTransform.pivot.y == vector2.y then
        return
    end
    rectTransform.pivot = vector2
end

function setPosition(gameObject, x, y, z)
    if isNull(gameObject) then return end
    gameObject:GetComponent(ue.RectTransform).anchoredPosition3D = UnityEngine.Vector3(x, y, z or 0)
end

function getPosition(gameObject)
    if isNull(gameObject) then return end
    local vector2 = gameObject:GetComponent(ue.RectTransform).anchoredPosition
    return vector2
end

function setPosition3D( gameObject, x, y, z )
    if isNull(gameObject) then return end
    gameObject.transform.position = UnityEngine.Vector3(x, y, z)
end

function setScale3D( gameObject, x, y, z )
    if isNull(gameObject) then return end
    gameObject.transform.localScale = UnityEngine.Vector3(x, y, z)
end

function setRotation3D( gameObject, x, y, z)
    if isNull(gameObject) then return end
    gameObject.transform.localEulerAngles = UnityEngine.Vector3(x, y, z)
end

function setStringByName(gameObject, name, strText)
    if isNull(gameObject) then
        print_w("setStringByName gameObject is null, name is "..name)
        return
    end
    local go = gameObject.transform:Find(name)
    if isNull(go) then
        print_w(name .. " is null")
        return
    end
    go.gameObject:SetActive(true)
    local textCom = getTextComponent(go)
    if not textCom then return end
    textCom.text = strText
end

function setString(gameObject, strText)
    if isNull(gameObject) then return end
    gameObject.gameObject:SetActive(true)
    local textCom = getTextComponent(gameObject)
    if not textCom then return end
    textCom.text = strText
end

function setStringColorByName(gameObject, name, color)
    if isNull(gameObject) then return end
    local go = gameObject.transform:Find(name)
    if isNull(go) then return end
    local textCom = getTextComponent(go)
    if not textCom then return end
    textCom.color = color * colorUnit
end

function setStringColor(gameObject, color)
    if isNull(gameObject) then return end
    local textCom = getTextComponent(gameObject)
    if not textCom then return end
    textCom.color = color * colorUnit
end

function setImgColor( gameObject, color )
    if isNull(gameObject) then return end
    local imgCom = gameObject.gameObject:GetComponent(ue.UI.Image)
    if not imgCom then return end
    imgCom.color = color * colorUnit
end

function removeChild(gameObject, strChildName)
    if isNull(gameObject) then
        print_w(strChildName.."is null")
        return
    end
    local child = gameObject.transform:Find(strChildName)
    if isNull(child) then return end
	UnityEngine.GameObject.Destroy(child.gameObject)
end

function setActiveByName(gameObject, strName, bActive)
    if isNull(gameObject) then
        print_w("setActiveByName gameObject is null")
        return
    end
    local go = gameObject.transform:Find(strName)
    if isNull(go) then
        print_w("setActiveByName "..strName.." is null")
        return
    end
    go.gameObject:SetActive(bActive)
end

function isActivedByName(gameObject, strName)
    if isNull(gameObject) then
        print_w("isActivedByName gameObject is null")
        return
    end
    local go = gameObject.transform:Find(strName)
    if isNull(go) then
        print_w("isActivedByName "..strName.." is null")
        return
    end
    return go.gameObject.activeSelf
end

-- @brief 判断两个浮点数是否相等
-- @param a 浮点数1
-- @param b 浮点数2
-- @return true 相等 false 不相等
function floatEqual(a, b)
    local EPSILON = 0.000001
    return ((a - EPSILON) < b) and (b < ( a + EPSILON))
end

-- @brief 对table进行排序
-- @param tbData table内容
-- @param key 排序索引
-- @desc 为true为逆序，不传为顺序
function keySort(tbData, key, desc)
    local function funcSort(tbItemA, tbItemB)
        if desc then    -- 逆序
            return tbItemA[key] > tbItemB[key]
        else            -- 顺序
            return tbItemA[key] < tbItemB[key]
        end
    end
    table.sort(tbData, funcSort)
end

---冒泡排序，效率较低 数组大的情况下慎用
function bubbleSort(t, key, desc)
    local function swap(tb, d1, d2)
        local tmp = tb[d2]
        tb[d2] = tb[d1]
        tb[d1] = tmp
    end
    for i = 1, #t do
        for j = #t, i + 1, -1 do
            if desc then
                if t[j - 1][key] > t[j][key] then
                    swap(t, j, j - 1)
                end
            else
                if t[j - 1][key] < t[j][key] then
                    swap(t, j, j - 1)
                end
            end
        end
    end
    return t
end

function getGameObjectByName(gameObject, strName)
    if isNull(gameObject) then
        return
    end

    local trans = gameObject.transform:Find(strName)
    if isNull(trans) then return nil end
    return trans.gameObject
end

function setSelectorByName(gameObject,strName, func)
    if isNull(gameObject) then
        return
    end

    local go = getGameObjectByName(gameObject, strName)
    if isNull(go) then return nil end
    setSelector(go, func)
end

function setSelector(gameObject, func)
    if isNull(gameObject) then
        print_w("setSelector gameObject is null")
        return
    end
    local dropDownCpt = gameObject:GetComponent(ue.UI.Dropdown)
    if not dropDownCpt then return end
    dropDownCpt.onValueChanged:AddListener(function(dIndex)
        if func then
            func(dIndex)
        end
    end)
end


function array2table( array )
    if not array then
        return {}
    end

    local tb = {}
    for item in Slua.iter(array) do
        table.insert(tb, item)
    end

    return tb
end

-- 创建一个C# List<Type>
function newList(typename)
    -- local listType = Slua.GetClassType('System.Collections.Generic.List`1')
    -- local genericType = Slua.GetClassType(typename)
    -- local finalType = listType:MakeGenericType(genericType)
    -- return finalType()
    return XS.TypeHelper.MakeListT(typename)
end

-- 延迟执行
-- delayTime 延迟时间 毫秒
function delayRun(delayTime, callback, tbParam)
    local dTimerId = 0

	local function realCallback()
        if tbParam then
            callback(unpack(tbParam))
        else
            callback()
        end
		pkgTimerMgr.delete(dTimerId)
	end

	dTimerId = pkgTimerMgr.once(delayTime, realCallback)
end

local function findChildrenInHierarchyImplement(parent, name, tbResult)
    parent = parent.transform

    if not tbResult then
        tbResult = {}
    end

    for i =  0, parent.childCount - 1 do
        local child = parent:GetChild(i)

        if child.name == name then
            table.insert( tbResult, child )
        end

        findChildrenInHierarchyImplement(child, name, tbResult)
    end

    return tbResult
end

-- 找寻到对应名字的子节点们，无论多深
-- @param parent 父节点
-- @param name 要找寻的子节点名称
function findChildrenInHierarchy(parent, name)
    if not parent then
        return
    end

    return findChildrenInHierarchyImplement(parent, name)
end

-- 找寻到对应名字的子节点，无论多深
-- @param parent 父节点
-- @param name 要找寻的子节点名称
function findChildInHierarchy(parent, name)
    if not parent then
        return
    end

    parent = parent.transform

    for i =  0, parent.childCount - 1 do
        local child = parent:GetChild(i)

        if child.name == name then
            return child
        else
            local next = findChildInHierarchy(child, name)

            if next then
                return next
            end
        end
    end
end

-- 找到最上层的父Root节点
function findRootInHierarchy(selfTrans)
    if not selfTrans then
        return
    end

    if not selfTrans.parent then
        return selfTrans
    end

    return findRootInHierarchy(selfTrans.parent)
end


-- 找寻到对应名字的子节点的Component，无论多深
-- @param parent 父节点
-- @param name 要找寻的子节点名称
-- @param componentType 要找寻的type类型
function findChildComponentInHierarchy(parent, name, componentType)
    local child = findChildInHierarchy(parent, name)

    if child ~= nil then
        return child:GetComponent(componentType)
    end
end

function destroyTransformAllChildren(transform)
    if not transform then
        return
    end

    removeGameObjectAllListeners(transform.gameObject)

    local childrenObjects = {}
    local childCount = transform.childCount

    for i = 0, childCount - 1 do
        local child = transform:GetChild(i).gameObject
        childrenObjects[i + 1] = child
    end

    for i,v in ipairs(childrenObjects) do
        ue.Object.Destroy(v)
    end

    childrenObjects = {}
end

function removeGameObjectButtonListeners(gameObject)
    if isNull(gameObject) then
        return
    end

    if not ue.UI or not ue.UI.Button then
        return
    end

    local widgets = gameObject:GetComponentsInChildren(ue.UI.Button, true)

    if widgets then
        for v in Slua.iter(widgets) do
            if not isNull(v) and v.onClick ~= nil then
                v.onClick:RemoveAllListeners()
                v.onClick = ue.UI.Button.ButtonClickedEvent()
                pkgUIButtonMgr.le_tbBtnCached[v.gameObject] = nil 
            end
        end
    end

    widgets = nil
end

function removeGameObjectInputFieldListeners(gameObject)
    if isNull(gameObject) then
        return
    end

    if not ue.UI or not ue.UI.InputField then
        return
    end

    local widgets = gameObject:GetComponentsInChildren(ue.UI.InputField, true)

    if widgets then
        for v in Slua.iter(widgets) do
            if not isNull(v) then
                if v.onValueChanged ~= nil then
                    v.onValueChanged:RemoveAllListeners()
                    -- v.onValueChanged = nil
                end
                
                -- v.onValidateInput = nil
                -- v.onValueChanged = nil
            end
        end
    end

    widgets = nil
end

function removeGameObjectEventTriggerListeners(gameObject)
    if isNull(gameObject) then
        return
    end

    if not ue.EventSystems or not ue.EventSystems.EventTrigger then
        return
    end

    local widgets = gameObject:GetComponentsInChildren(ue.EventSystems.EventTrigger, true)

    if widgets then
        for v in Slua.iter(widgets) do
            if not isNull(v) and v.triggers ~= nil then
                for v2 in Slua.iter(v.triggers) do
                    if not isNull(v2) and v2.callback ~= nil then
                        v2.callback:RemoveAllListeners()
                        v2.callback = ue.EventSystems.EventTrigger.TriggerEvent()
                    end
                end
        
                v.triggers:Clear()
                v.triggers = nil
            end

            ue.GameObject.Destroy(v)
            v = nil
        end
    end

    widgets = nil
end

function removeGameObjectAllListeners( gameObject )
    if isNull(gameObject) then
        return
    end

    if ue.UI and ue.UI.Toggle then
        local widgets = gameObject:GetComponentsInChildren(ue.UI.Toggle, true)

        if widgets then
            for v in Slua.iter(widgets) do
                if not isNull(v) and v.onValueChanged ~= nil then
                    v.onValueChanged:RemoveAllListeners()
                    -- v.onValueChanged = nil
                end
            end
        end

        widgets = nil
    end

    removeGameObjectButtonListeners(gameObject)
    removeGameObjectInputFieldListeners(gameObject)

    if ue.UI and ue.UI.Slider then
        local widgets = gameObject:GetComponentsInChildren(ue.UI.Slider, true)

        if widgets then
            for v in Slua.iter(widgets) do
                if not isNull(v) and v.onValueChanged ~= nil then
                    v.onValueChanged:RemoveAllListeners()
                    v.onValueChanged = ue.UI.Slider.SliderEvent()
                end
            end
        end

        widgets = nil
    end

    if ue.UI and ue.UI.ScrollRect then
        local widgets = gameObject:GetComponentsInChildren(ue.UI.ScrollRect, true)

        if widgets then
            for v in Slua.iter(widgets) do
                if not isNull(v) and v.onValueChanged ~= nil then
                    v.onValueChanged:RemoveAllListeners()
                    -- v.onValueChanged = nil
                    v.onValueChanged = ue.UI.ScrollRect.ScrollRectEvent()
                end
            end
        end
        
        widgets = nil
    end

    removeGameObjectEventTriggerListeners(gameObject)
end

--替换gameObject
function replaceGameObject(oldGameObject, newGameObject, tbParams)
    if pkgUtilMgr.isNull(oldGameObject) then
        return
    end
    if pkgUtilMgr.isNull(newGameObject) then
        return
    end
    tbParams = tbParams or {}
    newGameObject.transform:SetParent(oldGameObject.transform.parent, false)
    newGameObject.transform:SetSiblingIndex(oldGameObject.transform:GetSiblingIndex())

    local rectOld = oldGameObject:GetComponent(ue.RectTransform)
    if rectOld and not tbParams.bNoSetSize then
        local rectNew = newGameObject:GetComponent(ue.RectTransform)
        rectNew.sizeDelta = rectOld.sizeDelta
    end
    if rectOld and newGameObject.transform.anchorMin then
        newGameObject.transform.anchorMin = oldGameObject.transform.anchorMin
        newGameObject.transform.anchorMax = oldGameObject.transform.anchorMax
        newGameObject.transform.pivot = oldGameObject.transform.pivot
    end
    newGameObject.transform.localScale= oldGameObject.transform.localScale
    if not tbParams.bNoSetPosition then
        newGameObject.transform.position = oldGameObject.transform.position
        newGameObject.transform.localPosition = oldGameObject.transform.localPosition
    end
    if not tbParams.bNoSetRotation then
        newGameObject.transform.rotation = oldGameObject.transform.rotation
    end
    newGameObject.transform.name= oldGameObject.transform.name

    removeGameObjectAllListeners(oldGameObject)
    ue.Object.Destroy(oldGameObject)
end

--copy gameObject
function copyGameObject(oldGameObject)
    local newGameObject = ue.Object.Instantiate(oldGameObject)
    newGameObject.transform:SetParent(oldGameObject.transform.parent)
    newGameObject.transform.rotation = oldGameObject.transform.rotation
    newGameObject.transform.position = oldGameObject.transform.position
    newGameObject.transform.name= oldGameObject.transform.name
    newGameObject.transform.localScale= oldGameObject.transform.localScale
    return newGameObject
end

function setLevelColor( gameObject, name, star )
    if isNull(gameObject) then
        print_w("setLevelColor gameObject is null")
        return
    end
    local go = gameObject.transform:Find(name)
    if not go then
        print_w("gameObject's name is null")
        return
    end
    local textCmp = go:GetComponent(ue.UI.Text)
    if not textCmp then
        print_w("gameObject's name has no text")
    end
    textCmp.color = pkgColorConstMgr.getColorByStar(star) * colorUnit

    local marginCmp
    marginCmp = go.gameObject:GetComponent(ue.UI.Outline)
    if not marginCmp then
        marginCmp = go.gameObject:AddComponent(ue.UI.Outline)
    end
    marginCmp.effectColor = pkgColorConstMgr.COLOR_MARGIN_LEVEL * colorUnit
    marginCmp.effectDistance = ue.Vector2(2, -2)
    textCmp:SetVerticesDirty()
end

--判断点是否在区域rt中
function IsPointInRT(point, rt, dScaleToDetect)
    dScaleToDetect = dScaleToDetect or 1
    local rect = rt.rect
    local width = rect.width * dScaleToDetect
    local height = rect.height * dScaleToDetect

    local leftSide = rt.transform.position.x - width / 2
    local rightSide = rt.transform.position.x + width / 2
    local topSide = rt.transform.position.y + height / 2
    local bottomSide = rt.transform.position.y - height / 2

    --Check to see if the point is in the calculated bounds
    if point.x >= leftSide and
        point.x <= rightSide and
        point.y >= bottomSide and
        point.y <= topSide then
        return true
    else
        return false
    end
end

-- 浮点数是否有效
function isNaN(x)
    return x ~= x
end

function changeLayersRecursively(parent, name)
    local trans = parent:GetComponentsInChildren(ue.Transform)
    local dLayer = ue.LayerMask.NameToLayer(name)
    for child in Slua.iter(trans) do
        child.gameObject.layer = dLayer
    end
end

function getRendererPropertyBlock(renderer)
    if renderer == nil or Slua.IsNull(renderer) then
        return
    end

    local prop = ue.MaterialPropertyBlock()
    renderer:GetPropertyBlock(prop)
    return prop
end

function setRendererPropertyBlock(renderer, prop)
    if renderer == nil or Slua.IsNull(renderer) then
        return
    end
    renderer:SetPropertyBlock(prop)
end

--过滤某个cullingMask
function delCullingMask(dOldCullingMask, cullingMask)
    if type(cullingMask) == "string" then
        cullingMask = ue.LayerMask.NameToLayer(cullingMask)
    end
    if type(cullingMask) ~= "number" then
        return
    end
    local b = (bit:_lshift(1, cullingMask))
    local bb = bit:_and(dOldCullingMask, b)
    if bb ~= 0 then
        return dOldCullingMask - b
    else --已经排除了
        return dOldCullingMask
    end
end


function isInList( tbList, val )
    for _,v in pairs(tbList) do
        if v==val then
            return true
        end
    end
    return false
end

function getChineseNum(dNum)
    local chinese_num = {}
    for i=1,10 do
        chinese_num[i] = _T("common_num_"..i)
    end
    chinese_num[20] = _T("common_num_"..20)
    if dNum < 10 then
        return chinese_num[dNum]
    elseif dNum < 100 then
        local dTen = math.floor(dNum/10)
        local dGe = dNum % 10
        local strGe = chinese_num[dGe] or ""
        local str
        if dTen == 2 then
            str = chinese_num[20].. strGe
        else
            local strTen = dTen > 1 and chinese_num[dTen] or ""
            str = strTen..chinese_num[10].. strGe
        end
        return str
    end
end

function captureCameraWithUnityNativeAPI(targetRenderTexture, captureEndCallback)
    local captureHelper = pkgGlobalGoMgr.le_go:AddComponent(XS.ScreenCaptureHelper)
    captureHelper:CaptureScreen(targetRenderTexture, function ( targetRT )
        targetRenderTexture = targetRT
        if captureEndCallback then
            captureEndCallback(targetRenderTexture)
        end

        captureHelper.captureEndCallback = nil
        ue.GameObject.Destroy(captureHelper)
    end)
end
-- function captureCameraWithUnityNativeAPI(targetRenderTexture, captureEndCallback)
    
--     local function readbackCompleted(request)
--         if request.hasError then
--             print_e('captureCameraWithUnityNativeAPI readbackCompleted.error')
--         end

--         if request.done then
--             print('captureCameraWithUnityNativeAPI complete')
--             if captureEndCallback then
--                 captureEndCallback(targetRenderTexture)
--             end
--         end
--     end

--     local function capture()
--         UnityEngine.ScreenCapture.CaptureScreenshotIntoRenderTexture(targetRenderTexture)
--         UnityEngine.Rendering.AsyncGPUReadback.Request(targetRenderTexture, 0, UnityEngine.TextureFormat.RGBA32, readbackCompleted)
--     end
    
--     capture()
-- end

--- <summary>
--- 对相机截图。
--- <-summary>
--- <returns>The screenshot2.<-returns>
--- <param name="camera">Camera.要被截屏的相机<-param>
--- <param name="rect">Rect.截屏的区域<-param>
--cameras 其他要加入渲染的镜头
function captureCamera(camera, cameras, tbParams, targetRenderTexture, captureEndCallback)

    captureCameraWithUnityNativeAPI(targetRenderTexture, captureEndCallback)

    do return end

    --TODO 适合URP的截屏
    
    tbParams = tbParams or {}

    local beforeRT = camera.targetTexture

    targetRenderTexture.name = "CaptureCamera"
    -- 临时设置相关相机的targetTexture为rt, 并手动渲染相关相机
    camera.targetTexture = targetRenderTexture
    camera:Render()

    for _, v in pairs(cameras) do
        v.targetTexture = targetRenderTexture
        v:Render()
    end

    -- 重置相关参数，以使用camera继续在屏幕上显示
    camera.targetTexture = beforeRT
    for _, v in pairs(cameras) do
        v.targetTexture = nil
    end
    ue.RenderTexture.active = nil -- JC: added to avoid errors

    return targetRenderTexture
end

function captureCamera2(rect)
    local tex2d = ue.Texture2D(rect.width, rect.height, ue.TextureFormat.RGB24, false)
    tex2d:ReadPixels(rect, 0, 0)
    tex2d:Apply()
    return tex2d
end

-- 把数字格式化成 hh:mm:ss
function formatTimestamp(dTime, bWithDay)
	local dHour = 3600
	local dMin = 60
	local h = dTime / 3600
	local m = dTime % 3600
	m = m/60
	s = dTime%60
	local str
	if bWithDay then
		local d = dTime/(dHour*24)
		h = math.floor(h)
		h = h%24
		str = string.format("%d%s%02d:%02d:%02d", d,_T("op_day"),h, m, s)
	else
		str = string.format("%02d:%02d:%02d", h, m, s)
	end
	return str
end

function setSkinnedMeshRendererTag( gameObject, tag )
    if not gameObject or not tag then
        return
    end

    local renderers = gameObject:GetComponentsInChildren(ue.Renderer)
    for renderer in Slua.iter(renderers) do
        renderer.tag = tag
    end
end

function setSkinnedMeshRendererLayer( gameObject, layer )
    if not gameObject or not layer then
        return
    end

    local renderers = gameObject:GetComponentsInChildren(ue.Renderer)
    for renderer in Slua.iter(renderers) do
        renderer.gameObject.layer = layer
    end
end

function updateCustomShadow( gameObject, bAdd, bNoCircleShadow )
    if UnityEngine.QualitySettings.shadows == UnityEngine.ShadowQuality.Disable then
        if bNoCircleShadow then
            return
        end

        if bAdd then
            pkgCircleShadowMgr.add(gameObject)
        else
            pkgCircleShadowMgr.remove(gameObject)
        end

        -- return
    end

    local camera = UnityEngine.Camera.main
    if not camera then
        return
    end

    local manager = camera:GetComponent("XS.CustomShadowMapManager")
    if not manager then
        return
    end

    local renderers = gameObject:GetComponentsInChildren(ue.MeshRenderer)
    if renderers then
        for renderer in Slua.iter(renderers) do
            if bAdd then
                manager:AddShadowObj(renderer)
            else
                manager:RemoveShadowObj(renderer)
            end
        end
    end

    local renderers = gameObject:GetComponentsInChildren(ue.SkinnedMeshRenderer)
    if renderers then
        for renderer in Slua.iter(renderers) do
            if bAdd then
                manager:AddShadowObj(renderer)
            else
                manager:RemoveShadowObj(renderer)
            end
        end
    end

    local fakeShadow = gameObject:GetComponent(XS.FakeShadowsBehaviour)
    if fakeShadow then
        if not bAdd then
            ue.Object.Destroy(fakeShadow)
        end
    end
end

-- @param 拿到table元素个数
function getTableCount(targetTable)
    local count = 0

    for k,v in pairs(targetTable) do
        count = count + 1
    end

    return count
end

-- @param 拿到table最大的key值
function getTableMaxKey(targetTable)
    local result = 0

    for k,v in pairs(targetTable) do
        if k > result then
            result = k
        end
    end

    return result
end

function createRoleEventObj(go)
    local tbObj = {}
    tbObj.go = go
    tbObj._animator = go:GetComponentInChildren(ue.Animator)
    tbObj._roleActionEvent = go:GetComponentInChildren(XS.RoleActionEvent)
    tbObj._handlers = {}

    local function onHandler(dEventType)
        if tbObj._handlers[dEventType] then
            tbObj._handlers[dEventType]()
        end
    end
    tbObj._roleActionEvent:setEventHandler(onHandler)

    tbObj._tbCompleteEventSet = {}
    function tbObj:addCompleteEvent(dActionHashId, cbHandler)
        local dEventType = pkgRoleConst.getActionCompleteEventType(dActionHashId)
        local dUEActionHashId = pkgRoleConst.getUeActionHashId(dActionHashId)
        if not dEventType then return end
        assert(dEventType)
        self._handlers[dEventType] = cbHandler

        if not self._tbCompleteEventSet[dActionHashId] then
            if self._animator.runtimeAnimatorController then
                for clip in Slua.iter(self._animator.runtimeAnimatorController.animationClips) do
                    local clipName = clip.name
                    if string.find(clip.name, "_") then
                        clipName = string.sub(clipName, 3)
                    end
                    local dHashId = ue.Animator.StringToHash(clipName)
                    if dHashId == dUEActionHashId then
                        local isFindEvent = false
                        for event in Slua.iter(clip.events) do
                            if dEventType == event.intParameter then
                                self._tbCompleteEventSet[dActionHashId] = true
                                isFindEvent = true
                                break
                            end
                        end

                        if not isFindEvent then
                            local event = ue.AnimationEvent()
                            event.intParameter = dEventType
                            event.functionName = "onActionEvent"
                            event.time = clip.length * 0.95
                            clip:AddEvent(event)
                            self._tbCompleteEventSet[dActionHashId] = true
                            break
                        end
                    end
                end
            end
        end
    end

    function tbObj:removeCompleteEvent(dActionHashId)
        local dEventType = pkgRoleConst.getActionCompleteEventType(dActionHashId)
        assert(dEventType)
        self._handlers[dEventType] = nil
    end

    return tbObj
end

--替换iocn，修复位置偏移问题
function replaceIcon(oldGameObject, iconGo)
    local icon = iconGo.transform:Find("icon")
    if icon then
        icon.anchorMax = ue.Vector2(0.5,0.5)
        icon.anchorMin = ue.Vector2(0.5,0.5)
        icon.localPosition = ue.Vector3(0,0,0)
    end
    pkgUtilMgr.replaceGameObject(oldGameObject.gameObject, iconGo.gameObject)
end

function getTempRenderTexture(gameObject, name, width, height, bit, rtFormat)
    if pkgUtilMgr.isNull(gameObject) then
        return
    end

    local renderTexture = nil
    renderTexture = ue.RenderTexture.GetTemporary(width, height, bit)

    -- if rtFormat and ue.SystemInfo.SupportsRenderTextureFormat(rtFormat) then
    --     renderTexture = ue.RenderTexture.GetTemporary(width, height, bit, rtFormat)
    -- else
    --     renderTexture = ue.RenderTexture.GetTemporary(width, height, bit)
    -- end

    renderTexture.name = name

    -- local function destroyImplement(selfTable, targetObject, parameters, luaBehaviour)
    --     if renderTexture then
    --         ue.RenderTexture.ReleaseTemporary(renderTexture)
    --         renderTexture = nil
    --         pkgUIShowModelMgr.subZOrder()
    --     end
    
    --     if luaBehaviour then
    --         print_e('luaBehaviour')
    --         local luaTable = luaBehaviour.LuaTable
    --         luaTable.OnDestroy = nil
    --         luaTable = nil
    --         luaBehaviour.LuaTable = {}
    --         luaBehaviour.Parameters = nil
    --         selfTable.OnDestroy = nil
    --         -- ue.Object.Destroy(luaBehaviour)
    --         luaBehaviour = nil
    --     end 
    -- end

    -- local tb = {
    --     OnDestroy = destroyImplement
    -- }

    -- local luaBehaviour = XS.LuaMonoBehaviour.Bind(gameObject, "pkgRenderTextureBehaviour", renderTexture)
    -- luaBehaviour.Parameters = renderTexture
    return renderTexture
end

function staticCombineScene()
    local environmentGo = UnityEngine.GameObject.Find("Environment")
    if not environmentGo then
        return
    end

    UnityEngine.StaticBatchingUtility.Combine(environmentGo)
    print("-- static combile --")
end

function setAnimatorEvent(go, callback)
    local roleActionEvent = go:GetComponent(XS.RoleActionEvent)
    if roleActionEvent then
        roleActionEvent:setEventHandler(callback)
    end
end

function isIphoneWithLiuHai()
    local screenWidth = ue.Screen.width
    local screenHeight = ue.Screen.height

    if pkgQualityMgr then
        screenWidth = pkgQualityMgr.le_defaultScreenResolutionWidth
        screenHeight = pkgQualityMgr.le_defaultScreenResolutionHeight
    end

    -- print_e('ue.Screen.width:' .. tostring(ue.Screen.width) .. ' height:' .. tostring(ue.Screen.height))
    -- print_e('screenWidth:' .. tostring(screenWidth) .. ' screenHeight:' .. tostring(screenHeight))

    if screenWidth == 2436 and screenHeight == 1125 then ---iphone x/s/11 Pro
        return true
    end
    if screenWidth == 2688 and screenHeight == 1242 then ---iphone x(s) max/11 Pro Max
        return true
    end
    if screenWidth == 1792 and screenHeight == 828 then ---iphone xr/11
        return true
    end
    if screenWidth == 2689 and screenHeight == 1242 then ---iphone xs max 的放大模式 ??? 奇怪的数值
        return true
    end
    if screenWidth == 1624 and screenHeight == 750 then ---iphone xr 放大模式
        return true
    end
    return false
end

function hasLiuHai()
    if pkgUIMgr.hasLiuHai() then
        return true
    end
    return isIphoneWithLiuHai()
end

function hasHomeIndicator()
    local screenWidth = ue.Screen.width
    local screenHeight = ue.Screen.height

    if pkgQualityMgr then
        screenWidth = pkgQualityMgr.le_defaultScreenResolutionWidth
        screenHeight = pkgQualityMgr.le_defaultScreenResolutionHeight
    end

    --print_e('ue.Screen.width:' .. tostring(ue.Screen.width) .. 'ue.Screen.height:' .. tostring(ue.Screen.height))
    if screenWidth == 2436 and screenHeight == 1125 then ---iphone x/s
        return true
    end
    if screenWidth == 2688 and screenHeight == 1242 then ---iphone xs max
        return true
    end
    if screenWidth == 2689 and screenHeight == 1242 then ---iphone xs max 的放大模式 ??? 奇怪的数值
        return true
    end
    if screenWidth == 1792 and screenHeight == 828 then ---iphone xr
        return true
    end
    if screenWidth == 1624 and screenHeight == 750 then ---iphone xr 放大模式
        return true
    end
    if screenWidth == 2388 and screenHeight == 1668 then ---ipad pro 11
        return true
    end
    if screenWidth == 2738 and screenHeight == 2048 then ---ipad pro 12.9
        return true
    end
    return false
end

--iphoneX适配，左右拉伸
function changeSizeDeltaXForIphoneX(gameObject, strGo, dOffsetX)
    if hasLiuHai() then
        local go = gameObject.transform:Find(strGo)
        if go then
            local rect = go.gameObject:GetComponent(ue.RectTransform)
            local oldSizeDelta = rect.sizeDelta
            dOffsetX = dOffsetX or pkgUIMgr.UI_OFFSETX_FOR_IPHONEX
            rect.sizeDelta = ue.Vector2(oldSizeDelta.x + dOffsetX, oldSizeDelta.y)
        end
    end
end

--iphoneX适配，左右拉伸
function changeSizeDeltaYForIphoneX(gameObject, strGo, dOffsetY)
    if hasHomeIndicator() then
        local go = gameObject.transform:Find(strGo)
        if go then
            local rect = go.gameObject:GetComponent(ue.RectTransform)
            local oldSizeDelta = rect.sizeDelta
            rect.sizeDelta = ue.Vector2(oldSizeDelta.x, oldSizeDelta.y + dOffsetY)
        end
    end
end

--iphoneX适配，位置偏移
function changePositionXForIphoneX(gameObject, strGo, dOffsetX, bRight)
    if hasLiuHai() then
        local go = gameObject.transform:Find(strGo)
        if go then
            local rect = go.gameObject:GetComponent(ue.RectTransform)
            local oldAnchoredPosition3D = rect.anchoredPosition3D
            dOffsetX = dOffsetX or pkgUIMgr.UI_OFFSETX_FOR_IPHONEX
            if bRight then
                dOffsetX = -dOffsetX
            end
            rect.anchoredPosition3D = ue.Vector3(oldAnchoredPosition3D.x + dOffsetX, oldAnchoredPosition3D.y, oldAnchoredPosition3D.z)
        end
    end
end

--iphoneX适配，底部适配
function changePositionYForIphoneX(gameObject, strGo, dOffsetY)
    if hasHomeIndicator() then
        local go = gameObject.transform:Find(strGo)
        if go then
            local rect = go.gameObject:GetComponent(ue.RectTransform)
            local oldAnchoredPosition3D = rect.anchoredPosition3D
            dOffsetY = dOffsetY or pkgUIMgr.UI_OFFSETY_FOR_IPHONEX
            rect.anchoredPosition3D = ue.Vector3(oldAnchoredPosition3D.x, oldAnchoredPosition3D.y + dOffsetY, oldAnchoredPosition3D.z)
        end
    end
end

--界面gameObject
--strGo:Panel所在路径：一般就是"Panel"
function changeOffsetForIphoneX(gameObject, strGo)
    if hasLiuHai() then
        local panel = gameObject.transform:Find(strGo)
        if panel then
            local rect = panel.gameObject:GetComponent(ue.RectTransform)
            local oldOffsetMin = rect.offsetMin
            local oldOffsetMax = rect.offsetMax
            rect.offsetMin = ue.Vector2(pkgUIMgr.UI_OFFSETX_FOR_IPHONEX, oldOffsetMin.y)
            rect.offsetMax = ue.Vector2(-pkgUIMgr.UI_OFFSETX_FOR_IPHONEX, oldOffsetMax.y)
        end
    end
end

--界面gameObject
--strGo:Panel所在路径：一般就是"Panel"，底部偏移
function changeOffsetBottomForIphoneX(gameObject, strGo)
    if hasHomeIndicator() then
        local panel = gameObject.transform:Find(strGo)
        if panel then
            local rect = panel.gameObject:GetComponent(ue.RectTransform)
            local oldOffsetMax = rect.offsetMax
            rect.offsetMax = ue.Vector2(oldOffsetMax.x, -pkgUIMgr.UI_OFFSETY_FOR_IPHONEX)
        end
    end
end

function changeOffsetMinYForIphoneX(gameObject, strGo)
    if hasHomeIndicator() then
        local panel = gameObject.transform:Find(strGo)
        if panel then
            local rect = panel.gameObject:GetComponent(ue.RectTransform)
            local oldOffsetMin = rect.offsetMin
            rect.offsetMin = ue.Vector2(oldOffsetMin.x, pkgUIMgr.UI_OFFSETY_FOR_IPHONEX)
        end
    end
end

--界面gameObject
--strGo:背景图所在路径：一般就是"Panel"，背景图等比拉伸
function changeBgForIphoneX(gameObject, strGo)
    local sr = pkgUIMgr.getScreenRatio()
    local dr = pkgUIMgr.getDesignScreenRatio()
    if sr > dr then
        local bg = gameObject.transform:Find(strGo)
        if bg then
            local arf = bg.gameObject:GetComponent(ue.UI.AspectRatioFitter)
            if arf then
                arf.enabled = true
            end
        end
    end
end


function checkList(list, val)
    if not list then
        return false
    end

    for k,v in pairs(list) do
        if v==val then
            return true
        end
    end
    return false
end

function setCostString(gameObject, name, dNeed, dHave, bBlackBg)
    local c2w = pkgStringMgr.convertNumber2Wan
    local str = "%s/%s"
    setStringByName(gameObject, name, str:format(c2w(dHave), c2w(dNeed)))
    local bEnough = dHave >= dNeed
    setCostColor(gameObject, name, bEnough, bBlackBg)
end

function setCostColor(gameObject, name, bEnough, bBlackBg)
    if isNull(gameObject) then
        print_w("setCostColor gameObject is null")
        return
    end
    local go = gameObject.transform:Find(name)
    if not go then
        print_w("gameObject's name is null")
        return
    end
    local textCmp = go:GetComponent(ue.UI.Text)
    if not textCmp then
        print_w("gameObject's name has no text")
    end
    if true or bEnough then
        if bBlackBg then
            textCmp.color = pkgColorConstMgr.COLOR_COST_ENOUGH_BLACK * colorUnit
        else
            textCmp.color = pkgColorConstMgr.COLOR_COST_ENOUGH * colorUnit
        end
    else
        if bBlackBg then
            textCmp.color = pkgColorConstMgr.COLOR_COST_NOT_ENOUGH_BLACK * colorUnit
        else
            textCmp.color = pkgColorConstMgr.COLOR_COST_NOT_ENOUGH * colorUnit
        end
    end
end

function isTypeString( targetObject, strTypeString )
	local strResult = Slua.ToString(targetObject)
	if not strResult then
		return false
	end

	local strType = string.match(strResult, "%((.+)%)")
	return strType == strTypeString
end

function setUICanvaseScalerMacthValue(gameObject, value)
    if not gameObject or Slua.IsNull(gameObject) then
        return
    end

    local canvasScaler = gameObject:GetComponent(ue.UI.CanvasScaler)

    if canvasScaler then
        canvasScaler.matchWidthOrHeight = value
    end
end


function cleanChild(goParent, skip)
    for i=0, goParent.transform.childCount - 1 do
        local goChild = goParent.transform:GetChild(i).gameObject
        if goChild.name ~= skip then
            ue.Object.Destroy(goChild)
        end
    end
end

-- 将UI Mask的裁剪区域信息同步到材质
function syncUIMaskClipRectToMaterials(maskTrans, material, customPropertyName)
    if not maskTrans or not material then
       return
    end

    local cornersArray = Slua.MakeArray('UnityEngine.Vector3', {ue.Vector3.zero, ue.Vector3.zero, ue.Vector3.zero, ue.Vector3.zero})
    maskTrans:GetWorldCorners(cornersArray)

    local clipCorner = ue.Vector4.zero

    local index = 0
    for itrCorner in Slua.iter(cornersArray) do
        if index == 0 then
            clipCorner.x = itrCorner.x
            clipCorner.y = itrCorner.y
        elseif index == 2 then
            clipCorner.z = itrCorner.x
            clipCorner.w = itrCorner.y
        end

        -- print_e('index:' .. tostring(index) .. ' itrCorner:' .. tostring(itrCorner))
        index = index + 1
    end

    if customPropertyName then
        material:SetVector(customPropertyName, clipCorner)
    else
        material:SetVector('_ClipRect', clipCorner)
    end

    -- print_e('clipCorner:' .. tostring(clipCorner))
end


function setSlider(go, path, maxValue, value)
 
    local cpSlider = pkgUIMgr.getChildComponent(go, path, ue.UI.Slider)
    if not cpSlider then
        return
    end

    cpSlider.maxValue = maxValue
    cpSlider.value    = value
end


function manualWorldToScreenPoint(world2Screen, x, z, pixelWidth, pixelHeight)
    local temp = world2Screen * ue.Vector4(x, 10, z, 1.0)
	if temp.w == 0 then
		return ue.Vector3.zero
	else
		temp.x = (temp.x/temp.w + 1)*0.5 * pixelWidth
		temp.y = (temp.y/temp.w + 1)*0.5 * pixelHeight
		return temp.x, temp.y
	end
end

function manualScreenPointToWorld(screen2World, x, y, pixelWidth, pixelHeight)
    local in_x = 2.0 * (x / pixelWidth) - 1.0
    local in_y = 2.0 * (y / pixelHeight) - 1.0
    local in_z = 10
    local in_w = 1.0
 
    local pos = screen2World * ue.Vector4(in_x,in_y,in_z,in_w)
	
	if pos.w == 0 then
		return ue.Vector3.zero
	else
		pos.w = 1.0 / pos.w
		pos.x = pos.x*pos.w
		pos.y = pos.y*pos.w
		pos.z = pos.z*pos.w
		return pos.x, pos.z
	end
end

function setSceneMaterialWithSpriteAltasUV( material, sprite )
    local textureRect = sprite.textureRect

    local x = textureRect.x / sprite.texture.width
    local y = textureRect.y / sprite.texture.height
    local w = textureRect.width / sprite.texture.width
    local h = textureRect.height / sprite.texture.height

    material.mainTextureScale = ue.Vector2(w, h)
    material.mainTextureOffset = ue.Vector2(x, y)
end

function getMondayTime(dCurrentTime)
    local tbCurTime = xs.date("*t", dCurrentTime)
    local dZeroTime = xs.time( {year=tbCurTime.year, month=tbCurTime.month, day=tbCurTime.day, hour = 6, min=0, sec=0} )
    local dDay2Cal = tbCurTime.wday
    if tbCurTime.wday == 1 then --星期天，特殊处理
        dDay2Cal = 8
    end
    local dMondayTime = dZeroTime - 60*60*24* (dDay2Cal - 2) --星期一时间
    if tbCurTime.wday == 2 and dCurrentTime < dZeroTime then --星期一6点以前，算上周的
        dMondayTime = dMondayTime -7*24*60*60
    end
    return dMondayTime
end

-- 通用的验证当前是否点击到了主界面聊天区域的函数
function commonUIClickChatViewVerifier()
    local eventSystem = ue.EventSystems.EventSystem.current
    if not eventSystem then
        return true
    end

    local eventData = ue.EventSystems.PointerEventData(eventSystem)
    eventData.position = ue.Vector2(ue.Input.mousePosition.x, ue.Input.mousePosition.y)
    
    local raycastResults = XS.TypeHelper.MakeListT('UnityEngine.EventSystems.RaycastResult')

    ue.EventSystems.EventSystem.current:RaycastAll(eventData, raycastResults)

    for raycastItem in Slua.iter(raycastResults) do
        if not Slua.IsNull(raycastItem.gameObject) then
            local raycastObject = raycastItem.gameObject
            if raycastObject then
                local raycastRootTrans = raycastObject.transform.root
                if raycastRootTrans then
                    -- print_e('raycastObject:' .. raycastObject.name .. ' raycastRootTrans:' .. tostring(raycastRootTrans.name))

                    if raycastObject.name == 'btnChat' and raycastRootTrans.name == 'UI_chat_panel' then
                        XS.ExecuteEventsWrap.ExecuteClickHandler(raycastObject, eventData, XS.ExecuteEventsWrap.pointerClickHandler)
                        return false
                    elseif raycastRootTrans.name == 'UI_chat_main' then
                        XS.ExecuteEventsWrap.ExecuteClickHandler(raycastObject, eventData, XS.ExecuteEventsWrap.pointerClickHandler)
                        return false
                    end
                end
            end
        end
    end

    return true
end

-- alphaState 1 Opaque 2 AplhaTest 3 Transparent
function changeURPMaterialAlphaState( material, alphaState )
    if alphaState == 1 then
        material:DisableKeyword("_ALPHATEST_ON")
        material:SetOverrideTag("RenderType", "Opaque")
        material.renderQueue = UnityEngine.Rendering.RenderQueue.Geometry
        material:SetInt("_SrcBlend", UnityEngine.Rendering.BlendMode.One)
        material:SetInt("_DstBlend", UnityEngine.Rendering.BlendMode.Zero)
    elseif alphaState == 2 then
        material:EnableKeyword("_ALPHATEST_ON")
        material:SetOverrideTag("RenderType", "TransparentCutout")
        material.renderQueue = UnityEngine.Rendering.RenderQueue.AlphaTest
        material:SetInt("_SrcBlend", UnityEngine.Rendering.BlendMode.One)
        material:SetInt("_DstBlend", UnityEngine.Rendering.BlendMode.Zero)
    elseif alphaState == 3 then
        material:DisableKeyword("_ALPHATEST_ON")
        material:SetOverrideTag("RenderType", "Transparent")
        material.renderQueue = UnityEngine.Rendering.RenderQueue.Transparent
        material:SetInt("_SrcBlend", UnityEngine.Rendering.BlendMode.SrcAlpha)
        material:SetInt("_DstBlend", UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha)
    end
end
