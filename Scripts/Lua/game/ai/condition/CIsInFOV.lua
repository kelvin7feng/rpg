CIsInFOV = class(BaseCondition)

function CIsInFOV:ctor()

end

function CIsInFOV:OnInit() 

end

function CIsInFOV:OnCheck()
    self.task.isChecked = APICondition.IsInFOV(self.owner)
end