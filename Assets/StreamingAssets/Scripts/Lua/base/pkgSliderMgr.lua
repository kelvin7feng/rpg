doNameSpace("pkgSliderMgr")

function AddValueChangeListener(gameobject, strSliderName, fnCallback, paramters)
    
    if not gameobject then
        print("AddValueChangeListener gameobject is nil")
        return
    end
    
    if not strSliderName then
        print("AddValueChangeListener strSliderName is nil")
        return
    end
       
    if not fnCallback then
        print("AddValueChangeListener fnCallback is nil")
        return
    end

    local sliderGo = gameobject.transform:Find(strSliderName)
    if not sliderGo then
        print("can't find " .. strSliderName)
        return
    end

    local sliderComponent = sliderGo.gameObject:GetComponent(UnityEngine.UI.Slider)
    if not sliderComponent then
        print("can't find slider component")
        return
    end
    
    sliderComponent.onValueChanged:AddListener(
        function()
            fnCallback(sliderComponent, paramters)
        end
    )
end