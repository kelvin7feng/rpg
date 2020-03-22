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
    print("onClickBattle =============== ")
end

local function onClickChat()
    local player = pkgActorManager.GetMainPlayer()
    pkgFlyWordUI.PlayFlyWord(player, 1, math.random(10,100))
end

local function onClickChallengeBoss()
    -- to do: check
    pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.CHALLENGE_BOSS)
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
        pkgButtonMgr.AddListener(bottomPanel, "BtnPet", onClickChat)

        local secondBottomPanel = mainUI.transform:Find("SecondBottomPanel")
        pkgButtonMgr.AddListener(secondBottomPanel, "BtnChallengeBoss", onClickChallengeBoss)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "MainUI", onLoadComplete)
    pkgMinimap.Init()
    pkgFlyWordUI.Init()
end