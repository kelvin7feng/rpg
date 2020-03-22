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
