AFollowMove = class(BaseTask)

function AFollowMove:ctor(objAction)
    
end

function AFollowMove:OnInit()
    
end

function AFollowMove:OnExecute()
    local bIsOk = APIAction.FollowMove(self.owner)
    if not bIsOk then
       self:EndAction(false)
    end
end

function AFollowMove:OnUpdate()
    if APICondition.CanFollowMove(self.owner) then
        APIAction.FollowMove(self.owner)
    else
        self:EndAction(true)
    end
end

function AFollowMove:OnStop()
    
end