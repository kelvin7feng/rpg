doNameSpace("pkgUIGoodsMain")

assetbundleTag = "ui"
prefabFile = "GoodsUI"

event_listener = {
    
}

m_scrollView = m_scrollView or nil
m_defaultPanel = m_defaultPanel or nil
m_tbTableView = m_tbTableView or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View")
    m_defaultPanel = gameObject.transform:Find("Panel/DefaultPage")
    m_defaultPanel.gameObject:SetActive(false)
end

function getTableViewData()
    return pkgUserDataManager.GetBag()
end

function createTableViewCard()
    local function onComplete(prefab)
        if not prefab then return end

        local delegateSource = {
            dOffsetStart = 15,  --开头的偏移
            dOffsetCell = 10,   --每个cell的间隔
            dCellInterval = 10, --每行的间距
        }

        local dataSource = {}

        local tbData = getTableViewData()

        function dataSource.column()
            return 5
        end

        function dataSource.total()
            return #tbData
        end
        function dataSource.tbData()
            return tbData
        end

        function delegateSource.scrollView()
            return m_scrollView
        end

        function delegateSource.setDataAtCell(cell, dIndexInData, _tbData)
            local tbGoodsInfo = _tbData[dIndexInData]
            local dGoodsId = tonumber(tbGoodsInfo.id)
            local dCfgCount = tonumber(tbGoodsInfo.count)
            
            pkgUITool.fillGoodsIcon(cell, tbGoodsInfo)
        end

        function delegateSource.cellByPrefab()
            return prefab
        end
        
        le_tbTableView = pkgUITableViewMgr.createTableView(delegateSource, dataSource)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "GoodsItem", onComplete)
end

function show()
    local tbBagInfo = pkgUserDataManager.GetBag()
    if #tbBagInfo <= 0 then
        m_defaultPanel.gameObject:SetActive(true)
        return
    end

    createTableViewCard()
    
end

function destroyUI()
    le_tbTableView = nil
end

function close()
    
end