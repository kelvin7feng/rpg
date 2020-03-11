doNameSpace("pkgTerrianManager")

m_addPosition = UnityEngine.Vector3(50,0,0)

function OnTerrianTriggerEnter(trigger)
    if Slua.IsNull(trigger.nextTerrian) then
        LOG_ERROR(trigger.name .. " can not find next terrian")
        return
    end
    local currentLevel = trigger.transform.parent.gameObject
    local currentTerrianPos = currentLevel.transform.position
    trigger.nextTerrian.transform.position = currentTerrianPos + m_addPosition
    UpdateAllChildPosition(trigger.nextTerrian, currentTerrianPos)
end

function UpdateAllChildPosition(goParent, currentTerrianPos)
    local targetPos = currentTerrianPos + m_addPosition
    for i=0, goParent.transform.childCount - 1 do
        local goChild = goParent.transform:GetChild(i).gameObject
        goChild.transform.position = targetPos + goChild.transform.localPosition
    end
end