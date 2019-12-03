Stat = class()

function Stat:ctor(dBaseValue)
    self.dBaseValue = dBaseValue or 0
    self.tbModifiers = {}
end

function Stat:GetValue()
    local dFinalValue = self.dBaseValue
    for dKey, dVal in pairs(self.tbModifiers) do
        dFinalValue = dFinalValue + dVal
    end

    return dFinalValue
end

function Stat:AddModifier(dKey, dVal)
    self.tbModifiers[dKey] = dVal
end

function Stat:RemoveModifier(dKey)
    self.tbModifiers[dKey] = nil
end