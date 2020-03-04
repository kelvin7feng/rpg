doNameSpace("pkgGameController")

function Init()
    
    if not pkgGlobalConfig.Release and pkgGlobalConfig.PrintDebug then
        pkgFixedDebug.Init()
    end

    -- pkgVirtualController.Init()
    pkgActorManager.CreatePlayer(pkgSysPlayer.GetSpawnPosition(), pkgSysPlayer.GetSpawnRotate())
end