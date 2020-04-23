doNameSpace("pkgUIAlert")

assetbundleTag = "ui"
prefabFile = "Alert"

m_scrollView = m_scrollView or nil

function init()
    
end

function closeView()
    pkgUIBaseViewMgr.destroyUI(pkgUIAlert)
end

--[[
tbParam = {
    strContent  = "显示的文字",  -- 显示文字
    bCancel     = false,        -- 取消按钮
    strCancel   = "显示的文字",  -- 取消按钮文字
    funcCancel  = nil,          -- 取消回调
    bConfirm    = false,        -- 确定按钮
    strConfirm  = "显示的文字",  -- 确定按钮文字
    funcConfirm = nil,          -- 确定
}
--]]
function show(tbParam)
    local textContentGo = gameObject.transform:Find("Panel/TextContent")
    local textContentCpnt = textContentGo:GetComponent(UnityEngine.UI.Text)
    textContentCpnt.text = tbParam.strContent
    if tbParam.fontSize then
        textContentCpnt.fontSize = tbParam.fontSize
    end

    if tbParam.bCancel then
        pkgUITool.SetActiveByName(gameObject, "Panel/layoutOperation/btnCancel", true)

        if not tbParam.funcCancel then
            tbParam.funcCancel = closeView
        end

        pkgButtonMgr.AddListener(gameObject, "Panel/layoutOperation/btnCancel", tbParam.funcCancel)
    else
        pkgUITool.SetActiveByName(gameObject, "Panel/layoutOperation/btnCancel", false)
    end

    if tbParam.bConfirm then
        pkgUITool.SetActiveByName(gameObject, "Panel/layoutOperation/btnConfirm", true)
        
        if not tbParam.funcConfirm then
            tbParam.funcConfirm = closeView
        end

        pkgButtonMgr.AddListener(gameObject, "Panel/layoutOperation/btnConfirm", tbParam.funcConfirm)
    else
        pkgUITool.SetActiveByName(gameObject, "Panel/layoutOperation/btnConfirm", false)
    end

    if tbParam.strConfirm then
        pkgUITool.SetStringByName(gameObject, "Panel/layoutOperation/btnConfirm/Text", tbParam.strConfirm)
    end

    if tbParam.strCancel then
        pkgUITool.SetStringByName(gameObject, "Panel/layoutOperation/btnCancel/Text", tbParam.strCancel)
    end
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIAlert) 
end

function close()
    
end