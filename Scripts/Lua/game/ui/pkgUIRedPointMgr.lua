doNameSpace("pkgUIRedPointMgr")

--保存红点相关信息
--[[
le_tbRedPointByGo = {
        [go1] = {
            dCount = 0,
            imgRedPoint = imgRedPoint,
            go = go1,
            tbStrkey = {},
        }
}

le_tbRedPoint = 
{
    [key1] = {
        [go1] = le_tbRedPointByGo[go1],
        [go2] = le_tbRedPointByGo[go2],
    },
    [key2] = {
        [go1] = le_tbRedPointByGo[go1],
        [go2] = le_tbRedPointByGo[go2],
    }
}
]]
le_tbRedPoint = le_tbRedPoint or {}
le_tbRedPointByGo = le_tbRedPointByGo or {}

--保存当前有红点的key
le_tbStrKeyHasRedPoint = le_tbStrKeyHasRedPoint or {}

function isKeyHasRedPoint(strKey)
    local bHas = le_tbStrKeyHasRedPoint[strKey]
    return bHas
end

--清除键值go被删除的table
local function CheckKeyGoIsNull()
    local tbTmp = {}
    for go, v in pairs(le_tbRedPointByGo) do
        if not pkgUITool.isNull(go) then
            tbTmp[go] = v
        end
    end
    le_tbRedPointByGo = (tbTmp)

    tbTmp = {}
    for strKey, v in pairs(le_tbRedPoint) do
        tbTmp[strKey] = {}
        for go, u in pairs(v) do
            if not pkgUITool.isNull(go) then
                tbTmp[strKey][go] = u
            end
        end
    end
    le_tbRedPoint= (tbTmp)
end

--添加红点，whereGo为要添加红点的gameObject
--tbParams = {dx = -30, dy = -30} 红点偏移
function AddRedPoint(whereGo, strKey, tbParams)
    le_tbStrKeyHasRedPoint[strKey] = true
    tbParams = tbParams or {}
    if not le_tbRedPoint[strKey] then
        le_tbRedPoint[strKey] = {}
    end

    if (le_tbRedPointByGo[whereGo] and pkgUITool.isNull(whereGo)) or not le_tbRedPointByGo[whereGo] then --排除添加的对象已经销毁的，要重新添加
        le_tbRedPointByGo[whereGo] = {}
        le_tbRedPointByGo[whereGo].tbStrKey = {}
        le_tbRedPoint[strKey][whereGo] = nil
    end

    local tbRedPoint = le_tbRedPointByGo[whereGo]
    if not tbRedPoint.dCount or not tbRedPoint.dCount == 0 then --go没有加过红点
        tbRedPoint.dCount = 1
        le_tbRedPoint[strKey][whereGo] = {}
        pkgUITool.CreateImg("ui", "RedPoint", UnityEngine.GameObject("redPoint"), function(imgRedPoint)
            if pkgUITool.isNull(whereGo) then
                le_tbRedPointByGo[whereGo] = {}
                le_tbRedPointByGo[whereGo].tbStrKey = {}
                le_tbRedPoint[strKey][whereGo] = nil
                return
            end
            imgRedPoint.transform:SetParent(whereGo.transform, false)
            local rect = imgRedPoint:GetComponent(UnityEngine.RectTransform)
            rect.anchorMin = UnityEngine.Vector2.one
            rect.anchorMax = UnityEngine.Vector2.one
            rect.anchoredPosition3D = UnityEngine.Vector3.zero + UnityEngine.Vector3(tbParams.dx or 0, tbParams.dy or 0, 0)
            imgRedPoint.transform.localScale = UnityEngine.Vector3.one

            tbRedPoint.imgRedPoint = imgRedPoint
            tbRedPoint.go = whereGo
            tbRedPoint.tbStrKey[strKey] = strKey
            le_tbRedPoint[strKey][whereGo] = tbRedPoint
        end, {bSetNative=true})
    else
        if not le_tbRedPoint[strKey][whereGo] then
            le_tbRedPoint[strKey][whereGo] = {}
            le_tbRedPoint[strKey][whereGo] = tbRedPoint
            tbRedPoint.dCount = tbRedPoint.dCount + 1
            tbRedPoint.tbStrKey[strKey] = strKey
        end
    end
    CheckKeyGoIsNull()
end

--删除所有红点
function RemoveAllRedPoint(whereGo, tbParams)
    local tbRedPoint = le_tbRedPointByGo[whereGo]
    if not tbRedPoint then
        return
    end
    if not pkgUITool.isNull(tbRedPoint.imgRedPoint) then
        UnityEngine.Object.Destroy(tbRedPoint.imgRedPoint)
    end
    le_tbRedPointByGo[whereGo] = nil
end

--删除一个红点
function RemoveRedPoint(strKey, tbParams)
    local tbRedPoint = le_tbRedPoint[strKey]
    if not tbRedPoint then
        return
    end
    le_tbStrKeyHasRedPoint[strKey] = nil
    local tbDel = {}
    for _, v in pairs(tbRedPoint) do
        table.insert(tbDel, v.go)
        local tbGo = le_tbRedPointByGo[v.go]
        if tbGo then
            tbGo.dCount = tbGo.dCount - 1
            tbGo.tbStrKey[strKey] = nil
            if tbGo.dCount == 0 then
                RemoveAllRedPoint(v.go)
            end
        end
    end
    for _, v in ipairs(tbDel) do
        le_tbRedPoint[strKey][v] = nil
    end
    CheckKeyGoIsNull()
end
