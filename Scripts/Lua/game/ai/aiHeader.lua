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