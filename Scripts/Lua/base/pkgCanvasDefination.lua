doNameSpace("pkgCanvasDefination")

ReferenceResolutionWidth = 1920
ReferenceResolutionHeight = 1080

CanvasName = {
    FIXED_DEBUG         = "fixed_debug",
    MAIN_UI             = "main_ui",
    JOYSTICK            = "joystick",
}

DefaultCanvas = {
    {order = 1, name = CanvasName.FIXED_DEBUG, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = true, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
    {order = 2, name = CanvasName.MAIN_UI, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = true, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
    -- {order = 3, name = CanvasName.LOCAL_PLAYER_HEAD_UI, renderMode = UnityEngine.RenderMode.WorldSpace, dontDestroyOnLoad = false},
    {order = 100, name = CanvasName.JOYSTICK, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = false, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
}