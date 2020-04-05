doNameSpace("pkgGlobalConfig")

Release = false
ReferenceResolutionWidth = 1334
ReferenceResolutionHeight = 750
FixWidth = 7.5
DefaultVolume = 0.5
PrintDebug = false

GodMode = false

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
    GAME = "Game",
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

NavMeshSurface = {
    VOLUME_X              = 50,
    VOLUME_Y              = 50,
    VOLUME_Z              = 50,
    VOXEL_SIZE            = 0.24,    --该参数最大为.024,再大会影响导航
    DISTANCE_THRESHOLD    = 20,     --应该比VOLUME_X,VOLUME_Y,VOLUME_Z的一半要小
}

GATEWAT_IP = "122.51.240.92"
GATEWAT_IP = "192.168.0.100"
GATEWAY_PORT = 7000