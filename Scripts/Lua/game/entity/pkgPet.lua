
Pet = class(Character)

function Pet:ctor(paramters)
    self.dSide = paramters.dSide
    self.dMoveSpeed = paramters.dMoveSpeed or 2
    self.aiData = AIData:new()
    self.aiData.dMonsterId = paramters.dMonsterId
    pkgFSMManger.InitMonsterFSM(self)
    pkgAttrLogic.CalcMonsterAttr(self)
    pkgSysStat.SetMaxHealth(self, pkgAttrLogic.GetHpAttr(self.tbAttr))
end