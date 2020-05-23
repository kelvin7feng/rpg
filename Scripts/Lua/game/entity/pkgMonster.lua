
Monster = class(Character)

function Monster:ctor(paramters)
    self.dSide = 2
    self.dMoveSpeed = 2
    self.aiData = AIData:new()
    self.aiData.dMonsterId = paramters.dMonsterId
    pkgFSMManger.InitMonsterFSM(self)
    pkgAttrLogic.CalcMonsterAttr(self)
    pkgSysStat.SetMaxHealth(self, pkgAttrLogic.GetHpAttr(self.tbAttr))
end