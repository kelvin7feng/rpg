CharacterStat = class()

function CharacterStat:ctor(owner)
    self.owner = owner
    self.maxHealth = nil
    self.dCurrentHealth = 0
end

function CharacterStat:TakeDamage(dDamage)

    if self.dCurrentHealth <= 0 then
        print("I am died")
        return
    end

    dDamage = math.max(0, dDamage)
    if dDamage > self.dCurrentHealth then
        dDamage = self.dCurrentHealth
    end

    self.dCurrentHealth = self.dCurrentHealth - dDamage
    print("take damage:", dDamage)
    if self.dCurrentHealth <= 0 then
        print("die")
        self.owner:SetDie(true)

        if pkgActorManager.IsMonster(self.owner) then
            pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.KILL_MONSTER, pkgSysBattle.GetCurrentLevel())
        end
    end
end