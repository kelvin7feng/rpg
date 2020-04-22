doNameSpace("pkgGoodsMgr")

function OnShowReward(tbReward)
    pkgUIBaseViewMgr.showByViewPath("game/reward/pkgUIRewardList",nil,tbReward)
end

function OnUpdateData(tbGoods)
	
    if not tbGoods then
        return
    end

    for dId, dCount in pairs(tbGoods) do
        pkgUserDataManager.SetBagVal(dId, dCount)
    end

    pkgEventManager.PostEvent(CLIENT_EVENT.UPDATE_GOODS)
end