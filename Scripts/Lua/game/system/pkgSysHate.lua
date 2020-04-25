doNameSpace("pkgSysHate")

local addHate = function(tbEnemyInfo, dHate)
	-- print(string.format("%d, add hate: %.2f + %.2f = %.2f", tbEnemyInfo.id, tbEnemyInfo.hate, dHate, tbEnemyInfo.hate + dHate))
	tbEnemyInfo.hate = tbEnemyInfo.hate + dHate
end

local hateSortFunc = function(a, b)
	if a == nil or b == nil then 
		return false 
	end 
	if a.hate ~= b.hate then
		return a.hate > b.hate
	end
	return false
end

function CalcHate(dAgentId, dId, dHate)
	return dHate
end

function AddHate(agent, dId, dHate)
	local enemy = pkgActorManager.GetActor(dId)
	if not pkgActorManager.IsEnemy(agent, enemy) then
		print_w(agent:GetId(), " and ", dId , " are friend.")
		return false
	end
	
	if not pkgActorManager.IsAIPlayer(agent) then
		return false
	end

	local dFinalHate = CalcHate(enemy, dId, dHate)
	local tbEnemyInfo = GetHatedEnemyInfoById(agent, dId)
	if tbEnemyInfo then
		addHate(tbEnemyInfo, dFinalHate)
	else
		agent.aiData:AddHateEnemy(dId, dFinalHate)
	end

	SortHateRank(agent, dId)

	UpdateTargetEnemy(agent)

	-- PrintHateList(agent)
end

function SortHateRank(agent, dId)

	if agent.aiData:GetHateListCount() <= 1 then
		return
	end

	local targetEnemy = agent.aiData:GetTargetEnemy()
	local dTargetId = targetEnemy:GetId()
	if dTargetId == dId then
		return
	end	
	
	local sortFunc = hateSortFunc	
	if sortFunc and agent.aiData:GetHateListCount() > 1 then
		table.sort(agent.aiData.tbHateList, hateSortFunc)
	end
end

function GetMostHatedEnemy(agent)

	local mostHatedEnemy = nil
	if agent.aiData:GetHateListCount() > 0 then
		local id = agent.aiData:GetHateEnemyByIndex(1)
		mostHatedEnemy = pkgActorManager.GetActor(id)
	end

	return mostHatedEnemy
end

function DoesExistEnemy(agent, id)
	local bExist = false
	local dIndex = nil
	local dCount = agent.aiData:GetHateListCount()
	if dCount > 0 then
		for i=1, dCount do
			local dMonsterId = agent.aiData:GetHateEnemyByIndex(i)
			if dMonsterId == id then
				dIndex = i
				bExist = true
				break
			end
		end
	end

	return bExist,dIndex
end

function GetHatedEnemyInfoById(agent, id)
	local tbEnemy = nil
	if not pkgActorManager.IsAIPlayer(agent) then
		return
	end
	local dCount = agent.aiData:GetHateListCount()
	if dCount > 0 then
		for i=1, dCount do
			local dHateEnemy = agent.aiData:GetHateEnemyInfoByIndex(i)
			if dHateEnemy.id == id then
				tbEnemy = dHateEnemy
				break
			end
		end
	end

	return tbEnemy
end

function RemoveEnemy(agent, id)

	local dTempHateCount = agent.aiData:GetHateListCount()

	local bIsOk = RemoveEnemyFromHateListById(agent, id)

	if bIsOk then
		if dTempHateCount > 0 and agent.aiData:GetHateListCount() <= 0 
			and not agent.aiData.bInterruptByHate then
				agent.aiData.bInterruptByHate = true
		end
	end
end

function RemoveEnemyFromHateListById(agent, dId)
	local bIsOk = false
	local bExist,dIndex = DoesExistEnemy(agent, dId)
	if bExist then
		agent.aiData:RemoveEnemyFromHatedList(dIndex)
		bIsOk = true
	end
	return bIsOk
end

function NeedToChangeTarget(agent)
	local bNeed = false
	local targetEnemy = agent.aiData:GetTargetEnemy()
	if not targetEnemy then
		bNeed = true
		return bNeed
	end

	local dTargetId = targetEnemy:GetId()
	if APICondition.IsDead(targetEnemy) then
		RemoveEnemy(agent, dTargetId)
		bNeed = true
		return bNeed
	end

	if agent.aiData:GetHateListCount() > 1 then
		local tbMostHatedEnemy = GetMostHatedEnemy(agent)
		local dMostHatedEnemyId = tbMostHatedEnemy:GetId()
		if dTargetId ~= dMostHatedEnemyId then		
			local mostHatedEnemy = GetHatedEnemyInfoById(agent, dMostHatedEnemyId)
			if mostHatedEnemy then
				local targetHatedEnemy = GetHatedEnemyInfoById(agent, dTargetId)
				if mostHatedEnemy.hate / targetHatedEnemy.hate > 1.2 then
					bNeed = true
				end
			else
				RemoveEnemy(agent, dMostHatedEnemyId)
				bNeed = true
			end
		end
	end

	return bNeed
end

function UpdateTargetEnemy(agent)

	local dCount = agent.aiData:GetHateListCount()
	if dCount > 0 then
		local bNeed = NeedToChangeTarget(agent)
		if bNeed then
			local mostHatedEnemy = GetMostHatedEnemy(agent)
			if mostHatedEnemy then
				agent.aiData:SetTargetEnemy(mostHatedEnemy)
			end
		end
	end
end

function ClearHateList(agent)
	agent.aiData.tbHateList = {}
	agent.aiData:SetTargetEnemy(nil)
end

function PrintHateList(agent)
	if agent.aiData then
		LOG_TABLE(agent.aiData.tbHateList)
	else
		print("agent is not ai")
	end
end