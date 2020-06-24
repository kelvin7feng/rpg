doNameSpace("pkgGameController")

function Init()
    
    if not pkgGlobalConfig.Release and pkgGlobalConfig.PrintDebug then
        pkgFixedDebug.Init()
    end

    -- pkgVirtualController.Init()

    local function callback()
        pkgActorManager.CreatePlayer(pkgSysPlayer.GetSpawnPosition(), pkgSysPlayer.GetSpawnRotate())
    end

    if pkgGuideMgr.CanShowWelcome() then
        pkgUIBaseViewMgr.showByViewPath("game/guide/pkgUIWelcomeGuide", nil, callback)
    else
        callback()
    end
    
end