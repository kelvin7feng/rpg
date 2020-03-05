doNameSpace("pkgStartUI")

startUI = startUI or nil

local function onClickEnter()
    pkgSysUser.Login(GetInputField())
end

function GetInputField()
    local objInputField = startUI.transform:Find("FieldId")
    local inputFieldComponet = objInputField:GetComponent(UnityEngine.UI.InputField)
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

function Init()
    local function onLoadComplete(prefab)
        startUI = UnityEngine.GameObject.Instantiate(prefab)
        pkgCanvasMgr.AddToCanvas(pkgCanvasDefination.CanvasName.START_UI, startUI)

        local rectTransform = startUI:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        local objInputField = startUI.transform:Find("FieldId")
        local inputFieldComponet = objInputField:GetComponent(UnityEngine.UI.InputField)
        inputFieldComponet.text = GetLastEnterUserId() or ""

        pkgButtonMgr.AddListener(startUI, "BtnEnter", onClickEnter)

        pkgSocket.ConnectToServer(pkgGlobalConfig.GATEWAT_IP, pkgGlobalConfig.GATEWAY_PORT)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "StartUI", onLoadComplete)
end