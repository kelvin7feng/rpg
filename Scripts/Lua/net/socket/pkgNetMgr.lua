doNameSpace("pkgNetMgr")

function ShowServerStopTip(strTip)
    local function confirm()
        Toast("请耐心等待")
    end
    local tbParam = {
        strContent  = "服务器维护中:"..strTip,   -- 显示文字
    }
    pkgUIBaseViewMgr.showByViewPath("game/alert/pkgUIAlert", nil, tbParam)
end

function OnReconnectFailed()
    local tbParam = {
        strContent  = "重连失败,请联系客服"   -- 显示文字
    }
    pkgUIBaseViewMgr.showByViewPath("game/alert/pkgUIAlert", nil, tbParam)
end
