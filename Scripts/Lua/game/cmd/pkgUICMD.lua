doNameSpace("pkgUICMD")

assetbundleTag = "ui"
prefabFile = "CMDUI"

event_listener = {
    
}

m_scrollView = m_scrollView or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
end

function resetScrollViewItem()
    for i=0, m_scrollView.transform.childCount - 1 do
        local goChild = goParent.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function show()
    local function onLoadCompelte(prefab)
        for i, tbCfg in ipairs(_cfg.cmd) do
            local strKey = "cmd" .. i
            local goNow = m_scrollView.transform:Find(strKey)
            if pkgUITool.isNull(goNow) then
                goNow = UnityEngine.Object.Instantiate(prefab)
                goNow.name = strKey
                goNow.transform:SetParent(m_scrollView.transform, false)
            end
            goNow.gameObject:SetActive(true)

            local function fnCallback()
                pkgSocket.SendToLogic(tbCfg.id)
            end

            pkgUITool.SetStringByName(goNow, "Text", tbCfg.name)
            pkgButtonMgr.AddBtnListener(goNow, fnCallback)
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "BtnCMD", onLoadCompelte)
    
end

function destroyUI()
    
end

function close()
    
end