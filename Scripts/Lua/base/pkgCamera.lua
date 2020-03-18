doNameSpace("pkgCamera")

function InitCameraParamters(cameraFollow)
    cameraFollow.currentX = 3
    cameraFollow.currentY = 0
    cameraFollow.distance = 16.25
    cameraFollow.focusUpDelta = 4.8
    cameraFollow.focusForwardDelta = 0.88
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