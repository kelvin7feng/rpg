
AIData = class()

function AIData:ctor(paramters)
    self.behaviourTreeOwner = nil
    self.bIsHurt = false
    self.bIsPause = false
    self.tbHateList = {}
    self.targetEnemy = nil
    self.bInterruptByHate = false
end

function AIData:SetPause(bIsPause)
    self.bIsPause = bIsPause
end

function AIData:GetHateListCount()
    return #self.tbHateList
end

function AIData:GetHateEnemyInfoByIndex(dIndex)
    local tbEnemyInfo = nil
    if self.tbHateList[dIndex] then
        tbEnemyInfo = self.tbHateList[dIndex]
    end
    return tbEnemyInfo
end

function AIData:AddHateEnemy(dId, dFinalHate)
    local tbEnemyInfo = {id = dId, hate = dFinalHate}
    table.insert(self.tbHateList, tbEnemyInfo)
end

function AIData:GetTargetEnemy()
    return self.targetEnemy
end

function AIData:SetTargetEnemy(targetEnemy)
    self.targetEnemy = targetEnemy
end

function AIData:GetHateEnemyByIndex(dIndex)
    local dId = nil
    local tbEnemyInfo = self:GetHateEnemyInfoByIndex(dIndex)
    if tbEnemyInfo then
        dId = tbEnemyInfo.id
    end

    return dId
end

function AIData:RemoveEnemyFromHatedList(dIndex)
    if self.tbHateList[dIndex] then
        table.remove(self.tbHateList, dIndex)
    end
end

function AIData:GetConfig()
    local tbConfig = _cfg.monster[self.dMonsterId]
    if not tbConfig then
        return nil
    end

    return tbConfig
end

function AIData:GetFieldConfig(strField)
    local tbConfig = _cfg.monster[self.dMonsterId]
    if not tbConfig then
        return nil
    end

    return tbConfig[strField]
end