doNameSpace("pkgAttrLogic")

function GetAttr(tbAttr, dAttrType)
    return tbAttr[dAttrType].finalVal
end

-- 血量
function GetHpAttr(tbAttr)
    return GetAttr(tbAttr, pkgAttrMgr.AttrType.HP)
end

-- 攻击
function GetAttackAttr(tbAttr)
    return GetAttr(tbAttr, pkgAttrMgr.AttrType.ATTACK)
end

-- 防御
function GetDefendAttr(tbAttr)
    return GetAttr(tbAttr, pkgAttrMgr.AttrType.DEFEND)
end

-- 暴击率
function GetCriticalRateAttr(tbAttr)
    return GetAttr(tbAttr, pkgAttrMgr.AttrType.CRITICAL_RATE)
end

-- 暴击加成
function GetCriticalAttr(tbAttr)
    return GetAttr(tbAttr, pkgAttrMgr.AttrType.CRITICAL)
end

-- 闪避
function GetDodgeAttr(tbAttr)
    return GetAttr(tbAttr, pkgAttrMgr.AttrType.DODGE)
end

-- 命中
function GetHitRateAttr(tbAttr)
    return GetAttr(tbAttr, pkgAttrMgr.AttrType.HIT_RATE)
end

function CalcPlayerAttr(player)
    local tbAttr = pkgAttrMgr.GetDefaultAttr()

    local dLevel = pkgUserDataManager.GetLevel()
    local tbAttrList = pkgPlayerLevelCfgMgr.GetPlayerLevelCfg(dLevel)
    
    -- 计算基础属性
    tbAttr = pkgAttrMgr.CalcBaseAttr(tbAttr, {tbAttrList})
    
    -- 装备属性
    local tbEquipAttrList = pkgEquipDataMgr.GetEquipAttrList()
    LOG_TABLE(tbEquipAttrList)
    local tbAttrList = {}
    if #tbEquipAttrList > 0 then
        for _, dAttrId in ipairs(tbEquipAttrList) do
            table.insert(tbAttrList, pkgAttrCfgMgr.GetAttrCfg(dAttrId))
        end
    end

    -- 计算宠物属性
    local tbUsingPetAttrList = pkgPetDataMgr.GetUsingPetAttrList()
    if #tbUsingPetAttrList > 0 then
        for _, dAttrId in ipairs(tbUsingPetAttrList) do
            if dAttrId then
                table.insert(tbAttrList, pkgAttrCfgMgr.GetAttrCfg(dAttrId))
            end
        end
    end
    
    -- 计算最终属性
    tbAttr = pkgAttrMgr.CalcTotalAttr(tbAttr, tbAttrList)

    player.tbAttr = tbAttr
end

function CalcMonsterAttr(player)
    local tbAttr = pkgAttrMgr.GetDefaultAttr()

    local tbCfg = player.aiData:GetConfig()
    local tbAttrList = pkgAttrCfgMgr.GetAttrCfg(tbCfg.attrId)

    -- 计算基础属性
    tbAttr = pkgAttrMgr.CalcBaseAttr(tbAttr, {tbAttrList})
    
    -- 计算最终属性
    tbAttr = pkgAttrMgr.CalcTotalAttr(tbAttr, {})

    player.tbAttr = tbAttr
end

-- 目前采用瀑布计算流程
-- 1.攻防血采用减法
-- 2.命中闪避采用除法
function CalcOneAttack(attackAttr, defenderAttr)
    
    local dCritical = 1.5
    local bIsCritical = false
    local dAttack = GetAttackAttr(attackAttr)
    local dDefend = GetDefendAttr(defenderAttr)
    local dDamage = math.max(dAttack - dDefend, 1)

    local dHitRate = GetHitRateAttr(attackAttr)
    local dDodge = GetDodgeAttr(attackAttr)
    local dHitResult = dHitRate/(dHitRate + dDodge) * 100
    local bHit =  dHitResult >= math.random(1, 100) and true or false
    
    if bHit then
        local dCriticalRate = GetCriticalRateAttr(attackAttr)
        if dCriticalRate > 0 then
            bIsCritical = dCriticalRate >= math.random(1, 100) and true or false
            if bIsCritical then
                dCritical = GetCriticalAttr(attackAttr)
                dDamage = dDamage * dCritical
            end
        end
    end

    dDamage = math.max(math.floor(dDamage),1)

    return bHit, dDamage, bIsCritical, dCritical
end