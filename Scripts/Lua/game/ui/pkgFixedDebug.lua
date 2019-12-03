doNameSpace("pkgFixedDebug")

fixedDebug = fixedDebug or nil
objDebugTxt = objDebugTxt or nil
debugTxtComponent = debugTxtComponent or nil
systemInfo = nil
txtTemplate = "FPS:%d\nMono Heap Size:%d M\nMono Used Size:%d M\nAllocated Memory:%d M\nTotal Unused Reserved Memory:%d M\nTotal Reserved Memory:%d M"
dUpdateTimerId = nil

local function UpdateTxt()
    
    if UnityEngine.Time.timeScale <= 0 then
        return
    end

    local fps = math.floor(1/UnityEngine.Time.deltaTime)
    local dMonoHeapSizeLong = UnityEngine.Profiling.Profiler.GetMonoHeapSizeLong()/1000000
    local dMonoUsedSizeLong = UnityEngine.Profiling.Profiler.GetMonoUsedSizeLong()/1000000
    local dTotalAllocatedMemory = UnityEngine.Profiling.Profiler.GetTotalAllocatedMemoryLong()/1000000
    local dTotalUnusedReservedMemory = UnityEngine.Profiling.Profiler.GetTotalUnusedReservedMemoryLong()/1000000
    local dTotalReservedMemoryLong = UnityEngine.Profiling.Profiler.GetTotalReservedMemoryLong()/1000000
    local strTxt = string.format(txtTemplate, fps, dMonoHeapSizeLong, dMonoUsedSizeLong, 
                                    dTotalAllocatedMemory, dTotalUnusedReservedMemory, dTotalReservedMemoryLong)

    debugTxtComponent.text = strTxt
end

function Init()
    local function onLoadComplete(prefab)
        fixedDebug = UnityEngine.GameObject.Instantiate(prefab)
        pkgCanvasMgr.AddToCanvas(pkgCanvasDefination.CanvasName.FIXED_DEBUG, fixedDebug)

        local rectTransform = fixedDebug:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        objDebugTxt = fixedDebug.transform:Find("DebugText")
        debugTxtComponent = objDebugTxt:GetComponent(UnityEngine.UI.Text)
        dUpdateTimerId = pkgTimer.AddRepeatTimer("UpdateTxt", 1, UpdateTxt)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "FixedDebug", onLoadComplete)
end