doNameSpace("pkgStartUI")

assetbundleTag = "ui"
prefabFile = "StartUI"

event_listener = {
    {CLIENT_EVENT.UPDATE_DOWNLOAD, "startDownload"},
    {CLIENT_EVENT.UPDATE_DOWNLOAD_PROCESS, "updateProcess"},
    {CLIENT_EVENT.UPDATE_EXTRACT_PROCESS, "updateProcess"},
    {CLIENT_EVENT.DOWNLOAD_COMPLETE, "downloadComplete"},
    {CLIENT_EVENT.EXTRACT_COMPLETE, "extractComplete"},
}

m_panelLogin = m_panelLogin or nil
m_panelProcess = m_panelProcess or nil
m_btnEnter = m_btnEnter or nil
m_filedId = m_filedId or nil
m_txtProcess = m_txtProcess or nil
m_txtFileName = m_txtFileName or nil
m_sliderProcess = m_sliderProcess or nil
m_sliderProcessCmpt = m_sliderProcessCmpt or nil
m_txtState = m_txtState or nil

function GetInputField()
    local inputFieldComponet = m_filedId:GetComponent(UnityEngine.UI.InputField)
    local strInput = inputFieldComponet.text
    local dUserId = 10001
    if strInput and strInput ~= "" then
        dUserId = tonumber(strInput)
    end

    SetLastEnterUserId(dUserId)

    return dUserId
end

function GetLastEnterUserId()
    local strField = nil
    if UnityEngine.PlayerPrefs.HasKey("userId") then
        strField = UnityEngine.PlayerPrefs.GetString("userId")
    end

    return strField
end

function SetLastEnterUserId(dUserId)
    UnityEngine.PlayerPrefs.SetString("userId", dUserId)
    UnityEngine.PlayerPrefs.Save()
end

function updateProcess(strFileName, dProcess)
    pkgUITool.SetGameObjectString(m_txtFileName, strFileName)
    pkgUITool.SetGameObjectString(m_txtProcess, string.format("%0.02f%%", dProcess * 100))
    m_sliderProcessCmpt.value = dProcess
end

function startDownload(bUpdate)
    if not bUpdate then
        m_panelLogin.gameObject:SetActive(true)
        m_panelProcess.gameObject:SetActive(false)

        require("share/configLoad")
        pkgSocket.ConnectToServer(pkgGlobalConfig.GATEWAT_IP, pkgGlobalConfig.GATEWAY_PORT)
        return
    end

    m_panelLogin.gameObject:SetActive(false)
    m_panelProcess.gameObject:SetActive(true)

    -- start to download
    pkgHotfixedMgr.DownloadPatchFile()
end

function downloadComplete()

    m_panelLogin.gameObject:SetActive(false)
    m_panelProcess.gameObject:SetActive(true)
    pkgUITool.SetGameObjectString(m_txtState, "Extracting")

    -- start to extract
    pkgHotfixedMgr.UnzipPatchFile()
end

function extractComplete()
    m_panelLogin.gameObject:SetActive(true)
    m_panelProcess.gameObject:SetActive(false)

    pkgHotfixedMgr.RequireFile()
    require("share/configLoad")
end

local function onClickEnter()
    pkgSysUser.Login(GetInputField())
end

function init()
    pkgButtonMgr.AddListener(gameObject, "Panel/Login/BtnEnter", onClickEnter)
    m_filedId = gameObject.transform:Find("Panel/Login/FieldId")
    m_panelLogin = gameObject.transform:Find("Panel/Login")
    m_panelProcess = gameObject.transform:Find("Panel/Process")
    m_txtState = gameObject.transform:Find("Panel/Process/Text")
    m_txtProcess = gameObject.transform:Find("Panel/Process/Slider/TxtProcess")
    m_txtFileName = gameObject.transform:Find("Panel/Process/Slider/TxtFileName")
    m_sliderProcess = gameObject.transform:Find("Panel/Process/Slider")
    m_sliderProcessCmpt = m_sliderProcess:GetComponent(UnityEngine.UI.Slider)
end

function show()

    local inputFieldComponet = m_filedId:GetComponent(UnityEngine.UI.InputField)
    inputFieldComponet.text = GetLastEnterUserId() or ""

    pkgHotfixedMgr.CheckUpdate()
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgStartUI)
end

function close()
    
end

