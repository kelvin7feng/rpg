
Player = class(Character)

function Player:ctor(paramters)
    self.dSide = 1
    pkgFSMManger.InitPlayerFSM(self)
    pkgSysStat.SetMaxHealth(self, 100)
end