doNameSpace("pkgUIBaseViewMgr")

-- 界面窗口的基础函数库.

-- View的使用者必须定义 assetbundleTag 成员变量
-- View的使用者必须定义 prefabFile 成员变量
-- View的使用者必须定义 init 函数用于初始化的时候回调

-- View的使用者可选定义 show 函数用于展示的时候回调
-- View的使用者可选定义 destroyUI 函数用于销毁的时候回调
-- View的使用者可选定义 close 函数用于点击关闭按钮的时候回调

-- View的使用者可选定义 event_listener 变量用于注册事件监听

-- 所有当前存在的界面集合
le_tbCurrentPanels = le_tbCurrentPanels or {}
-- 所有当前存在的界面的事件监听ID
le_tbCurrentPanelsListener = le_tbCurrentPanelsListener or {}

le_dSortOrder = 100

function getOrder()
    le_dSortOrder = le_dSortOrder + 2
    return le_dSortOrder
end

function subOrder()
    le_dSortOrder = le_dSortOrder - 2
end

local function closeImplenment(view)

   if view.close ~= nil then
        view.close()
    end
    
    destroyUI(view)
end

-- 初始化关闭函数
local function initCloseEvent(view)
    if not view or not view.gameObject then
        return
    end

    if view.ignoreCloseEvent == true then
        return
    end

    if view.bClickOutClose then --点击界面外关闭
        local btnClose = UnityEngine.GameObject("btnClose")
        btnClose.transform:SetParent(view.gameObject.transform, false)

        local rect = btnClose:AddComponent(UnityEngine.RectTransform)
        rect.anchorMin = UnityEngine.Vector3.zero
        rect.anchorMax = UnityEngine.Vector3.one
        rect.sizeDelta = UnityEngine.Vector2.zero

        btnClose:AddComponent("Touchable")
        btnClose:AddComponent(UnityEngine.UI.Button)

        btnClose.transform:SetAsFirstSibling()

        view.baseCloseButtonName = 'btnClose'
    end

    local function doClose()
        closeImplenment(view)
    end

    pkgButtonMgr.AddListener(view.gameObject, "BtnDefaultClose", doClose)
    pkgButtonMgr.AddListener(view.gameObject, "Panel/BtnDefaultClose", doClose)
end

-- 注册事件监听
local function initEventListener(view)
	if not view or not view.gameObject then
        return
    end

	if not view.event_listener or type(view.event_listener) ~= "table" then
		return
	end

	if not le_tbCurrentPanelsListener[view] then
		le_tbCurrentPanelsListener[view] = {}
	end

	for k,v in ipairs(view.event_listener) do
        local handle = pkgEventManager.Register(v[1], v[2], view)
        table.insert(le_tbCurrentPanelsListener[view], handle)
	end
end

local function removeEventListener(view)
	if not le_tbCurrentPanelsListener[view] then
		return
	end

    for k,v in ipairs(le_tbCurrentPanelsListener[view]) do
        pkgEventManager.Unregister(v)
	end
end


-- 通过UI Lua的路径显示一个UI
-- @param strViewPath 所对应的View的Lua文件路径(不可为空)
-- @param callback 显示完毕之后的回掉函数(可为空)，如果资源第一次加载，那么此时Canvas的Position是(0,0)
-- @param ... 打开界面的时候传递的参数(可为空)
function showByViewPath( strViewPath, callback, ... )
    local view = nil

	local args = {...}
    local argsCnt = select("#", ...)

    -- 如果是字符串，表示是这个View所在的Lua文件路径
    if type(strViewPath) == "string" then
        if strViewPath == "" then
            print('pkgUIBaseViewMgr.showByPath: the view file path is empty')
            return
        end

        require(strViewPath)
        
        local tbPaths = string.split(strViewPath,'/')
        -- LOG_TABLE(tbPaths)
        if #tbPaths <= 0 then
            for k,v in pairs(tbPaths) do
                print(k,v)
            end

            print('pkgUIBaseViewMgr.showByPath: can not split file path:' .. strViewPath .. '. Make sure the file path delimiter is /')
            return
        end

        local name = tbPaths[#tbPaths]
        view = _G[name]
    end

    if view ~= nil then
        return show(view, callback, unpack(args, 1, argsCnt))
    end
end

-- 显示一个UI
-- @param view 所对应的View/所对应的View的Lua文件路径(不可为空)
-- @param callback 显示完毕之后的回掉函数(可为空)，如果资源第一次加载，那么此时Canvas的Position是(0,0)
-- @param ... 打开界面的时候传递的参数(可为空)
function show(view, callback, ...)
    if type(view) == "string" then
        print('pkgUIBaseViewMgr.show error. If the view parameter is string type, you should use showByViewPath function:'..view)
        return
    end

    --销毁过程中，不创建界面
    if le_destorying then
        return
    end

    local args = {...}
    local argsCnt = select('#', ...)
    local goLoadingAnim -- 加载loading

    -- 展示
    local function showView(selfView)
        if selfView == nil or selfView.gameObject == nil or Slua.IsNull(selfView.gameObject) then
            return
        end

        selfView.gameObject:SetActive(true)

        if selfView.show ~= nil then
            selfView.show(unpack(args, 1, argsCnt))
        end
    end

    -- 保留字
    local forceCreate = false

    if le_tbCurrentPanels[view] ~= nil and forceCreate ~= true and view.isLoading == false then

        showView(view)

        if callback ~= nil then
            callback(view)
        end
        return
    end

    if view == nil then
        print('pkgUIBaseViewMgr.show: the view is null')
        return
    end

    -- 如果正在加载，返回
    if view.isLoading == true then
        return
    end

    local function loadingCompelte(prefab)
        -- 移除loading
        -- pkgLoadingAnimMgr.destroyAnim(goLoadingAnim)

        view.isLoading = false
        -- pkgUIMgr.enableEventSystem(true)

        if view._isDestroy then
            prefab = nil
            view._isDestroy = nil
            return
        end

        if prefab == nil then
            return
        end
        -- print("prefab name:", prefab.name)

        local noSetScalerMatch = false

        if view.noAutoSetScalerMatch then
            noSetScalerMatch = true
        end
        
        local gameObject = UnityEngine.Object.Instantiate(prefab)
        local dOrder = view.dSortOrder and view.dSortOrder or getOrder()
        local canvasObj = pkgCanvasMgr.CreateCanvasUI(gameObject, 'UI_'..view.prefabFile, dOrder)
        view.gameObject = canvasObj.gameObject

        pkgCanvasMgr.InitCanvasDefaultAttr(gameObject, view.dSortingOrder, true, noSetScalerMatch)

        initCloseEvent(view)
		initEventListener(view)

        view.init()
        showView(view)

        if callback ~= nil then
            callback(view)
        end

        setVisible(view, view._visible)
        
        -- view.baseCanvas = canvasObj.canvasComponent
    end

	view._visible = true
    view.isLoading = true
    view._isDestroy = false

    if forceCreate ~= true then
        le_tbCurrentPanels[view] = view
    end

    if view.initParentView then
        view.parentView = view.initParentView()
    end

    -- pkgUIPanelMgr.show(view)
    -- pkgUIMgr.enableEventSystem(false)
	
	local strPrefabName = view.prefabFile
	
    pkgAssetBundleMgr.LoadAssetBundle(view.assetbundleTag, strPrefabName, loadingCompelte)
        
    -- print('pkgUIBaseViewMgr.show Loading ' , view.assetbundleTag, strPrefabName)
end

-- 设置界面的GameObject展示
-- @param view 界面的view(不可为空)
-- @param visible true false 展示或者不展示
function setVisible(view, visible)
    if view == nil then
        return
    end

	view._visible = visible

    if view.gameObject ~= nil then
        view.gameObject:SetActive(visible)
    end
end

-- 移除掉View的全部事件监听 一般只用到销毁UI的时候
function removeViewAllListeners(view)

    if not view then
        return
    end

    local gameObject = view.gameObject

    if Slua.IsNull(gameObject) then
        return
    end
    
    pkgButtonMgr.RemoveGameObjectAllListeners(gameObject)
end


-- 销毁UI界面
-- @param view 界面的view(不可为空)
function destroyUI(view)
    if view == nil then return end

    view._isDestroy = true

    if not le_tbCurrentPanels[view] then return end
    le_tbCurrentPanels[view] = nil

    -- pkgUIPanelMgr.close(view)
    removeEventListener(view)

    if view.destroyUI ~= nil and view.isLoading == false then
        view.destroyUI()
    end

    removeViewAllListeners(view)

    if view.gameObject then
        if not Slua.IsNull(view.gameObject) then
            UnityEngine.GameObject.Destroy(view.gameObject)
        end
    end
    view.gameObject = nil

    subOrder(view)
    -- pkgEventMgr.dispatch(pkgEventType.PANEL_CLOSE, view)
end