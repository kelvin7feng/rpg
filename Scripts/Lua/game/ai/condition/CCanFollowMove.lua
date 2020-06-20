CCanFollowMove = class(BaseCondition)

function CCanFollowMove:ctor()

end

function CCanFollowMove:OnInit() 

end

function CCanFollowMove:OnCheck()
    self.task.isChecked = APICondition.CanFollowMove(self.owner)
end