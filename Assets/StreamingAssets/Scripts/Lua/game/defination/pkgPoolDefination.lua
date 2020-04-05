doNameSpace("pkgPoolDefination")

PoolType = {
    PARTICAL_EXPLODE              = 1,
    FLY_WORD                      = 2,
    SWORD_HIT_EFFECT              = 3,
}

CachePool = {
    [PoolType.PARTICAL_EXPLODE] = {strAssetBundleName = "particle", strAssetName = "explode", dCount = 10},
    [PoolType.FLY_WORD] = {strAssetBundleName = "ui", strAssetName = "FlyWord", dCount = 20},
    [PoolType.SWORD_HIT_EFFECT] = {strAssetBundleName = "particle", strAssetName = "SwordHitEffect", dCount = 10},
}
