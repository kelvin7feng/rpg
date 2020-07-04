doNameSpace("pkgTaskMgr")

function OnUpdateTaskInfo(dTaskType, tbTaskInfo)
    
    if not dTaskType or not tbTaskInfo then
        return false
    end
    
    pkgTaskDataMgr.SetTaskByType(dTaskType, tbTaskInfo)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_UPDATE_TASK_INFO, dTaskType, tbTaskInfo)
end

function OnUpdateOneTask(dTaskType, dTaskId, tbTaskInfo, dLiveness, dState)

    if not dTaskType or not dTaskId or not tbTaskInfo or not dLiveness then
        return false
    end
    
    pkgTaskDataMgr.SetTaskInfoById(dTaskType, dTaskId, tbTaskInfo)
    pkgTaskDataMgr.AddTaskLivenessById(dTaskType, dTaskId, dLiveness)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_UPDATE_ONE_TASK, dTaskType, dTaskId)
    
    return true
end

function OnUpdateProgress(dTaskType, dTaskId, dProgress)
    
    if not dTaskType or not dTaskId or not dProgress then
        return false
    end
    
    pkgTaskDataMgr.SetTaskProgressById(dTaskType, dTaskId, dProgress)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_UPDATE_ONE_TASK, dTaskType, dTaskId)
    
    return true
end

function OnUpdateLiveness(dTaskType, dLiveness, tbLivenessReward)
    
    if not dTaskType or not dLiveness then
        return false
    end
    
    pkgTaskDataMgr.SetTaskLivenessReward(dTaskType, dLiveness, tbLivenessReward)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_UPDATE_LIVENESS, dTaskType, dLiveness, tbLivenessReward)
    
    return true
end

function GetReward(dTaskType, dTaskId)
    if not dTaskType or not dTaskId then
        return false
    end

    pkgSocket.SendToLogic(EVENT_ID.TASK.GET_REWARD, dTaskType, dTaskId)
end

function GetLivenessRewardState(dTaskType, dLiveness)
    local tbTaskInfo = pkgTaskDataMgr.GetTaskByType(dTaskType)
    local dLivenessCount = tbTaskInfo.dLiveness
    
    if dLivenessCount < dLiveness then
        return pkgTaskCfgMgr.LivenessState.NOT_ENOUGH
    end

    if tbTaskInfo.tbLivenessReward[tostring(dLiveness)] then
        return pkgTaskCfgMgr.LivenessState.GOT
    end

    return pkgTaskCfgMgr.LivenessState.CAN_GET
end

function CanGetTaskReward(dTaskType, tbTask)
    local tbCfg = pkgTaskCfgMgr.GetTaskCfgById(dTaskType, tbTask.dId)
    if tbTask.dState == pkgTaskCfgMgr.TaskState.DOING 
        and tbTask.dProgress >= tbCfg.target then
        return true
    end

    return false
end

function CanGetLivenessReward(dTaskType, dLiveness)
    local dLivenessState = pkgTaskMgr.GetLivenessRewardState(dTaskType, dLiveness)
    if dLivenessState == pkgTaskCfgMgr.LivenessState.CAN_GET then
        return true
    end

    return false
end

function CanShowDailyTaskRedPoint()
    local bShow = false
    local dTaskType = pkgTaskCfgMgr.TaskType.DAILY
    local tbTaskData = pkgTaskDataMgr.GetTaskListByType(dTaskType)
    for i, tbTask in ipairs(tbTaskData) do
        if CanGetTaskReward(dTaskType, tbTask) then
            bShow = true
            break
        end
    end

    local tbLivenessRewardCfg = pkgTaskCfgMgr.GetLivenessRewardList(dTaskType)
    for _, tbCfg in ipairs(tbLivenessRewardCfg) do
        local dLiveness = tbCfg.liveness
        if CanGetLivenessReward(dTaskType, dLiveness) then
            bShow = true
            break
        end
    end

    return bShow
end

function CanShowWeeklyTaskRedPoint()
    local bShow = false
    local dTaskType = pkgTaskCfgMgr.TaskType.WEEKLY
    local tbTaskData = pkgTaskDataMgr.GetTaskListByType(dTaskType)
    for i, tbTask in ipairs(tbTaskData) do
        if CanGetTaskReward(dTaskType, tbTask) then
            bShow = true
            break
        end
    end

    local tbLivenessRewardCfg = pkgTaskCfgMgr.GetLivenessRewardList(dTaskType)
    for _, tbCfg in ipairs(tbLivenessRewardCfg) do
        local dLiveness = tbCfg.liveness
        if CanGetLivenessReward(dTaskType, dLiveness) then
            bShow = true
            break
        end
    end

    return bShow
end