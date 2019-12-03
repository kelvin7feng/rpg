AIdle = class(BaseTask)

function AIdle:ctor(objAction)
    
end

function AIdle:OnInit()
    
end

function AIdle:OnExecute()
    
end

function AIdle:OnUpdate()
    self:EndAction(true)
end