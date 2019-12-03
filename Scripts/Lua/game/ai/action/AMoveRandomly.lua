AMoveRandomly = class(BaseTask)

function AMoveRandomly:ctor(objAction)
    
end

function AMoveRandomly:OnInit()
    
end

function AMoveRandomly:OnExecute()
    local bIsOk = APIAction.MoveRandomly(self.owner)
    if not bIsOk then
        self:EndAction(false)
    end
end

function AMoveRandomly:OnUpdate()
    if APICondition.EndMove(self.owner) then
        self:EndAction(true)
    end
end

function AMoveRandomly:OnStop()
    
end
