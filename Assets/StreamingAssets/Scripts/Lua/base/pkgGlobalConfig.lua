doNameSpace("pkgGlobalConfig")

Release = false
ReferenceResolutionWidth = 1334
ReferenceResolutionHeight = 750
FixWidth = 7.5
DefaultVolume = 0.5
PrintDebug = false

ServerType = {
    LOGIC        = 2,
}

LanguageName = {
    ZH_HANS      = "zh_hans",
    EN           = "en",
}

DefaulutLanguage = LanguageName.ZH_HANS

AssetBundleName = {
    PREFAB = "prefab"
}

SceneName = {
    MAIN = "main",
    GAME = "game",
    LOADING = "loading"
}

SceneAsset = {
    [SceneName.GAME] = {
        {assetBundleName = AssetBundleName.PREFAB, assetName = "GamePanel"},
        {assetBundleName = AssetBundleName.PREFAB, assetName = "GameOver"},
        {assetBundleName = AssetBundleName.PREFAB, assetName = "Player"}
    },
    [SceneName.MAIN] = {
        {assetBundleName = AssetBundleName.PREFAB, assetName = "MainMenu"}
    }
}

VunglePlacementIds = {
    VIDEO_ID = "BANNER-3948382",
}

VungleAppId = {
    IOS      = "5cea2cdc2b028300186702a1",
}

