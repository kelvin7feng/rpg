CIsIdle = class(BaseCondition)

function CIsIdle:ctor()

end

function CIsIdle:OnInit() 

end

function CIsIdle:OnCheck()
    self.task.isChecked = APICondition.IsIdle(self.owner)
end