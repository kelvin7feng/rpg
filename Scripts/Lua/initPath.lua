_G.__downloadPath = string.format("%s/%s", UnityEngine.Application.persistentDataPath, "download")
_G.__persistentDataPath = string.format("%s", UnityEngine.Application.persistentDataPath)
_G.__streamingAssetsPath = string.format("%s", UnityEngine.Application.streamingAssetsPath)

local function initSearchPath()

	print("UnityEngine.Application.platform=" .. UnityEngine.Application.platform)

	local tbPath = {}
	local persistentDataPath = _G.__persistentDataPath
	table.insert(tbPath, persistentDataPath .. "/Scripts/Lua/?.lua")
	table.insert(tbPath, persistentDataPath .. "/share/?.lua")

	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer then

		local strAssetPath = UnityEngine.Application.streamingAssetsPath
		table.insert(tbPath, strAssetPath .. "/Scripts/Lua/?.lua")
		table.insert(tbPath, strAssetPath .. "/share/?.lua")

	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor or
		UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor then

		local strAssetPath = UnityEngine.Application.dataPath
		table.insert(tbPath, strAssetPath .. "/../Scripts/Lua/?.lua")
		table.insert(tbPath, strAssetPath .. "/../../share/?.lua")

	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then

		local strAssetPath = UnityEngine.Application.streamingAssetsPath
		table.insert(tbPath, strAssetPath .. "/Scripts/Lua/?.lua")
		table.insert(tbPath, strAssetPath .. "/share/.lua")

	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then

		local strAssetPath = UnityEngine.Application.streamingAssetsPath
		table.insert(tbPath, strAssetPath .. "/Scripts/Lua/?.lua")
		table.insert(tbPath, strAssetPath .. "/share/?.lua")
	end

	package.path = table.concat(tbPath, ";")
	print("package.path=" .. package.path)
end

initSearchPath()