doNameSpace("pkgPositionTool")

function AngleSigned(v1, v2)
    local dAngle = UnityEngine.Vector3.Angle(v1, v2);
    local cross = UnityEngine.Vector3.Cross(v1, v2);
    if cross.y < 0 then
    
        dAngle = -dAngle;
    end
    return dAngle
end

function GetPosOnGround(startPos)
    startPos.y = startPos.y + 1
    local layerMask = KG.Layer.MASK_FOR_GROUND

    local bIsOk, tbHitInfo = UnityEngine.Physics.Raycast(startPos, UnityEngine.Vector3.down, Slua.out, UnityEngine.Mathf.Infinity, layerMask)
    if bIsOk then
        startPos = tbHitInfo.point
    end

    local bFind, tbNavMeshHit = UnityEngine.AI.NavMesh.SamplePosition(startPos, Slua.out, 1, KG.AreaMask.MASK_FOR_WALKABLE)
    if bFind then
        startPos = tbNavMeshHit.position
    end
    
    return startPos
end

function ObstacleBetweenTwoPoints(startPos, endPos, layerMask) 
	local dirToTarget = (endPos - startPos).normalized
	local dDstToTarget = UnityEngine.Vector3.Distance(endPos, startPos)
	local bIsOk, hitInfo = UnityEngine.Physics.Raycast(startPos, dirToTarget, Slua.out, dDstToTarget, layerMask)
	return bIsOk, hitInfo
end