CharacterStat = class()

function CharacterStat:ctor(owner)
    self.owner = owner
    self.maxHealth = nil
    self.dCurrentHealth = 0
end

function CharacterStat:TakeDamage(dDamage)

    if self.dCurrentHealth <= 0 then
        LOG_DEBUG("I am died")
        return
    end

    dDamage = math.max(0, dDamage)
    if dDamage > self.dCurrentHealth then
        dDamage = self.dCurrentHealth
    end

    self.dCurrentHealth = self.dCurrentHealth - dDamage
    LOG_DEBUG("take damage:", dDamage)
    if self.dCurrentHealth <= 0 then
        LOG_DEBUG("die")
        self.owner:SetDie(true)

        if pkgActorManager.IsMonster(self.owner) then
            pkgEventManager.PostEvent(CLIENT_EVENT.MONSTER_DEAD, self.owner)
        end
    end
end