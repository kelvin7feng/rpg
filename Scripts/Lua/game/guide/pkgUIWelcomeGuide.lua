doNameSpace("pkgUIWelcomeGuide")

assetbundleTag = "ui"
prefabFile = "WelcomeGuideUI"

event_listener = {
    
}

m_dTxtIndex = 1
m_strContent = m_strContent or nil

m_panelNode = m_panelNode or nil
m_btnNext = m_btnNext or nil
m_txtContentCmpt = m_txtContentCmpt or nil
m_panelConveration = m_panelConveration or nil

m_dSpeed = 50
m_dTimer = nil
m_funcFinish = nil

function init()
    m_panelNode = gameObject.transform:Find("Panel/ImgHead/ConversationNode")
    m_btnNext = gameObject.transform:Find("Panel/BtnNext")
end

function getConversation()
    return {"小哥哥，你终于回来了",
            "我们的家园被恶魔破坏了，他们破坏完就走了",
            "走之前还说有本事找他们算账，可坏了！",
            "现在我们需要重新建设家园了",
            "再出发去把恶魔们打败掉！好嘛~",
           }
end

function isConversationFinish()
    local tbStr = getConversation()
    if m_dTxtIndex > #tbStr then
        return true
    end

    return false
end

function setNextContent()
    local tbStr = getConversation()
    if m_dTxtIndex > #tbStr then
        return false
    end

    m_strContent = tbStr[m_dTxtIndex]
    m_dTxtIndex = m_dTxtIndex + 1

    return true
end

function startPlay()
    local dTxtIndex = 0
	local dTxtLen = pkgStringMgr.GetStringLen(m_strContent)
    local function updateTextTimer()
        if Slua.IsNull(gameObject) then 
            return 
        end

        dTxtIndex = dTxtIndex + 1
        
		if dTxtIndex <= dTxtLen then
			m_txtContentCmpt.text = pkgStringMgr.SubString(m_strContent, 1, dTxtIndex)
        end
	end

	m_dTimer = pkgTimerMgr.add(m_dSpeed, updateTextTimer)
end

function deleteTimer()
    if m_dTimer then
        pkgTimerMgr.delete(m_dTimer)
        m_dTimer = nil
    end
end

function onClickNext()
    if not isConversationFinish() then
        setNextContent()
        startPlay()
    else
        if m_funcFinish then
            m_funcFinish()
        end

        pkgTimerMgr.once(500, function()
            destroyUI()
        end)

        pkgGuideMgr.Finish()
    end
end

function show(callback)

    m_funcFinish = callback

    local function onLoadCompelte(prefab)
        if not prefab then
            return
        end

        m_panelConveration = UnityEngine.Object.Instantiate(prefab)   
        m_panelConveration.transform:SetParent(m_panelNode.transform, false)
        
        m_panelConveration.gameObject:SetActive(true)

        local txtContent = m_panelConveration.transform:Find("PanelContent/TxtContent")
        m_txtContentCmpt = txtContent:GetComponent(UnityEngine.UI.Text)

        setNextContent()
        startPlay()

        pkgButtonMgr.AddBtnListener(m_btnNext, onClickNext)
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "Conversation", onLoadCompelte)
end

function destroyUI()
    
    m_strContent = nil
    m_panelNode = nil
    m_btnNext = nil
    m_txtContentCmpt = nil
    m_panelConveration = nil

    deleteTimer()
    pkgUIBaseViewMgr.destroyUI(pkgUIWelcomeGuide)
end

function close()
    
end