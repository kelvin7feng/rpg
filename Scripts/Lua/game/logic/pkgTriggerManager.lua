
doNameSpace("pkgTriggerManager")

function Init()
    pkgEventManager.Register(pkgEventDefination.TriggerEvent.MONSTER_TRIGGER_ENTER, pkgSysMonster.OnTriggerMonster)
    pkgEventManager.Register(pkgEventDefination.TriggerEvent.TERRIAN_TRIGGER_ENTER, pkgTerrianManager.OnTerrianTriggerEnter)
end

function OnTriggerEnter(otherCollider, trigger, triggerName)
    local strEvent = string.format( "%s", triggerName)
	--LOG_DEBUG("pkgTriggerManager.OnTriggerEnter otherColliderName:" .. otherCollider.name..",triggerName:" .. triggerName..",strEvent:" .. strEvent)
	pkgEventManager.PostEvent(strEvent, trigger)
end

function OnTriggerExit(otherCollider, trigger, triggerName)
    local strEvent = string.format( "%s", triggerName)
    --LOG_DEBUG("pkgTriggerManager.OnTriggerExit otherColliderName:" .. otherCollider.name..",triggerName:" .. triggerName..",strEvent:" .. strEvent)
end