doNameSpace("pkgCamera")

function InitCameraParamters(cameraFollow)
    cameraFollow.currentX = 12
    cameraFollow.currentY = 15
    cameraFollow.distance = 10
    cameraFollow.focusUpDelta = 1.95
    cameraFollow.focusForwardDelta = 1
end

function SetFollowTarget(target)
    local camera = UnityEngine.Camera.main
    local cameraFollow = camera.gameObject:GetComponent(KG.CameraController)
    cameraFollow:SetTarget(target.transform)
    -- 初始化跟着主角后面
    -- cameraFollow.currentX = target.transform.eulerAngles.y
    -- 初始化跟着右侧
    InitCameraParamters(cameraFollow)
end

function SetDeltaInput(dPitch, dYaw)
    local camera = UnityEngine.Camera.main
    local cameraFollow = camera.gameObject:GetComponent(KG.CameraController)
    cameraFollow:SetDeltaInput(dPitch, dYaw)
end