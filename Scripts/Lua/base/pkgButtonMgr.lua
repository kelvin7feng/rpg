doNameSpace("pkgButtonMgr")

function AddListener(gameobject, strButtonName, fnCallback, paramters)
    -- print("AddListener ", gameobject.name, strButtonName)
    if not gameobject then
        print("AddListener gameobject is nil")
        return
    end
    
    if not strButtonName then
        print("AddListener strButtonName is nil")
        return
    end
       
    if not fnCallback then
        print("AddListener fnCallback is nil")
        return
    end

    local btnGo = gameobject.transform:Find(strButtonName)
    if not btnGo then
        -- print("AddListener can not find ".. strButtonName)
        return
    end
    
    RemoveGameObjectListeners(btnGo)

    local btnComponent = btnGo.gameObject:GetComponent(UnityEngine.UI.Button)
    btnComponent.onClick:AddListener(
        function()
            fnCallback(btnGo, paramters)
        end
    )
end

function AddBtnListener(btnGo, fnCallback, paramters)
    
    if not btnGo then
        print("AddListener gameobject is nil")
        return
    end
       
    if not fnCallback then
        print("AddListener fnCallback is nil")
        return
    end
    
    RemoveGameObjectListeners(btnGo)

    local btnComponent = btnGo.gameObject:GetComponent(UnityEngine.UI.Button)
    btnComponent.onClick:AddListener(
        function()
            fnCallback(btnGo, paramters)
        end
    )
end

function RemoveListeners(gameObject, strBtnName)
    if not gameObject or not strBtnName then
        return
    end

    local btntransform = gameObject.transform:Find(strBtnName)
    if not btntransform then
        return
    end

    local btnComponent = btntransform.gameObject:GetComponent(UnityEngine.UI.Button)
    btnComponent.onClick:RemoveAllListeners()
end

function RemoveGameObjectListeners(gameObject)
    
    if pkgUITool.isNull(gameObject) then
        return
    end
    
    local components = gameObject:GetComponentsInChildren(UnityEngine.UI.Button, true)

    if components then
        for v in Slua.iter(components) do
            if not pkgUITool.isNull(v) and v.onClick ~= nil then
                v.onClick:RemoveAllListeners()
                v.onClick = UnityEngine.UI.Button.ButtonClickedEvent()
            end
        end
    end

    components = nil
end

function RemoveGameObjectInputFieldListeners(gameObject)

    if pkgUITool.isNull(gameObject) then
        return
    end

    local components = gameObject:GetComponentsInChildren(UnityEngine.UI.InputField, true)

    if components then
        for v in Slua.iter(components) do
            if not pkgUITool.isNull(v) then
                if v.onValueChanged ~= nil then
                    v.onValueChanged:RemoveAllListeners()
                end
            end
        end
    end

    components = nil
end

function RemoveGameObjectSliderListeners(gameObject)

    if pkgUITool.isNull(gameObject) then
        return
    end

    local components = gameObject:GetComponentsInChildren(UnityEngine.UI.Toggle, true)

    if components then
        for v in Slua.iter(components) do
            if not pkgUITool.isNull(v) and v.onValueChanged ~= nil then
                v.onValueChanged:RemoveAllListeners()
            end
        end
    end

    components = nil
end

function RemoveGameObjectToggleListeners(gameObject)

    if pkgUITool.isNull(gameObject) then
        return
    end

    local components = gameObject:GetComponentsInChildren(UnityEngine.UI.Slider, true)

    if components then
        for v in Slua.iter(components) do
            if not pkgUITool.isNull(v) and v.onValueChanged ~= nil then
                v.onValueChanged:RemoveAllListeners()
            end
        end
    end

    components = nil
end

function RemoveGameObjectEventTriggerListeners(gameObject)
    if pkgUITool.isNull(gameObject) then
        return
    end

    if not UnityEngine.EventSystems or not UnityEngine.EventSystems.EventTrigger then
        return
    end

    local components = gameObject:GetComponentsInChildren(UnityEngine.EventSystems.EventTrigger, true)

    if components then
        for v in Slua.iter(components) do
            if not pkgUITool.isNull(v) and v.triggers ~= nil then
                for v2 in Slua.iter(v.triggers) do
                    if not pkgUITool.isNull(v2) and v2.callback ~= nil then
                        v2.callback:RemoveAllListeners()
                    end
                end
        
                v.triggers:Clear()
            end
        end
    end

    components = nil
end

function RemoveGameObjectAllListeners(gameObject)

    if pkgUITool.isNull(gameObject) then
        return
    end

    RemoveGameObjectListeners(gameObject)
    RemoveGameObjectInputFieldListeners(gameObject)
    RemoveGameObjectSliderListeners(gameObject)
    RemoveGameObjectToggleListeners(gameObject)
    RemoveGameObjectEventTriggerListeners(gameObject)
end