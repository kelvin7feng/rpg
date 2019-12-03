
BaseTask = class()

function BaseTask:ctor()
    self.task = nil
    self.owner = nil
    self.bIsRunning = false
end

function BaseTask:OnInit()
    
end

function BaseTask:OnStop()
    
end

function BaseTask:OnPause()
    
end

function BaseTask:OnExecute()
    
end

function BaseTask:OnUpdate()

end

function BaseTask:EndAction(bSuccess)
    self.task:EndActionLua(bSuccess)
end