doNameSpace("pkgSceneMgr")

local bIsLoading = false
local loadedSceneCallback = nil

function RestartScene(callback)
    if bIsLoading then
        print("is loading scene......")
        return
    end
    bIsLoading = true
    pkgCanvasMgr.DestoryOnLoad()
    local function onLoadComplete()
        callback()
        bIsLoading = false
    end
    KG.SceneHelper.Instance:LoadSceneAsync(pkgGlobalConfig.SceneName.GAME, UnityEngine.SceneManagement.LoadSceneMode.Single, onLoadComplete);
end

function SwitchScene(strSceneName, dLoadSceneMode, callback)
    if not strSceneName then
        print("SwitchScene strSceneName is nil:")
        return
    end
    if bIsLoading then
        print("is loading scene......")
        return
    end
    bIsLoading = true
    pkgCanvasMgr.DestoryOnLoad()
    local function onLoadComplete()
        callback()
        bIsLoading = false
		-- 延迟销毁,防止看到场景加载画面
        pkgTimerMgr.once(500, function()
            pkgUIBaseViewMgr.destroyUI(pkgUILoading)
        end)
    end

    pkgUIBaseViewMgr.showByViewPath("game/ui/pkgUILoading")
    KG.SceneHelper.Instance:LoadSceneAsync(strSceneName, dLoadSceneMode, onLoadComplete);
end