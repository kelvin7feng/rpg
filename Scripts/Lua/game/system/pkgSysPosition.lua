doNameSpace("pkgSysPosition")

function GetCurrentRotation(player)
    return player.transform.rotation
end

function GetCurrentPos(player)
    return player.transform.position
end

function GetForwardDir(player)
    return player.transform.forward
end

function FaceToDir(player, pos, bSmooth)
    if not player or not pos then
        return
    end
    if bSmooth then
        FaceToDirSmoothly(player, pos)
    else
        player.transform:LookAt(pos)
    end
end

function FaceToDirSmoothly(player, targetPos)
    if not player or not targetPos then
        return
    end

    -- Update
    local rotation = GetCurrentRotation(player)
    local dir = targetPos - GetCurrentPos(player)
    local quaternion = UnityEngine.Quaternion.LookRotation(dir)
    UnityEngine.Quaternion.Slerp(rotation, quaternion, UnityEngine.Time.deltaTime)
end

function GetTopHeaderPos(player)
    local playerPos = GetCurrentPos(player)
    local topHeaderPos = UnityEngine.Vector3(playerPos.x, playerPos.y + GetHeight(player), playerPos.z)
    return topHeaderPos
end

-- to do
function GetHeight(player)
    return 2
end
