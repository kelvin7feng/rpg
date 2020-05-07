doNameSpace("pkgPoolDefination")

PoolType = {
    -- for effect
    SWORD_HIT_EFFECT              = 1,
    HOUSE_LEVEL_UP                = 2,
    HOUSE_UPGRAD                  = 3,

    -- for ui
    FLY_WORD                      = 10001,
}

CachePool = {
    [PoolType.SWORD_HIT_EFFECT] = {strAssetBundleName = "particle", strAssetName = "SwordHitEffect", dCount = 10},
    [PoolType.HOUSE_LEVEL_UP] = {strAssetBundleName = "particle", strAssetName = "FireballExplode", dCount = 10},
    [PoolType.HOUSE_UPGRAD] = {strAssetBundleName = "particle", strAssetName = "OuterSpaceExplode", dCount = 10},
    [PoolType.FLY_WORD] = {strAssetBundleName = "ui", strAssetName = "FlyWord", dCount = 20},
}
