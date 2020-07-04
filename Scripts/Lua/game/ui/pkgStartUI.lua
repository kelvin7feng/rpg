doNameSpace("pkgStartUI")

assetbundleTag = "ui"
prefabFile = "StartUI"

event_listener = {
    {pkgClientEventDefination.UPDATE_DOWNLOAD, "startDownload"},
    {pkgClientEventDefination.UPDATE_DOWNLOAD_PROCESS, "updateProcess"},
    {pkgClientEventDefination.UPDATE_EXTRACT_PROCESS, "updateProcess"},
    {pkgClientEventDefination.DOWNLOAD_COMPLETE, "downloadComplete"},
    {pkgClientEventDefination.EXTRACT_COMPLETE, "extractComplete"},
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
m_txtVersion = m_txtVersion or nil

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

function updateVersion()
    local strVersion = pkgHotFixedCfg.GetVersion()
    pkgUITool.SetGameObjectString(m_txtVersion, strVersion)
    pkgUITool.SetActive(true)
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
    updateVersion()
end

local function onClickEnter()
    m_btnEnter:GetComponent(UnityEngine.UI.Button).interactable = false
    pkgSysUser.Login(GetInputField())
end

function init()
    m_filedId = gameObject.transform:Find("Panel/Login/FieldId")
    m_panelLogin = gameObject.transform:Find("Panel/Login")
    m_panelProcess = gameObject.transform:Find("Panel/Process")
    m_txtState = gameObject.transform:Find("Panel/Process/Text")
    m_txtProcess = gameObject.transform:Find("Panel/Process/Slider/TxtProcess")
    m_txtFileName = gameObject.transform:Find("Panel/Process/Slider/TxtFileName")
    m_sliderProcess = gameObject.transform:Find("Panel/Process/Slider")
    m_sliderProcessCmpt = m_sliderProcess:GetComponent(UnityEngine.UI.Slider)
    m_txtVersion = gameObject.transform:Find("Panel/TxtVersion")
    m_btnEnter = gameObject.transform:Find("Panel/Login/BtnEnter")

    pkgButtonMgr.AddListener(gameObject, "Panel/Login/BtnEnter", onClickEnter)
end

function show()

    local inputFieldComponet = m_filedId:GetComponent(UnityEngine.UI.InputField)
    inputFieldComponet.text = GetLastEnterUserId() or ""


    updateVersion()
    pkgHotfixedMgr.CheckUpdate()

    -- startDownload(false)
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgStartUI)
end

function close()
    
end

