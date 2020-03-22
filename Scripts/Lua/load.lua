import "UnityEngine"

require "luapack"

require("config/configHeader")
require("share/load")

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


require("net/socket/pkgSocket")
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

-- condition
require("game/ai/condition/CIsDead")
require("game/ai/condition/CIsHurt")
require("game/ai/condition/CIsIdle")
require("game/ai/condition/CIsInFOV")
require("game/ai/condition/CIsInterrupted")
require("game/ai/condition/CIsPause")
require("game/ai/condition/CIsRandomMovement")
require("game/ai/condition/CIsGreatThanDistanceOfAttack")

require("game/defination/pkgAnimatorDefination")
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
require("game/ui/pkgFlyWordUI")
require("game/ui/pkgMainUI")
require("game/ui/pkgMinimap")
require("game/ui/pkgStartUI")
require("game/ui/pkgVirtualController")

require("game/entity/pkgAIData")
require("game/entity/pkgCharacter")
require("game/entity/pkgEffectNode")
require("game/entity/pkgMonster")
require("game/entity/pkgPlayer")

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

require("game/goods/pkgGoodsMgr")

require("game/battle/pkgSysBattle")