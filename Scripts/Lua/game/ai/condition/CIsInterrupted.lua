CIsInterrupted = class(BaseCondition)

function CIsInterrupted:ctor()

end

function CIsInterrupted:OnInit() 

end

function CIsInterrupted:OnCheck()
    self.task.isChecked = APICondition.CanInterrupt(self.owner)
    APIAction.ResetInterrupt(self.owner)
end