doNameSpace("pkgGoodsMgr")

function OnShowReward(tbReward)
    local dTimerId = nil
    dTimerId = pkgTimerMgr.once(500, function()
        pkgUIBaseViewMgr.showByViewPath("game/reward/pkgUIRewardList",nil,tbReward)
        pkgTimerMgr.delete(dTimerId)
        dTimerId = nil
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