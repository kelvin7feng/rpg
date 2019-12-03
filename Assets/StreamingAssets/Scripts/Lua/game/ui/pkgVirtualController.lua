doNameSpace("pkgVirtualController")

virtualController = virtualController or nil
objJoystickBg = objJoystickBg or nil
virtualJoystickPanel = virtualJoystickPanel or nil
virtualCameraJoystick = virtualCameraJoystick or nil
joystickRectTransform = joystickRectTransform or nil
cameraStartPoint = UnityEngine.Vector2.zero
joystickImg = joystickImg or nil
joystickBgImg = joystickBgImg or nil

-- new
bReleased = true
dInsideAreaFingerId = -1
analogTouch = nil
startPosition = nil
bAutoHide = true
currentJoystickPos = nil
rawAxis = nil
dFadeInDuration = 0.5
dFadeOutDuration = 1.5
dMaxDistance = 0
dTurnLimit = 107
dReturnSpeed = 10
normalizedAxis = nil
canvasInitialPoint = nil
screenToAnchorPositionConversionConstant = nil
screenUnitsToWorldUnitsConversionConstant = nil

local function UpdateDestination(direction)
    if direction ~= UnityEngine.Vector3.zero then
        local player = pkgActorManager.GetMainPlayer()
        local destination = pkgSysPlayer.ClacDestination(player, direction.x, direction.y, direction.z)
        pkgSysPlayer.SetDestination(player,destination)
        pkgSysPlayer.SetAnimationMoveSpeed(player, direction.magnitude)
    end
end

function TouchBegan(touchPosition)
    bReleased = false
    startPosition = touchPosition

    local position = canvasInitialPoint + UnityEngine.Vector3(touchPosition.x, touchPosition.y, 0) * screenUnitsToWorldUnitsConversionConstant
    objJoystickBg.transform.position = position
    joystick.transform.position = position

    if bAutoHide then
        joystickImg:CrossFadeAlpha(1, dFadeInDuration, true)
        if joystickBgImg then
            joystickBgImg:CrossFadeAlpha(1, dFadeInDuration, true)
        end
    end
end

function TouchMove(touchPosition)
    currentJoystickPos = touchPosition
    rawAxis = currentJoystickPos - startPosition
    
    local direction = rawAxis.normalized
    local distance = rawAxis.magnitude
    if distance <= 0 then
        return
    end

    local tempPos = UnityEngine.Vector2.zero
    local normalizedDistance = UnityEngine.Mathf.Clamp(distance / dMaxDistance, 0, 1.05)
    normalizedAxis = direction * normalizedDistance
    tempPos = (startPosition + (normalizedAxis * dMaxDistance)) * screenUnitsToWorldUnitsConversionConstant

    local position = canvasInitialPoint + UnityEngine.Vector3(tempPos.x, tempPos.y, 0)
    joystick.transform.position = position
    UpdateDestination(UnityEngine.Vector3(direction.x, 0, direction.y))
end

function TouchEnd()
    dReleased = true
    dInsideAreaFingerId = -1
    normalizedAxis = UnityEngine.Vector2.zero

    if bAutoHide then
        if joystickImg then
            joystickImg:CrossFadeAlpha(0, dFadeOutDuration, true)
        end
        if joystickBgImg then
            joystickBgImg:CrossFadeAlpha(0, dFadeOutDuration, true)
        end
    end
end

function UpdateVirtualController()
    if GetTouchCount() > 0 then
        
        if bReleased then
            dInsideAreaFingerId = GetFingerIdInsideArea()
        end
        
        if dInsideAreaFingerId ~= -1 then
            analogTouch = GetTouchByFingerId(dInsideAreaFingerId)
            if bReleased then
                if analogTouch.phase == UnityEngine.TouchPhase.Began then
                    bReleased = false
                    TouchBegan(analogTouch.position)
                end
            else
                if analogTouch.phase == UnityEngine.TouchPhase.Moved 
                    or analogTouch.phase == UnityEngine.TouchPhase.Stationary then
                    TouchMove(analogTouch.position)
                elseif analogTouch.phase == UnityEngine.TouchPhase.Ended then
                    TouchEnd()
                end
            end
        else
            bReleased = true    
        end
    else
        bReleased = true
        dInsideAreaFingerId = -1
    end

    if bReleased and joystick and startPosition then
        joystickRectTransform.position = UnityEngine.Vector2.Lerp(joystick.transform.position, startPosition, dReturnSpeed * UnityEngine.Time.unscaledDeltaTime)
    end
end

function GetTouchCount()
    if pkgApplicationTool.IsEditor() then
        return (UnityEngine.Input.GetMouseButtonDown(0) or UnityEngine.Input.GetMouseButtonUp(0) or UnityEngine.Input.GetMouseButton(0)) and 1 or 0
    else
        return UnityEngine.Input.touchCount
    end
end

function IsInsideArea(position)
    if position.x < 500 then
        return true
    else
        return false
    end
end

function MakeFakeTouchOnPC()

    local touch = UnityEngine.Touch()
    touch.position = UnityEngine.Input.mousePosition

    if UnityEngine.Input.GetMouseButtonDown(0) then
        touch.phase = UnityEngine.TouchPhase.Began
    elseif UnityEngine.Input.GetMouseButtonUp(0) then
        touch.phase = UnityEngine.TouchPhase.Ended
    elseif UnityEngine.Input.GetMouseButton(0) then
        touch.phase = UnityEngine.TouchPhase.Moved
    else
        touch.phase = UnityEngine.TouchPhase.Canceled
    end

    return touch
end

function GetTouchByFingerId(dFingerId)

    if not pkgApplicationTool.IsEditor() then
        for i=0,UnityEngine.Input.touchCount-1 do
            if UnityEngine.Input.GetTouch(i).fingerId == dFingerId then
                return UnityEngine.Input.GetTouch(i)
            end
        end
        return UnityEngine.Touch()
    else
        return MakeFakeTouchOnPC()
    end
    
end

function GetFingerIdInsideArea()
    if pkgApplicationTool.IsEditor() then
        if (UnityEngine.Input.GetMouseButtonDown(0) or UnityEngine.Input.GetMouseButtonUp(0) or UnityEngine.Input.GetMouseButton(0)) and
            IsInsideArea(UnityEngine.Input.mousePosition) then
            return 0
        else
            return -1
        end
    else
        for i=0,UnityEngine.Input.touchCount-1 do
            if (IsInsideArea(UnityEngine.Input.GetTouch(i).position)) then
                return i;
            end
        end
        return -1;
    end
end

local function normalAttack()
    pkgSysSkill.SetAttackSkill(pkgActorManager.GetMainPlayer(), 0)
end

function OnCameraPointerDown(go, eventData)
    cameraStartPoint = eventData.pressPosition
end

function OnCameraPointerUp(go, eventData)
    cameraStartPoint = UnityEngine.Vector2.zero
    pkgCamera.SetDeltaInput(cameraStartPoint.x, cameraStartPoint.y)
end

function OnCameraDrag(go, eventData)
    local pos = eventData.delta
    pkgCamera.SetDeltaInput(pos.x, pos.y)
end

function Init()
    local function onLoadComplete(prefab)
        virtualController = UnityEngine.GameObject.Instantiate(prefab)
        pkgCanvasMgr.AddToCanvas(pkgCanvasDefination.CanvasName.JOYSTICK, virtualController)

        local canvas = virtualController:GetComponentInParent(UnityEngine.Canvas)
        local canvasRect = canvas:GetComponent(UnityEngine.RectTransform)
        local canvasSize = canvasRect.sizeDelta
        canvasInitialPoint = canvas.transform.position 
                                + UnityEngine.Vector3(-canvasSize.x * canvas.transform.lossyScale.x * 0.5, -canvasSize.y * canvas.transform.lossyScale.y * 0.5, 0)

        local rectTransform = virtualController:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        local screenPixels = UnityEngine.Vector2(UnityEngine.Screen.width, UnityEngine.Screen.height)
        screenToAnchorPositionConversionConstant = UnityEngine.Vector2(canvasSize.x/screenPixels.x, canvasSize.y/screenPixels.y)
        
        local canvasScale = canvas.transform.lossyScale.x
        screenUnitsToWorldUnitsConversionConstant = screenToAnchorPositionConversionConstant.y * canvasScale
        dMaxDistance = dTurnLimit / screenToAnchorPositionConversionConstant.y

        virtualJoystickPanel = virtualController.transform:Find("VirtualJoystickPanel")
        objJoystickBg = virtualController.transform:Find("VirtualJoystickPanel/JoystickBg")
        joystick = virtualController.transform:Find("VirtualJoystickPanel/Joystick")
        joystickRectTransform = joystick:GetComponent(UnityEngine.RectTransform)

        joystickImg = joystick:GetComponentInParent(UnityEngine.UI.Image)
        joystickBgImg = objJoystickBg:GetComponentInParent(UnityEngine.UI.Image)
        
        virtualCameraJoystick = virtualController.transform:Find("VirtualCameraJoystick")
        KG.EventTriggerListener.Get(virtualCameraJoystick.gameObject).onPointerUp = OnCameraPointerUp
        KG.EventTriggerListener.Get(virtualCameraJoystick.gameObject).onPointerDown = OnCameraPointerDown
        KG.EventTriggerListener.Get(virtualCameraJoystick.gameObject).onDrag = OnCameraDrag
        
        attackPanel = virtualController.transform:Find("AttackPanel")
        pkgButtonMgr.AddListener(attackPanel, "NormalAttack", normalAttack)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "VirtualController", onLoadComplete)
end