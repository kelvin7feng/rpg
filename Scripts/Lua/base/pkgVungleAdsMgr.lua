doNameSpace("pkgVungleAdsMgr")

bInit = false

function Init()
    if not bInit then
        bInit = true
        KG.VungleAds.Instance:Init(GetVungleAppId())
        KG.VungleAds.Instance:SetSoundEnable(false)
    end
    for key,strPlacementId in pairs(pkgGlobalConfig.VunglePlacementIds) do
        KG.VungleAds.Instance:LoadAd(strPlacementId)
    end
end

function GetVungleAppId()
    if pkgApplicationTool.IsIPhone() then
        return pkgGlobalConfig.VungleAppId.IOS
    end
    return "Test"
end

function PlayVideoAd()
    KG.VungleAds.Instance:PlayAd(pkgGlobalConfig.VunglePlacementIds.VIDEO_ID)
end

function CanPlayAd()
    if pkgGameDataMgr.dPlayCount < 5 then
        return false
    end

    return math.fmod(pkgGameDataMgr.dPlayCount,4) == 0 and true or false
end