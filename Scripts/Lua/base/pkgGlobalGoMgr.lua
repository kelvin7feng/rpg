doNameSpace("pkgGlobalGoMgr")

le_go = le_go or nil
le_pool = le_pool or nil

function Init()
	if le_go then
		return
	end

	le_go = UnityEngine.GameObject()
	le_go.name = "globalGo"
	UnityEngine.Object.DontDestroyOnLoad(le_go)

	le_pool = UnityEngine.GameObject()
	le_pool.name = "poolManager"
	le_pool.transform.parent = le_go.transform

end

function GetPoolManager()
	return le_pool
end

function GetGlobalGo()
	return le_go
end

function DestoryGlobalGo()
	if le_go then
		UnityEngine.Object.Destroy(le_go)
		le_go = nil
	end
end

function AddToGlobalGo(childGO)
	if le_go and childGO then
		childGO.transform.parent = le_go.transform
	end
end