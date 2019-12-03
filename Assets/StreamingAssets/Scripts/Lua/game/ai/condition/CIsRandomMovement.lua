CIsRandomMovement = class(BaseCondition)

function CIsRandomMovement:ctor()

end

function CIsRandomMovement:OnInit() 

end

function CIsRandomMovement:OnCheck()
    self.task.isChecked = APICondition.IsRandomMovement(self.owner)
end