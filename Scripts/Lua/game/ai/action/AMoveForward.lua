AMoveForward = class(BaseTask)

function AMoveForward:ctor(objAction)
    
end

function AMoveForward:OnInit()
    
end

function AMoveForward:OnExecute()
    local bIsOk = APIAction.MoveForward(self.owner)
    if not bIsOk then
        self:EndAction(false)
    end
end

function AMoveForward:OnUpdate()
    if APICondition.EndMove(self.owner) then
        self:EndAction(true)
    else
        APIAction.MoveForward(self.owner)
    end
end

function AMoveForward:OnStop()
    
end
