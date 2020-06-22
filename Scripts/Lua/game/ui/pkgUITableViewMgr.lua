doNameSpace("pkgUITableViewMgr")
local ViewDirection = {
    Horizontal = 1,--横向滑动
    Vertical = 2, --纵向滑动
}
local Vector3 = ue.Vector3
local Vector2 = ue.Vector2

local function snapTo(tbTableView, target)
    --ue.Canvas.ForceUpdateCanvases()

    local oldElasticity = tbTableView.m_scrollRect.elasticity
    tbTableView.m_scrollRect.elasticity = 0
    local old = tbTableView.m_scrollRect.transform:InverseTransformPoint(tbTableView.m_contentRectTransform.position)
    local new = tbTableView.m_scrollRect.transform:InverseTransformPoint(target.position)
    tbTableView.m_contentRectTransform.anchoredPosition3D = old - new
    --ue.Canvas.ForceUpdateCanvases()
     pkgTimerMgr.once(100, function() 
                tbTableView.m_scrollRect.elasticity = oldElasticity
            end)
end

--创建子项对象
local function onCellCreateAtIndex(tbTableView, index)
    local holdCell = nil
    local needCreate = true
    if #tbTableView.m_reUseCellList > 0 then --有可重用子项对象时，复用之，只改变该对象的位置
        holdCell = tbTableView.m_reUseCellList[1]
        table.remove(tbTableView.m_reUseCellList, 1)
        needCreate = false
    else --没有可重用子项对象则创建
        holdCell = ue.GameObject("holdCell"..index)
        holdCell:AddComponent(ue.RectTransform)
        holdCell.transform:SetParent(tbTableView.m_contentRectTransform)
        holdCell.transform.localScale = Vector3.one
    end

    local function createCell(dChildIndex, needCreate)
        local cell = nil
        local dIndexInData = index * tbTableView._dColumn + dChildIndex
        if needCreate then
            cell = ue.GameObject.Instantiate(tbTableView.m_cell)
            cell.transform:SetParent(holdCell.transform)
            cell.transform.localScale = Vector3.one

            local cellRectTrans = cell:GetComponent(ue.RectTransform)
            if tbTableView.m_currentDir ~= ViewDirection.Vertical then
                cellRectTrans.anchorMin = Vector2(0.5, 1)
                cellRectTrans.anchorMax = Vector2(0.5, 1)
                cellRectTrans.pivot = Vector2(0.5, 1)
            else
                cellRectTrans.anchorMin = Vector2(0, 0.5)
                cellRectTrans.anchorMax = Vector2(0, 0.5)
                cellRectTrans.pivot = Vector2(0, 0.5)
            end
            cell.name = "c"..dChildIndex

            if not cell:GetComponent(ue.UI.Button) then
                cell:AddComponent(ue.UI.Button)
            end
            --A GameObject can only contain one 'Graphic' component.
            if not cell:GetComponent(ue.UI.Image) then
                cell:AddComponent("Touchable")
            end
        else
            cell = holdCell.transform:Find("c"..dChildIndex).gameObject
            cell:SetActive(true)
        end
        tbTableView.tbCellsWithIndex[dIndexInData] = cell

        pkgButtonMgr.AddBtnListener(cell,function()
            if tbTableView._tbData[dIndexInData] and type(tbTableView._tbData[dIndexInData]) == "table" and tbTableView._tbData[dIndexInData].bNoData then
                return
            end
            if tbTableView.delegateSource.setNormal and tbTableView.selectedCell then
                tbTableView.delegateSource.setNormal(tbTableView.selectedCell)
            end
            if tbTableView.delegateSource.setSelected then
                tbTableView.delegateSource.setSelected(cell)
                tbTableView.dSelectedIndex = dIndexInData
                tbTableView.selectedCell = cell
            end

            if tbTableView.delegateSource.onItemClicked then
                -- pkgAudioMgr.playUIAudioByName("Button1")
                tbTableView.delegateSource.onItemClicked(cell, dIndexInData, tbTableView._tbData)
            end
        end)

        if tbTableView.m_currentDir == ViewDirection.Vertical then
            local cellRectTrans = cell:GetComponent(ue.RectTransform)
            local posX = (dChildIndex - 1) * (cellRectTrans.sizeDelta.x + tbTableView._dOffsetCell) + tbTableView._dOffsetStart
            cellRectTrans.anchoredPosition3D = Vector3(posX, 0, 0)
        else
            local cellRectTrans = cell:GetComponent(ue.RectTransform)
            local posY = (dChildIndex - 1) * (cellRectTrans.sizeDelta.y + tbTableView._dOffsetCell) + tbTableView._dOffsetStart
            cellRectTrans.anchoredPosition3D = Vector3(0, - posY, 0)
        end

        if dIndexInData > tbTableView._dTotal then
            cell.gameObject:SetActive(false)
        else
            cell.gameObject:SetActive(true)
            if tbTableView.delegateSource.setSelected and tbTableView.dSelectedIndex and tbTableView.dSelectedIndex == dIndexInData then
                tbTableView.selectedCell = cell
                tbTableView.delegateSource.setSelected(cell)
            elseif tbTableView.delegateSource.setNormal then
                tbTableView.delegateSource.setNormal(cell)
            end
            tbTableView.delegateSource.setDataAtCell(cell, dIndexInData, tbTableView._tbData)
        end
    end

    if pkgUtilMgr.isNull(holdCell) then
        return
    end
    local cellRectTrans = holdCell:GetComponent(ue.RectTransform)
    holdCell.gameObject:SetActive(true)
    if tbTableView.m_currentDir == ViewDirection.Vertical then
        cellRectTrans.anchorMin = Vector2(0.5, 1)
        cellRectTrans.anchorMax = Vector2(0.5, 1)
        cellRectTrans.pivot = Vector2(0.5, 1)
        cellRectTrans.sizeDelta = Vector2(tbTableView.m_rectTransform.sizeDelta.x, tbTableView.m_cellSize)
    else
        cellRectTrans.anchorMin = Vector2(0, 0.5)
        cellRectTrans.anchorMax = Vector2(0, 0.5)
        cellRectTrans.pivot = Vector2(0, 0.5)
        cellRectTrans.sizeDelta = Vector2(tbTableView.m_cellSize, tbTableView.m_rectTransform.sizeDelta.y)
        -- cellRectTrans.sizeDelta = Vector2(tbTableView.m_rectTransform.sizeDelta.y, tbTableView.m_cellSize)
    end
    --设置子项对象位置
    if tbTableView.m_currentDir == ViewDirection.Vertical then
        local posY = (index) * tbTableView.m_cellSize + (index + 1) * tbTableView.m_cellInterval
        if posY > 0 then
            posY = -posY
        end
        cellRectTrans.anchoredPosition3D = Vector3(0, posY, 0)
    else
        local posX = (index) * tbTableView.m_cellSize + (index + 1) * tbTableView.m_cellInterval
        cellRectTrans.anchoredPosition3D = Vector3(posX, 0, 0)
    end

    for i=1, tbTableView._dColumn do
        createCell(i, needCreate)
    end
    holdCell.transform:SetAsLastSibling()

    tbTableView.m_cells[index] = holdCell
end


local function updateCells(tbTableView)
    local delList = {}

    for i, v in pairs(tbTableView.m_cells) do
        if i < tbTableView.m_startIndex or i > tbTableView.m_endIndex then --回收超出可见范围的子项对象
            delList[i] = true
            table.insert(tbTableView.m_reUseCellList, v)
        end
    end

    --移除超出可见范围的子项对象
    for i, v in pairs(delList) do
        tbTableView.m_cells[i] = nil
    end

    --根据开始跟结束下标，重新生成子项对象
    for i = tbTableView.m_startIndex, tbTableView.m_endIndex, 1 do
        if not tbTableView.m_cells[i] then
            onCellCreateAtIndex(tbTableView, i)
        end
    end
end


---可能有问题
function reloadData(tbTableView, bKeepSelected)
    if not tbTableView.m_startIndex or tbTableView.m_startIndex == 0 then
        tbTableView.m_startIndex = 0
        tbTableView.m_endIndex = tbTableView.m_startIndex + tbTableView.m_totalCountVisible
    end
    --为了保持滚动位置
    --if tbTableView.m_totalCountVisible < tbTableView.m_startIndex then
    --    tbTableView.m_startIndex = 0
    --    tbTableView.m_endIndex = tbTableView.m_startIndex + tbTableView.m_totalCountVisible
    --end
    for i = tbTableView.m_startIndex , tbTableView.m_endIndex, 1 do
        local holdCell = tbTableView.m_cells[i]
        if holdCell and holdCell.gameObject then
            holdCell.gameObject:SetActive(true)
            for dChildIndex=1, tbTableView._dColumn do
                local dIndexInData = i * tbTableView._dColumn + dChildIndex
                local cell = holdCell.transform:Find("c"..dChildIndex)
                if dIndexInData > tbTableView._dTotal then
                    cell.gameObject:SetActive(false)
                else
                    cell.gameObject:SetActive(true)
                    tbTableView.delegateSource.setDataAtCell(cell, dIndexInData, tbTableView._tbData)

                    if tbTableView.delegateSource.setNormal then
                        tbTableView.delegateSource.setNormal(cell)
                    end
                end
            end
        end
    end
    if bKeepSelected then
        local dSelectedIndex = tbTableView.dSelectedIndex
        if dSelectedIndex then
            clickItemByIndex(tbTableView, dSelectedIndex)
        end
    end
    --tbTableView.dSelectedIndex = nil
end

--计算可见区域子项对象开始跟结束下标
local function calCellIndex(tbTableView)
    local startOffset = 0
    local endOffset = 0

    if tbTableView.m_currentDir == ViewDirection.Vertical then --纵向滑动
        startOffset = tbTableView.m_contentOffset.y --当前可见区域起始y坐标
        endOffset = tbTableView.m_contentOffset.y + tbTableView.m_visibleViewSize --当前可见区域结束y坐标
    else
        startOffset = tbTableView.m_contentOffset.x --当前可见区域起始x坐标
        endOffset = tbTableView.m_contentOffset.x + tbTableView.m_visibleViewSize --当前可见区域结束x坐标
    end

    endOffset = (endOffset > tbTableView.m_totalViewSize and tbTableView.m_totalViewSize) or endOffset

    tbTableView.m_startIndex = math.floor(startOffset / (tbTableView.m_cellSize + tbTableView.m_cellInterval)) --子项对象开始下标
    tbTableView.m_startIndex = (tbTableView.m_startIndex <= 0 and 0) or tbTableView.m_startIndex
    tbTableView.m_endIndex = math.floor(endOffset / (tbTableView.m_cellSize + tbTableView.m_cellInterval)) --子项对象结束下标
    tbTableView.m_endIndex = (tbTableView.m_endIndex > (tbTableView.m_totalCellCount - 1) and (tbTableView.m_totalCellCount - 1)) or tbTableView.m_endIndex

    updateCells(tbTableView)
end

local function onCellScrolling(tbTableView, offset)
    if tbTableView.delegateSource.scrollCallback then
        tbTableView.delegateSource.scrollCallback()
    end

    if tbTableView.m_isSizeEnough == false then
        return
    end
    --offset的x和y都为0~1的浮点数，分别代表横向滑出可见区域的宽度百分比和纵向划出可见区域的高度百分比
    tbTableView.m_contentOffset.x = tbTableView.m_totalScrollDistance * offset.x --滑出可见区域宽度
    tbTableView.m_contentOffset.y = tbTableView.m_totalScrollDistance * (1 - offset.y) --滑出可见区域高度

    calCellIndex(tbTableView)
end

local function initComponent(tbTableView)
    local scrollView = tbTableView.delegateSource.scrollView()
    tbTableView.m_scrollRect = scrollView:GetComponent(ue.UI.ScrollRect)
    tbTableView.m_rectTransform = scrollView:GetComponent(ue.RectTransform)
    tbTableView.m_contentRectTransform = tbTableView.m_scrollRect.content
    if tbTableView.delegateSource.cellByPrefab then
        local cell = ue.Object.Instantiate(tbTableView.delegateSource.cellByPrefab())
        cell.transform:SetParent(scrollView.transform)
        cell:SetActive(false)
        tbTableView.m_cell = cell

        if tbTableView.delegateSource._initCellCallback then
            tbTableView.delegateSource._initCellCallback(cell)
        end
    else
        tbTableView.m_cell = tbTableView.delegateSource.cell()
    end
    tbTableView.m_scrollRect.onValueChanged:AddListener(function(offset) onCellScrolling(tbTableView, offset) end)
end

local function initFields(tbTableView, bNoNeedToReload)
    if not bNoNeedToReload then
        tbTableView.m_cells = {}
        tbTableView.tbCellsWithIndex = {}
        tbTableView.m_reUseCellList = {}
    end

    local dCustomCellSize = tbTableView.delegateSource.dCustomCellSize
    tbTableView.m_contentOffset = Vector2.zero

    tbTableView.m_totalCellCount = math.ceil(tbTableView._dTotal / tbTableView._dColumn)--tbTableView.dataSource.numberOfRowsInSection() --总子项数量
    tbTableView.m_cellInterval = tbTableView._dCellInterval --子项间隔

    if tbTableView.m_scrollRect.horizontal == true then --根据ScrollRect组件属性设置滑动方向
        tbTableView.m_currentDir = ViewDirection.Horizontal
    end
    if tbTableView.m_scrollRect.vertical == true then --根据ScrollRect组件属性设置滑动方向
        tbTableView.m_currentDir = ViewDirection.Vertical
    end
    --此处获取tbTableView.m_rectTransform的尺寸大小可能有问题，仅限于四个锚点在一起时
    if tbTableView.m_currentDir == ViewDirection.Vertical then --获取可见面板高度，子项对象高度
        tbTableView.m_visibleViewSize = tbTableView.m_rectTransform.sizeDelta.y
        tbTableView.m_cellSize = dCustomCellSize or tbTableView.m_cell:GetComponent(ue.RectTransform).sizeDelta.y
    else --获取可见面板宽度，子项对象宽度
        tbTableView.m_visibleViewSize = tbTableView.m_rectTransform.sizeDelta.x
        tbTableView.m_cellSize = dCustomCellSize or tbTableView.m_cell:GetComponent(ue.RectTransform).sizeDelta.x
    end
    tbTableView.m_totalViewSize = (tbTableView.m_cellSize + tbTableView.m_cellInterval) * tbTableView.m_totalCellCount
    tbTableView.m_totalScrollDistance = tbTableView.m_totalViewSize - tbTableView.m_visibleViewSize
end

local function initView(tbTableView, bNoNeedToReload)
    local contentSize = tbTableView.m_contentRectTransform.sizeDelta
    if tbTableView.m_currentDir == ViewDirection.Vertical then --设置内容面板锚点，对齐方式，纵向滑动为向上对齐
        contentSize.y = tbTableView.m_totalViewSize
        tbTableView.m_contentRectTransform.anchorMin = Vector2(0.5, 1)
        tbTableView.m_contentRectTransform.anchorMax = Vector2(0.5, 1)
        tbTableView.m_contentRectTransform.pivot = Vector2(0.5, 1)
    else --设置内容面板锚点，对齐方式，横向滑动为向左对齐
        contentSize.x = tbTableView.m_totalViewSize
        tbTableView.m_contentRectTransform.anchorMin = Vector2(0, 0.5)
        tbTableView.m_contentRectTransform.anchorMax = Vector2(0, 0.5)
        tbTableView.m_contentRectTransform.pivot = Vector2(0, 0.5)
    end
    --设置内容面板尺寸
    tbTableView.m_contentRectTransform.sizeDelta = contentSize

    local count = 0
    local usefulSize = 0
    --print("================initView",tbTableView.m_visibleViewSize, tbTableView.m_totalViewSize)
    if tbTableView.m_visibleViewSize > tbTableView.m_totalViewSize then --可见面板大于所有子项所占尺寸时，不重用子项对象
        usefulSize = tbTableView.m_totalViewSize
        count = math.floor((usefulSize / (tbTableView.m_cellSize + tbTableView.m_cellInterval)))
        tbTableView.m_isSizeEnough = false
    else
        usefulSize = tbTableView.m_visibleViewSize
        count = math.floor(usefulSize / (tbTableView.m_cellSize + tbTableView.m_cellInterval))-- + 1 为什么要加1？？

        local tempSize = tbTableView.m_visibleViewSize + (tbTableView.m_cellSize + tbTableView.m_cellInterval)
        local allCellSize = (tbTableView.m_cellSize + tbTableView.m_cellInterval) * count
        if allCellSize < tempSize then
            count = count + 1
        end
        tbTableView.m_isSizeEnough = true
    end
    if not bNoNeedToReload then
        tbTableView.m_contentRectTransform.anchoredPosition3D = Vector3.zero
    end

    tbTableView.m_totalCountVisible = count

    if bNoNeedToReload and tbTableView.m_isSizeEnough then return end
    tbTableView.tbCellsWithIndex = {}
    for i = 0, count, 1 do
        onCellCreateAtIndex(tbTableView, i)
    end
end

--滚动到指定index，多列的有待改进
function scrollToIndex(tbTableView, index, bSelect)
    local dSelIndex = index - 1
    index = math.floor(index / tbTableView._dColumn) - 1 --index从0开始！！！！
    if index < 0 then
        index = 0
    end 

    if index < tbTableView.m_totalCountVisible / 2 then --没有超过一半的，先不动,保持原样
        tbTableView.m_startIndex = 0
    else
        tbTableView.m_startIndex = math.abs(math.ceil(index - (tbTableView.m_totalCountVisible / 2)))
    end
    tbTableView.m_endIndex = tbTableView.m_startIndex + tbTableView.m_totalCountVisible
    updateCells(tbTableView)

    local cell = tbTableView.m_cells[tbTableView.m_startIndex]
    if cell then
        snapTo(tbTableView, cell:GetComponent(ue.RectTransform))
    end

    if bSelect then
        if tbTableView.m_cells[dSelIndex] then
            local cell = tbTableView.m_cells[dSelIndex].transform:Find("c"..1).gameObject
            if tbTableView.delegateSource.setNormal and tbTableView.selectedCell then
                tbTableView.delegateSource.setNormal(tbTableView.selectedCell)
            end
            if tbTableView.delegateSource.setSelected then
                tbTableView.delegateSource.setSelected(cell)
                tbTableView.dSelectedIndex = dSelIndex + 1
                tbTableView.selectedCell = cell
            end
        end
    end
end

--滚动到最下面
function scrollToBottom(tbTableView)
    scrollToIndex(tbTableView, tbTableView.m_totalCellCount)
end

function addItem(tbTableView, data, index)
    tbTableView._dTotal = tbTableView._dTotal + 1
    if index then
        table.insert(tbTableView._tbData, index, data)
    else
        table.insert(tbTableView._tbData, data)
    end
    _resetSize(tbTableView)
    reloadData(tbTableView)
end

--bReset 是否重新构建tableview
function setData(tbTableView, tbData, bReset, bKeepSelected)
    tbTableView._tbData = tbData
    tbTableView._dTotal = #tbData
    local dSelectedIndex
    if not bKeepSelected then
        tbTableView.dSelectedIndex = nil
        tbTableView.selectedCell = nil
    else
        dSelectedIndex = tbTableView.dSelectedIndex
    end

    reset(tbTableView, bReset)
    reloadData(tbTableView)
    if dSelectedIndex then
        clickItemByIndex(tbTableView, dSelectedIndex)
    end
end

function resetTotal(tbTableView, total)
    tbTableView._dTotal = total
    reset(tbTableView)
    reloadData(tbTableView)
end

function delItem(tbTableView, index)
    tbTableView._dTotal = tbTableView._dTotal - 1
    if tbTableView._dTotal < 0 then
        tbTableView._dTotal = 0
    end
    table.remove(tbTableView._tbData, index)
    _resetSize(tbTableView)
    reloadData(tbTableView)
end

function _resetSize(tbTableView)
    tbTableView.m_totalCellCount = math.ceil(tbTableView._dTotal / tbTableView._dColumn) --总子项数量
    tbTableView.m_totalViewSize = (tbTableView.m_cellSize + tbTableView.m_cellInterval) * tbTableView.m_totalCellCount
    tbTableView.m_totalScrollDistance = tbTableView.m_totalViewSize - tbTableView.m_visibleViewSize
    initView(tbTableView, true)
end

function reset(tbTableView, bReset)
    initFields(tbTableView, not bReset)
    local count = 0
    local usefulSize = 0
    if tbTableView.m_visibleViewSize > tbTableView.m_totalViewSize then --可见面板大于所有子项所占尺寸时，不重用子项对象
        usefulSize = tbTableView.m_totalViewSize
        count = math.floor((usefulSize / (tbTableView.m_cellSize + tbTableView.m_cellInterval)))
    else
        usefulSize = tbTableView.m_visibleViewSize
        count = math.floor(usefulSize / (tbTableView.m_cellSize + tbTableView.m_cellInterval)) + 1

        local tempSize = tbTableView.m_visibleViewSize + (tbTableView.m_cellSize + tbTableView.m_cellInterval)
        local allCellSize = (tbTableView.m_cellSize + tbTableView.m_cellInterval) * count
        if allCellSize < tempSize then
            count = count + 1
        end
    end
    for v in Slua.iter(tbTableView.m_contentRectTransform) do
        if bReset then
            tbTableView.m_reUseCellList = {}
            pkgButtonMgr.RemoveGameObjectAllListeners(v.gameObject)
            UnityEngine.GameObject.Destroy(v.gameObject)
        else
            v.gameObject:SetActive(false)
            for u in Slua.iter(v.transform) do
                u.gameObject:SetActive(false)
            end
        end
    end
    initView(tbTableView, not bReset)
end

--横向tableview有待完善
function createTableView(delegateSource, dataSource)
    local tbTableView = {}
    tbTableView.delegateSource = delegateSource
    tbTableView.dataSource = dataSource
    tbTableView._tbData = dataSource.tbData()
    tbTableView._dColumn = dataSource.column()
    tbTableView._dTotal = dataSource.total()
    tbTableView._dOffsetStart = delegateSource.dOffsetStart or 0
    --横向
    tbTableView._dOffsetCell = delegateSource.dOffsetCell or 10
    --纵向
    tbTableView._dCellInterval = delegateSource.dCellInterval or 10
    initComponent(tbTableView)
    initFields(tbTableView)
    initView(tbTableView)
    return tbTableView
end

-- 仅为初始化tableview后使用
function onClickFirstItem( tbTableView )
    if #tbTableView._tbData == 0 then
        return
    end
    if type(tbTableView._tbData[1]) == "table" and tbTableView._tbData[1].bNoData then
        return
    end
    if tbTableView.delegateSource.setNormal and tbTableView.selectedCell then
        tbTableView.delegateSource.setNormal(tbTableView.selectedCell)
    end
    local cell = tbTableView.tbCellsWithIndex[1]
    tbTableView.selectedCell = cell
    tbTableView.dSelectedIndex = 1
    if tbTableView.delegateSource.setSelected then
        tbTableView.delegateSource.setSelected(cell)
    end
    tbTableView.delegateSource.onItemClicked(cell, 1, tbTableView._tbData, true)
end

-- 仅为初始化tableview后使用
function onClickItem( tbTableView, dIndex )
    if #tbTableView._tbData == 0 then
        return
    end
    if type(tbTableView._tbData[dIndex]) == "table" and tbTableView._tbData[dIndex].bNoData then
        return
    end
    if tbTableView.delegateSource.setNormal and tbTableView.selectedCell then
        tbTableView.delegateSource.setNormal(tbTableView.selectedCell)
    end
    local cell = tbTableView.tbCellsWithIndex[dIndex]
    tbTableView.selectedCell = cell
    tbTableView.dSelectedIndex = dIndex
    if tbTableView.delegateSource.setSelected then
        tbTableView.delegateSource.setSelected(cell)
    end
    tbTableView.delegateSource.onItemClicked(cell, dIndex, tbTableView._tbData, true)
end

function clickItemByIndex(tbTableView, dIndex)
    if #tbTableView._tbData == 0 then
        return
    end
    if not tbTableView.tbCellsWithIndex[dIndex] then
        return
    end
    if not tbTableView._tbData[dIndex] or tbTableView._tbData[dIndex].bNoData then
        onClickFirstItem(tbTableView)
        return
    end
    if tbTableView.delegateSource.setNormal and tbTableView.selectedCell then
        tbTableView.delegateSource.setNormal(tbTableView.selectedCell)
    end
    local cell = tbTableView.tbCellsWithIndex[dIndex].gameObject
    tbTableView.selectedCell = cell
    tbTableView.dSelectedIndex = dIndex
    if tbTableView.delegateSource.setSelected then
        tbTableView.delegateSource.setSelected(cell)
    end
    tbTableView.delegateSource.onItemClicked(cell, dIndex, tbTableView._tbData, true)
end

function getItem(tbTableView, dIndex)
    if #tbTableView._tbData == 0 then
        return
    end
    if not tbTableView.tbCellsWithIndex[dIndex] then
        return
    end
    local cell = tbTableView.tbCellsWithIndex[dIndex].gameObject
    return cell
end

--[[
例子:
        local delegateSource = {}
        local dataSource = {}
        local dTotal = 1000 --cell总数
        local dColumn = 2 --多少列
        local tbData = {}
        for i=1, 20 do
            tbData[i] = "str"..i
        end

        function dataSource.column()
            return dColumn
        end
        function dataSource.total()
            return dTotal
        end
        function dataSource.tbData()
            return tbData
        end

        delegateSource.dOffsetStart = 20 --开头的偏移
        delegateSource.dOffsetCell = 20 --多列时，每个cell间的间距
        delegateSource.dCellInterval = 20 --每行的间距

        function delegateSource.onItemClicked(cell, dIndexInData)
        end
        function delegateSource.scrollView()--scrollView GameObject
            return go.transform:Find("Scroll View")
        end
        function delegateSource.cellAtIndex(cell, dIndexInData) --每个cell的数据处理,dIndexInData为数据在数组的index
            cell.transform:Find("name"):GetComponent(ue.UI.Text).text = "No." .. dIndexInData.. " data"
        end
        function delegateSource.cell() --cell GameObject，可弃用!!!
            local go = UnityEngine.Object.Instantiate(prefab)
            go.transform:SetParent(panel.transform) --最好挂在界面上，否则会在scene中生成，没法跟着界面销毁！！！
            return go
        end
        function delegateSource.cellByPrefab() --用prefab生成cell的用这个接口，传入pkgLoaderMgr.LoadAssetAsync 成功后的prefab
            return prefab
        end
        local s1 = pkgTableViewMgr.createTableView(delegateSource, dataSource)
        pkgUITableViewMgr.addItem(s1, "ttttt", 2) --在第二个位置添加数据为“tttt"的item
        pkgUITableViewMgr.delItem(s1, 2) --删除第二个item
]]
