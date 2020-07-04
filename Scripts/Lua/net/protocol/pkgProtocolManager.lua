doNameSpace("pkgProtocolManager")

function Init()

    -- 网络
    pkgEventManager.Register(EVENT_ID.NET.RECONNECTED_FAILED, pkgNetMgr.OnReconnectFailed)
    pkgEventManager.Register(EVENT_ID.NET.HEART_BEAT_2, pkgHeartbeatMgr.OnHeartbeat)
    
    -- 玩家基本信息
    pkgEventManager.Register(EVENT_ID.CLIENT_LOGIN.LOGIN, pkgSysUser.OnLogin)
    pkgEventManager.Register(EVENT_ID.BASE_INFO.ON_LEVEL_CHANGE, pkgSysUser.OnLevelChange)
    pkgEventManager.Register(EVENT_ID.NET.RECONNECTED_SUCCEED, pkgSysUser.OnReconnect)
    pkgEventManager.Register(EVENT_ID.CLIENT_LOGIN.ON_RELOGIN, pkgSysUser.OnRelogin)

    -- 战斗
    pkgEventManager.Register(EVENT_ID.CLIENT_BATTLE.START, pkgSysBattle.OnStart)
    pkgEventManager.Register(EVENT_ID.CLIENT_BATTLE.SPAWN_MONSTER, pkgSysBattle.OnSpawnMonster)
    pkgEventManager.Register(EVENT_ID.CLIENT_BATTLE.UPDATE_CUR_LEVEL, pkgSysBattle.OnUpdateBattleLevel)

    -- 背包
    pkgEventManager.Register(EVENT_ID.GOODS.UPDATE_DATA, pkgGoodsMgr.OnUpdateData)
    pkgEventManager.Register(EVENT_ID.GOODS.SHOW_REWARD, pkgGoodsMgr.OnShowReward)

    -- 装备
    pkgEventManager.Register(EVENT_ID.EQUIP.UPDATE_DATA, pkgEquipMgr.OnUpdateData)
    pkgEventManager.Register(EVENT_ID.EQUIP.DELETE_EQUIP, pkgEquipMgr.OnDeleteEquip)
    pkgEventManager.Register(EVENT_ID.EQUIP.ON_WEAR_EQUIP, pkgEquipMgr.OnWearEquip)
    pkgEventManager.Register(EVENT_ID.EQUIP.ON_TAKE_OFF, pkgEquipMgr.OnTakeOff)
    pkgEventManager.Register(EVENT_ID.EQUIP.ON_LEVEL_UP, pkgEquipMgr.OnLevelUp)

    -- 成就系统
    pkgEventManager.Register(EVENT_ID.ACHIEVEMENT.ON_UPDATE_ACHIEVEMENT, pkgAchievementMgr.OnUpdateData)
    pkgEventManager.Register(EVENT_ID.ACHIEVEMENT.UPDATE_ONE_ACHIEVEMENT, pkgAchievementMgr.OnUpdateOneAchievement)

    -- 房子
    pkgEventManager.Register(EVENT_ID.HOME.ON_LEVEL_UP, pkgHouseMgr.OnLevelUp)
    pkgEventManager.Register(EVENT_ID.HOME.ON_UPGRADE, pkgHouseMgr.OnUpgrade)
    pkgEventManager.Register(EVENT_ID.HOME.ON_ERROR, pkgHouseMgr.OnError)

    -- 花园
    pkgEventManager.Register(EVENT_ID.CROPLAND.ON_PLANT, pkgCroplandMgr.OnPlant)

    -- 收藏
    pkgEventManager.Register(EVENT_ID.COLLECTION.ON_COLLECT_NEW, pkgCollectionMgr.OnCollectNew)

    -- 商店
    pkgEventManager.Register(EVENT_ID.SHOP.ON_UPDATE_SHOP_INFO, pkgShopMgr.OnUpdateShopInfo)
    pkgEventManager.Register(EVENT_ID.SHOP.ON_BUY_GOODS, pkgShopMgr.OnBuyGoods)
    pkgEventManager.Register(EVENT_ID.SHOP.ON_BUY_PET, pkgShopMgr.OnBuyPet)
    
    -- 挂机
    pkgEventManager.Register(EVENT_ID.AFK.ON_GET_REWARD, pkgAFKMgr.OnGetReward)

    -- 宠物
    pkgEventManager.Register(EVENT_ID.PET.ON_BATTLE, pkgPetLogic.OnPetBattle)
    pkgEventManager.Register(EVENT_ID.PET.ON_REST, pkgPetLogic.OnPetRest)

    -- 引导
    pkgEventManager.Register(EVENT_ID.GUIDE.ON_FINISH, pkgGuideMgr.OnFinish)

    -- 任务
    pkgEventManager.Register(EVENT_ID.TASK.ON_UPDATE_TASK_INFO, pkgTaskMgr.OnUpdateTaskInfo)
    pkgEventManager.Register(EVENT_ID.TASK.ON_ONE_TASK_INFO, pkgTaskMgr.OnUpdateOneTask)
    pkgEventManager.Register(EVENT_ID.TASK.ON_UPDATE_PROGRESS, pkgTaskMgr.OnUpdateProgress)
    pkgEventManager.Register(EVENT_ID.TASK.ON_UPDATE_LIVENESS, pkgTaskMgr.OnUpdateLiveness)
    
end