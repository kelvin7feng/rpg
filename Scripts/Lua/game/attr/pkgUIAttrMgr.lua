doNameSpace("pkgUIAttrMgr")

function resetAttrItem(panelAttr)
    for i=0, panelAttr.transform.childCount - 1 do
        local goChild = panelAttr.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function UpdateAttrPanel(panelAttr, tbAttr)
    if not panelAttr or not tbAttr then
        return
    end

    resetAttrItem(panelAttr)
    
    for i, strAttr in ipairs(tbAttr) do
        pkgUITool.SetStringByName(panelAttr, "TxtAttr"..i, strAttr)
        pkgUITool.SetActiveByName(panelAttr, "TxtAttr"..i, true)
    end
end