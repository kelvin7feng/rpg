doNameSpace("pkgAchievementMgr")

local sortByDefault = function(a, b)
	if a == nil or b == nil then 
		return false 
    end
    local cfg1 = pkgAchievementCfgMgr.getAchievementCfg(a.dId)
    local cfg2 = pkgAchievementCfgMgr.getAchievementCfg(b.dId)
    local dProcess1 = a.dProcess/cfg1.target
    local dProcess2 = b.dProcess/cfg2.target
    if dProcess1 ~= dProcess2 then
        return dProcess1 > dProcess2
    else
        return cfg1.id > cfg2.id
    end
end

function getAchievement()
    local tb = pkgUserDataManager.GetAllAchievement()

    table.sort(tb, sortByDefault)

    return tb
end

-- to do
function canGetward()
    return true
end

function getReward(dId)
    if not canGetward(dId) then
        return false
    end
    
    pkgSocket.SendToLogic(EVENT_ID.ACHIEVEMENT.GET_REWARD, dId)
end

function OnUpdateData(dAchievementType, tbAchievement)

    pkgUserDataManager.SetAnAchievement(dAchievementType, tbAchievement)

    pkgEventManager.PostEvent(CLIENT_EVENT.UPDATE_ACHIEVEMENT)
end