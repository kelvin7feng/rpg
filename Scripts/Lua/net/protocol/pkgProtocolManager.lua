doNameSpace("pkgProtocolManager")

function Init()
    -- 玩家基本信息
    pkgEventManager.Register(EVENT_ID.CLIENT_LOGIN.LOGIN, pkgSysUser.OnLogin)

    -- 战斗
    pkgEventManager.Register(EVENT_ID.CLIENT_BATTLE.START, pkgSysBattle.OnStart)
    pkgEventManager.Register(EVENT_ID.CLIENT_BATTLE.SPAWN_MONSTER, pkgSysBattle.OnSpawnMonster)

    -- 背包
    pkgEventManager.Register(EVENT_ID.GOODS.SHOW_REWARD, pkgGoodsMgr.OnShowReward)
end