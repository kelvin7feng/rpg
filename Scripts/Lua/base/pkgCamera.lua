doNameSpace("pkgCamera")

function SetFollowTarget(target)
    local camera = UnityEngine.Camera.main
    local cameraFollow = camera.gameObject:GetComponent(KG.CameraController)
    cameraFollow:SetTarget(target.transform)
    cameraFollow.currentX = target.transform.eulerAngles.y
end

function SetDeltaInput(dPitch, dYaw)
    local camera = UnityEngine.Camera.main
    local cameraFollow = camera.gameObject:GetComponent(KG.CameraController)
    cameraFollow:SetDeltaInput(dPitch, dYaw)
end