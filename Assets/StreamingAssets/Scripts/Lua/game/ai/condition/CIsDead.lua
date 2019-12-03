CIsDead = class(BaseCondition)

function CIsDead:ctor()

end

function CIsDead:OnInit() 

end

function CIsDead:OnCheck()
    self.task.isChecked = APICondition.IsDead(self.owner)
end