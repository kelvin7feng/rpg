doNameSpace("pkgPoolDefination")

PoolType = {
    -- for effect
    SWORD_HIT_EFFECT              = 1,
    HOUSE_LEVEL_UP                = 2,
    HOUSE_UPGRAD                  = 3,
    CHALLENGE_BTN                 = 4,
    FOOT_CIRCLE                   = 5,
    CIRCLE_EFFECT                 = 6,
    BOX_EFFECT                    = 7,

    -- for ui
    POP_UP_TEXT                      = 10001,
    HP_PROGRESS                      = 10002,
}

CachePool = {
    [PoolType.SWORD_HIT_EFFECT] = {strAssetBundleName = "particle", strAssetName = "HitEffect", dCount = 10},
    [PoolType.HOUSE_LEVEL_UP] = {strAssetBundleName = "particle", strAssetName = "HouseLevelUp", dCount = 10},
    [PoolType.HOUSE_UPGRAD] = {strAssetBundleName = "particle", strAssetName = "FireballExplode", dCount = 10},
    [PoolType.CHALLENGE_BTN] = {strAssetBundleName = "particle", strAssetName = "Challenge", dCount = 5},
    [PoolType.FOOT_CIRCLE] = {strAssetBundleName = "particle", strAssetName = "FootCircle", dCount = 5},
    [PoolType.CIRCLE_EFFECT] = {strAssetBundleName = "particle", strAssetName = "CircleBtnEffect", dCount = 5},
    [PoolType.POP_UP_TEXT] = {strAssetBundleName = "ui", strAssetName = "PopupText", dCount = 20},
    [PoolType.HP_PROGRESS] = {strAssetBundleName = "ui", strAssetName = "HpProgress", dCount = 10},
}
