doNameSpace("pkgUILoading")

assetbundleTag = "ui"
prefabFile = "Loading"

event_listener = {

}

m_sliderComponent = m_sliderComponent or nil
m_dUpdateTimerId = dUpdateTimerId or nil

function setLoadingProgress(dRatio)
    if m_sliderComponent then
        local operation = KG.SceneHelper.operation
        if operation then
            if not operation.isDone then
                m_sliderComponent.value = operation.progress / 0.9
            else
                m_sliderComponent.value = 1
            end
            print("m_sliderComponent.value ======================== ", m_sliderComponent.value)
        end
    end
end

function init()
    m_sliderComponent = gameObject.transform:Find("Panel/Slider"):GetComponent(UnityEngine.UI.Slider)
end

function show(strId)
    dUpdateTimerId = pkgTimer.AddRepeatTimer("setLoadingProgress", 0.2, setLoadingProgress)
end

function destroyUI()
    if m_dUpdateTimerId then
        pkgTimer.DeleteTimer(m_dUpdateTimerId)
        m_dUpdateTimerId = nil
    end
end

function close()
    
end