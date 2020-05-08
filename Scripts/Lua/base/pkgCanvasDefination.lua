doNameSpace("pkgCanvasDefination")

ReferenceResolutionWidth = 1080
ReferenceResolutionHeight = 1920

CanvasName = {
    FIXED_DEBUG         = "fixed_debug",
    START_UI            = "start_ui",
    FLY_WORD_UI         = "fly_word_ui",
    MAIN_UI             = "main_ui",
    JOYSTICK            = "joystick",
}

DefaultCanvas = {
    -- {order = 1, name = CanvasName.START_UI, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = false, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
    -- {order = 2, name = CanvasName.FLY_WORD_UI, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = true, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
    -- {order = 99, name = CanvasName.MAIN_UI, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = true, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
    -- {order = 4, name = CanvasName.LOCAL_PLAYER_HEAD_UI, renderMode = UnityEngine.RenderMode.WorldSpace, dontDestroyOnLoad = false},
    -- {order = 100, name = CanvasName.JOYSTICK, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = false, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
    {order = 1000, name = CanvasName.FIXED_DEBUG, renderMode = UnityEngine.RenderMode.ScreenSpaceOverlay, dontDestroyOnLoad = true, UIScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize},
}