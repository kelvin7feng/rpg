AChaseTarget = class(BaseTask)

function AChaseTarget:ctor(objAction)
    
end

function AChaseTarget:OnInit()
    
end

function AChaseTarget:OnExecute()
    local bIsOk = APIAction.ChaseTarget(self.owner)
    if not bIsOk then
       self:EndAction(false)
    end
end

function AChaseTarget:OnUpdate()
    if APICondition.EndMove(self.owner) then
        self:EndAction(true)
    else
        APIAction.UpdateMoveDestination(self.owner)
    end
end

function AChaseTarget:OnStop()
    
end