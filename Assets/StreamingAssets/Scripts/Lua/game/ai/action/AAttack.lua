AAttack = class(BaseTask)

function AAttack:ctor(objAction)
    
end

function AAttack:OnInit()
    
end

function AAttack:OnExecute()
    local bIsOk = APIAction.Attack(self.owner)
    if not bIsOk then
       self:EndAction(false)
    end
end

function AAttack:OnUpdate()
    if not APICondition.IsSkillEnd(self.owner) then
        self:EndAction(true)
    end
end