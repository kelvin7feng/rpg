doNameSpace("pkgStartUI")

startUI = startUI or nil

local function onSwitch()
    pkgGameController.Init()
end

local function onClickEnter()
    pkgSceneMgr.SwitchScene(pkgGlobalConfig.SceneName.GAME, UnityEngine.SceneManagement.LoadSceneMode.Single, onSwitch)
end

function Init()
    local function onLoadComplete(prefab)
        startUI = UnityEngine.GameObject.Instantiate(prefab)
        pkgCanvasMgr.AddToCanvas(pkgCanvasDefination.CanvasName.START_UI, startUI)

        local rectTransform = startUI:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        pkgButtonMgr.AddListener(startUI, "BtnEnter", onClickEnter)
        
        local fieldId = startUI.transform:Find("FieldId")
        local hash = iTween.Hash("y", fieldId.transform.position.y + 50, "speed", 25, 
                "loopType", "pingpong", "easeType", "linear")
        iTween.MoveTo(fieldId.gameObject, hash)

        pkgSocket.ConnectToServer(pkgGlobalConfig.GATEWAT_IP, pkgGlobalConfig.GATEWAY_PORT)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "StartUI", onLoadComplete)
end