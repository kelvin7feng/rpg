doNameSpace("pkgPoolDefination")

PoolType = {
    -- for effect
    SWORD_HIT_EFFECT              = 1,
    HOUSE_LEVEL_UP                = 2,
    HOUSE_UPGRAD                  = 3,
    CHALLENGE_BTN                 = 4,

    -- for ui
    POP_UP_TEXT                      = 10001,
}

CachePool = {
    [PoolType.SWORD_HIT_EFFECT] = {strAssetBundleName = "particle", strAssetName = "HitEffect", dCount = 10},
    [PoolType.HOUSE_LEVEL_UP] = {strAssetBundleName = "particle", strAssetName = "FireballExplode", dCount = 10},
    [PoolType.HOUSE_UPGRAD] = {strAssetBundleName = "particle", strAssetName = "OuterSpaceExplode", dCount = 10},
    [PoolType.CHALLENGE_BTN] = {strAssetBundleName = "particle", strAssetName = "BlueSpell1", dCount = 5},
    [PoolType.POP_UP_TEXT] = {strAssetBundleName = "ui", strAssetName = "PopupText", dCount = 20},
}
