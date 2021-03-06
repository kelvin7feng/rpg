
require("tool/pkgMathTool")
require("tool/pkgPositionTool")

require("base/pkgCanvasDefination")
require("base/pkgGlobalConfig")
require("base/pkgAnimatorMgr")
require("base/pkgAudioMgr")
require("base/pkgSceneMgr")
require("base/pkgCamera")
require("base/pkgCanvasMgr")
require("base/pkgUITool")
require("base/pkgButtonMgr")
require("base/pkgGlobalGoMgr")
require("base/pkgInputMgr")
require("base/pkgLuaManager")
require("base/pkgSliderMgr")
require("base/pkgAssetBundleMgr")
require("base/pkgApplicationTool")
require("base/pkgVungleAdsMgr")
require("base/pkgLanguageMgr")
require("base/pkgPoolManager")
require("base/pkgUIBaseViewMgr")
require("base/pkgZipMgr")
require("base/pkgExtractMgr")
require("base/pkgDownloadMgr")
require("base/pkgTimerMgr")
require("base/pkgUtilMgr")

require("net/socket/pkgSocket")
require("net/socket/pkgNetMgr")
require("net/socket/pkgHeartbeatMgr")
require("net/protocol/pkgProtocolManager")

-- base
require("game/ai/base/pkgBaseCondition")
require("game/ai/base/pkgBaseTask")

-- api
require("game/ai/api/APIAction")
require("game/ai/api/APICondition")

-- action
require("game/ai/action/AAttack")
require("game/ai/action/AIdle")
require("game/ai/action/AChaseTarget")
require("game/ai/action/AMoveForward")
require("game/ai/action/AMoveRandomly")
require("game/ai/action/AGetHit")
require("game/ai/action/AFollowMove")

-- condition
require("game/ai/condition/CIsDead")
require("game/ai/condition/CIsHurt")
require("game/ai/condition/CIsIdle")
require("game/ai/condition/CIsInFOV")
require("game/ai/condition/CIsInterrupted")
require("game/ai/condition/CIsPause")
require("game/ai/condition/CIsRandomMovement")
require("game/ai/condition/CIsGreatThanDistanceOfAttack")
require("game/ai/condition/CCanFollowMove")

require("game/defination/pkgAnimatorDefination")
require("game/defination/pkgClientEventDefination")
require("game/defination/pkgConfigFieldDefination")
require("game/defination/pkgEffectDefination")
require("game/defination/pkgEventDefination")
require("game/defination/pkgPoolDefination")
require("game/defination/pkgStateDefination")

require("game/logic/pkgAIManager")
require("game/logic/pkgActorManager")
require("game/logic/pkgGameController")
require("game/logic/pkgTriggerManager")
require("game/logic/pkgUserDataManager")

require("game/hotfixed/pkgHotFixedCfg")
require("game/hotfixed/pkgHotfixedMgr")

require("game/scene/pkgTerrianManager")

require("game/system/pkgSysAI")
require("game/system/pkgSysEffect")
require("game/system/pkgSysHate")
require("game/system/pkgSysMonster")
require("game/system/pkgSysPlayer")
require("game/system/pkgSysPosition")
require("game/system/pkgSysStat")
require("game/system/pkgSysSkill")
require("game/system/pkgSysUser")

require("game/ui/pkgFixedDebug")
require("game/ui/pkgMinimap")
require("game/ui/pkgStartUI")
require("game/ui/pkgVirtualController")
require("game/ui/pkgUIToastMgr")
require("game/ui/pkgUIRedPointMgr")
require("game/ui/pkgUIImageMgr")
require("game/ui/pkgUI3DModel")
require("game/ui/pkgUITableViewMgr")

require("game/entity/pkgAIData")
require("game/entity/pkgCharacter")
require("game/entity/pkgEffectNode")
require("game/entity/pkgMonster")
require("game/entity/pkgPlayer")
require("game/entity/pkgPet")

require("game/fsm/pkgFSM")
require("game/fsm/pkgFSMManger")
require("game/fsm/pkgBaseState")
require("game/fsm/pkgPlayerAttackState")
require("game/fsm/pkgPlayerDieState")
require("game/fsm/pkgPlayerHurtState")
require("game/fsm/pkgPlayerMoveState")
require("game/fsm/pkgPlayerStayState")

require("game/stat/pkgCharacterStat")
require("game/stat/pkgStat")

require("game/goods/pkgGoodsDataMgr")
require("game/goods/pkgGoodsMgr")

require("game/equip/pkgEquipDataMgr")
require("game/equip/pkgEquipMgr")

require("game/battle/pkgSysBattle")
require("game/battle/pkgAttrLogic")
require("game/battle/pkgBattleLogic")

require("game/achievement/pkgAchievementMgr")

require("game/redirect/pkgRedirectMgr")

require("game/house/pkgHouseDataMgr")
require("game/house/pkgHouseMgr")

require("game/cropland/pkgCroplandDataMgr")
require("game/cropland/pkgCroplandMgr")

require("game/collection/pkgCollectionDataMgr")
require("game/collection/pkgCollectionMgr")

require("game/shop/pkgShopDataMgr")
require("game/shop/pkgShopMgr")

require("game/afk/pkgAFKDataMgr")
require("game/afk/pkgAFKMgr")

require("game/pet/pkgPetDataMgr")
require("game/pet/pkgPetLogic")
require("game/pet/pkgPetProtocol")
require("game/pet/pkgPetTeam")
require("game/pet/pkgUIPetMainMgr")

require("game/attr/pkgUIAttrMgr")

require("game/guide/pkgGuideDataMgr")
require("game/guide/pkgGuideMgr")

require("game/task/pkgTaskDataMgr")
require("game/task/pkgTaskMgr")