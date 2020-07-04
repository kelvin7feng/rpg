doNameSpace("pkgTaskDataMgr")

local sortDailyByDefault = function(a, b)
	if a == nil or b == nil then 
		return false 
    end
    local cfg1 = pkgTaskCfgMgr.GetDailyCfgById(a.dId)
    local cfg2 = pkgTaskCfgMgr.GetDailyCfgById(b.dId)
    local dProgress1 = a.dProgress/cfg1.target
    local dProgress2 = b.dProgress/cfg2.target
    local dState1 = a.dState
    local dState2 = b.dState
    if dState1 ~= dState2 then
        if dState1 == pkgTaskCfgMgr.TaskState.DONE then
            return false
        else
            return true
        end
    elseif dProgress1 ~= dProgress2 then
        return dProgress1 > dProgress2
    elseif cfg1.order ~= cfg2.order then
        return cfg1.order < cfg2.order
    else
        return cfg1.id > cfg2.id
    end
end

local sortWeeklyByDefault = function(a, b)
	if a == nil or b == nil then 
		return false 
    end
    local cfg1 = pkgTaskCfgMgr.GetWeeklyCfgById(a.dId)
    local cfg2 = pkgTaskCfgMgr.GetWeeklyCfgById(b.dId)
    local dProgress1 = a.dProgress/cfg1.target
    local dProgress2 = b.dProgress/cfg2.target
    local dState1 = a.dState
    local dState2 = b.dState
    if dState1 ~= dState2 then
        if dState1 == pkgTaskCfgMgr.TaskState.DONE then
            return false
        else
            return true
        end
    elseif dProgress1 ~= dProgress2 then
        return dProgress1 > dProgress2
    elseif cfg1.order ~= cfg2.order then
        return cfg1.order < cfg2.order
    else
        return cfg1.id > cfg2.id
    end
end

function GetTask()
    local tbTaskInfo = pkgUserDataManager.GetGameTable(GAME_DATA_TABLE_NAME.TASK_INFO)
    return tbTaskInfo
end

function GetDailyTask()
    local tbTaskInfo = GetTask()
    return tbTaskInfo.tbDaily
end

function SetDailyTask(tbDailyTask)
    if not tbDailyTask then
        return false
    end

    local tbTaskInfo = GetTask()
    tbTaskInfo.tbDaily = tbDailyTask

    return true
end

function GetWeeklyTask()
    local tbTaskInfo = GetTask()
    return tbTaskInfo.tbWeekly
end

function SetWeeklyTask(tbWeeklyTask)
    if not tbWeeklyTask then
        return false
    end

    local tbTaskInfo = GetTask()
    tbTaskInfo.tbWeekly = tbWeeklyTask

    return true
end

function GetTaskByType(dTaskType)
    local tbTaskInfo = nil
    if dTaskType == pkgTaskCfgMgr.TaskType.DAILY then
        tbTaskInfo = GetDailyTask()
    elseif dTaskType == pkgTaskCfgMgr.TaskType.WEEKLY then
        tbTaskInfo = GetWeeklyTask()
    end

    return tbTaskInfo
end

function SetTaskByType(dTaskType, tbTaskInfo)
    if not dTaskType or not tbTaskInfo then
        return false
    end
    if dTaskType == pkgTaskCfgMgr.TaskType.DAILY then
        SetDailyTask(tbTaskInfo)
    elseif dTaskType == pkgTaskCfgMgr.TaskType.WEEKLY then
        SetWeeklyTask(tbTaskInfo)
    else
        return false
    end

    return true
end

function GetTaskListByType(dTaskType)
    local tbTaskInfo = GetTaskByType(dTaskType)

    local tbList = {}
    for _, tbTask in pairs(tbTaskInfo.tbTaskList) do
        table.insert(tbList, tbTask)
    end

    if dTaskType == pkgTaskCfgMgr.TaskType.DAILY then
        table.sort(tbList, sortDailyByDefault)
    elseif dTaskType == pkgTaskCfgMgr.TaskType.WEEKLY then
        table.sort(tbList, sortWeeklyByDefault)
    end

    return tbList
end

function GetTaskInfoById(dTaskType, dId)
    if not dTaskType or not dId then
        return false
    end

    local tbTaskInfo = GetTaskByType(dTaskType)
    return tbTaskInfo.tbTaskList[tostring(dId)]
end

function SetTaskInfoById(dTaskType, dId, tbTask)
    if not dTaskType or not dId or not tbTask then
        return false
    end

    local tbTaskInfo = GetTaskByType(dTaskType)
    if not tbTaskInfo.tbTaskList[tostring(dId)] then
        return false
    end

    tbTaskInfo.tbTaskList[tostring(dId)] = tbTask

    return true
end

function SetTaskStateById(dTaskType, dId, dState)
    if not dTaskType or not dId or not tbTask then
        return false
    end

    local tbTaskInfo = GetTaskByType(dTaskType)
    if not tbTaskInfo.tbTaskList[tostring(dId)] then
        return false
    end

    tbTaskInfo.tbTaskList[tostring(dId)].dState = dState

    return true
end

function AddTaskLivenessById(dTaskType, dId, dLiveness)
    if not dTaskType or not dId or not dLiveness then
        return false
    end

    local tbTaskInfo = GetTaskByType(dTaskType)
    if not tbTaskInfo.tbTaskList[tostring(dId)] then
        return false
    end

    tbTaskInfo.dLiveness = tbTaskInfo.dLiveness + dLiveness

    return true
end

function GetTaskLiveness(dTaskType)
    if not dTaskType or not dId or not dLiveness then
        return false
    end

    local tbTaskInfo = GetTaskByType(dTaskType)
    if not tbTaskInfo then
        return false
    end

    return tbTaskInfo.dLiveness
end

function SetTaskLivenessReward(dTaskType, dLiveness, tbLivenessReward)
    
    if not dTaskType or not dLiveness or not tbLivenessReward then
        return false
    end
    
    local tbTaskInfo = GetTaskByType(dTaskType)
    if not tbTaskInfo then
        return false
    end
    
    tbTaskInfo.tbLivenessReward[tostring(dLiveness)] = tbLivenessReward
    
    return true
end

function SetTaskProgressById(dTaskType, dId, dProgress)
    
    if not dTaskType or not dId or not dProgress then
        return false
    end
    
    local tbTaskInfo = GetTaskByType(dTaskType)
    if not tbTaskInfo.tbTaskList[tostring(dId)] then
        return false
    end
    
    tbTaskInfo.tbTaskList[tostring(dId)].dProgress = dProgress

    return true
end