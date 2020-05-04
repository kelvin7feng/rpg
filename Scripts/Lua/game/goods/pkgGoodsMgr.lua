doNameSpace("pkgGoodsMgr")

function OnShowReward(tbReward)
    pkgTimer.AddOnceTimer("OnShowReward", 0.1, function()
        pkgUIBaseViewMgr.showByViewPath("game/reward/pkgUIRewardList",nil,tbReward)
    end)
end

function OnUpdateData(tbGoods)
	
    if not tbGoods then
        return
    end

    for dId, dCount in pairs(tbGoods) do
        pkgUserDataManager.SetBagVal(dId, dCount)
    end

    pkgEventManager.PostEvent(pkgClientEventDefination.UPDATE_GOODS)
end