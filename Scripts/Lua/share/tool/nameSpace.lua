e_tbNSName = e_tbNSName or {}
e_tbRequireName = e_tbRequireName or {}

function doNameSpace(strNameSpace)
	if _G[strNameSpace] == nil then
		local M = {}
		_G[strNameSpace] = M
		setmetatable(M, {__index = _G})
		setfenv(2,M)
	else
		print("*************use same name space:",strNameSpace,"*************")
		setfenv(2,_G[strNameSpace])
	end
	e_tbNSName[strNameSpace] = true
end

local oldRequire = require
require = function(str)
	local ret = oldRequire(str)
	e_tbRequireName[str] = true
	return ret
end

function clearNameSpace()
	for strNameSpace, _ in pairs(e_tbNSName) do
		_G[strNameSpace] = nil
	end

	for strName,_ in pairs(e_tbRequireName) do
		package.loaded[strName] = nil
	end

	e_tbNSName = {}
	e_tbRequireName = {}
end
