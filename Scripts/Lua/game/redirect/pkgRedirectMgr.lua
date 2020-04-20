doNameSpace("pkgRedirectMgr")

function redirectPage(dRedirect, closePage)
    local tbCfg = _cfg.redirectPage[dRedirect]
    pkgUIBaseViewMgr.showByViewPath(tbCfg.redirect, pkgRedirectMgr[tbCfg.callback], tbCfg.redirectParam1, tbCfg.redirectParam2, tbCfg.redirectParam3)
    if closePage then
        pkgUIBaseViewMgr.destroyUI(closePage)
    end
end