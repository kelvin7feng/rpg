CIsPause = class(BaseCondition)

function CIsPause:ctor()

end

function CIsPause:OnInit() 

end

function CIsPause:OnCheck()
    self.task.isChecked = APICondition.IsPause(self.owner)
end