CIsGreatThanDistanceOfAttack = class(BaseCondition)

function CIsGreatThanDistanceOfAttack:ctor()

end

function CIsGreatThanDistanceOfAttack:OnInit() 

end

function CIsGreatThanDistanceOfAttack:OnCheck()
    self.task.isChecked = APICondition.IsGreatThanDistanceOfAttack(self.owner)
end