CIsHurt = class(BaseCondition)

function CIsHurt:ctor()

end

function CIsHurt:OnInit() 

end

function CIsHurt:OnCheck()
    self.task.isChecked = APICondition.IsHurt(self.owner)
    APIAction.ResetHurt(self.owner)
end