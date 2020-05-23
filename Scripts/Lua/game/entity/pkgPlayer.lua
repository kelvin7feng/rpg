
Player = class(Character)

function Player:ctor(paramters)
    self.dSide = 1
    self.dMoveSpeed = 2
    self.aiData = AIData:new()
    self.aiData.dMonsterId = 1
    pkgSysAI.SetPause(self, true)
    pkgFSMManger.InitPlayerFSM(self)
    pkgAttrLogic.CalcPlayerAttr(self)
    pkgSysStat.SetMaxHealth(self, pkgAttrLogic.GetHpAttr(self.tbAttr))
end