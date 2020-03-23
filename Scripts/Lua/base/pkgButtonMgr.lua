doNameSpace("pkgButtonMgr")

function AddListener(gameobject, strButtonName, fnCallback, paramters)
    
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
        print("AddListener can not find ".. strButtonName)
        return
    end
    
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

    local btnComponent = btntransform.gameObject:GetComponent(ue.UI.Button)
    btnComponent.onClick:RemoveAllListeners()
end