doNameSpace("pkgMainUI")

mainUI = mainUI or nil
playerHpSlider = playerHpSlider or nil

function UpdatePlayerHp()
    SetPlayerHpProgress(pkgSysStat.GetRadioHealth(pkgActorManager.GetMainPlayer()))
end

function SetPlayerHpProgress(dRatio)
    if playerHpSlider then
        playerHpSlider.value = dRatio
    end
end

local function onClickBattle()
    local player = pkgActorManager.GetMainPlayer()
    pkgSysAI.SetPause(player, not pkgSysAI.GetPause(player))
end

local function onClickChat()
    local player = pkgActorManager.GetMainPlayer()
    pkgFlyWordUI.PlayFlyWord(player, 1, math.random(10,100))
end

function Init()
    local function onLoadComplete(prefab)
        mainUI = UnityEngine.GameObject.Instantiate(prefab)
        pkgCanvasMgr.AddToCanvas(pkgCanvasDefination.CanvasName.MAIN_UI, mainUI)

        local rectTransform = mainUI:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        local objHpSlider = mainUI.transform:Find("HpProgress/Slider")
        playerHpSlider = objHpSlider:GetComponent(UnityEngine.UI.Slider)
        SetPlayerHpProgress(pkgSysStat.GetRadioHealth(pkgActorManager.GetMainPlayer()))

        local bottomPanel = mainUI.transform:Find("BottomPanel")
        pkgButtonMgr.AddListener(bottomPanel, "BtnBattle", onClickBattle)
        pkgButtonMgr.AddListener(bottomPanel, "BtnChat", onClickChat)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "MainUI", onLoadComplete)
    pkgMinimap.Init()
    pkgFlyWordUI.Init()
end