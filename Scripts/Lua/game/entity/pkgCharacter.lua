Character = class()

local index = 0

function Index()
    index = index + 1
    return index
end

function Character:ctor(paramters)
    self.id = Index()

    self.dSide = 0
    self.fsm = nil
    self.attackSkill = nil
    self.bComboCheck = false
    self.dComboClick = 0
    self.dMoveSpeed = 5
    self.bDie = false
    self.dAnimationMoveSpeed = 0
    self.bHurt = false

    local prefab = paramters.prefab
    local spawnPosition = paramters.spawnPosition
    local spawnRotate = paramters.spawnRotate

    local player = UnityEngine.GameObject.Instantiate(prefab)
    player.transform.position = spawnPosition
    
    local lookQuaternion = UnityEngine.Quaternion.LookRotation(spawnRotate)
    local fix = UnityEngine.Quaternion.Euler(0, lookQuaternion.eulerAngles.y, 0)
    player.transform.rotation = player.transform.rotation  * fix
    player.transform.name = self.id
    
    self.gameObject = player
    self.spawnPosition = spawnPosition
    self.spawnForward = spawnRotate
    self.transform = player.transform
    self.inputDestination = nil
    self.animator = player:GetComponent(UnityEngine.Animator)
    self.playerController = player:GetComponent(PlayerController)
    self.navMeshAgent = player:GetComponent(UnityEngine.AI.NavMeshAgent)
    self.playerController:SetPlayerId(self:GetId())
    self.stat = CharacterStat:new(self)
end

function Character:GetId()
    return self.id
end

function Character:GetSide()
    return self.dSide
end

function Character:GetSpawnPosition()
    return UnityEngine.Vector3(self.spawnPosition.x,self.spawnPosition.y,self.spawnPosition.z)
end

function Character:GetSpawnForward()
    return self.spawnForward
end

function Character:SetDie(bDie)
    self.bDie = bDie
end

function Character:SetHurt(bHurt)
    if self.bHurt == bHurt then
        return
    end
	
    self.bHurt = bHurt
end

function Character:SetNavMeshEnable(bEnable)
    self.navMeshAgent.enabled = bEnable
end