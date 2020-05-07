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

function getAchievementProcess(dAchievementType)
    local dProcess = 0
    local tbInfo = pkgUserDataManager.GetAnAchievement(dAchievementType)
    if tbInfo and tbInfo.dProcess then
        dProcess = tbInfo.dProcess
    end
    return dProcess
end

function canGetward(dId)
    local tbCfg = pkgAchievementCfgMgr.getAchievementCfg(dId)
    if not tbCfg then
        print("unlockAchievement can't find config:", dId)
        return false
    end

    local dAchievementType = tbCfg.achievementType    
    local dProcess = getAchievementProcess(dAchievementType)
    local dTarget = tbCfg.target
    if dProcess < dTarget then
        return false
    end

    return true
end

function getReward(dId)
    if not canGetward(dId) then
        return false
    end
    
    pkgSocket.SendToLogic(EVENT_ID.ACHIEVEMENT.GET_REWARD, dId)
end

function canShowRedPoint()
    local bShow = false
    local tbAchievement = getAchievement()
    if #tbAchievement > 0 then
        for _, tbInfo in pairs(tbAchievement) do
            if canGetward(tbInfo.dId) then
                bShow = true
                break
            end
        end
    end

    return bShow
end

function OnUpdateData(dAchievementType, tbAchievement)

    pkgUserDataManager.SetAnAchievement(dAchievementType, tbAchievement)

    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_ACHIEVEMENT)
end