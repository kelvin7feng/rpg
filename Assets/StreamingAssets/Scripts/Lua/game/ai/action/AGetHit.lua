AGetHit = class(BaseTask)

function AGetHit:ctor(objAction)
    
end

function AGetHit:OnInit()
    
end

function AGetHit:OnExecute()
    local bIsOk = APIAction.GetHit(self.owner)
    if not bIsOk then
       self:EndAction(false)
    end
end

function AGetHit:OnUpdate()
    if not APICondition.IsHurt(self.owner) then
        self:EndAction(true)
    end
end