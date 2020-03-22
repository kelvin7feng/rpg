doNameSpace("pkgUIGoodsMain")

assetbundleTag = "ui"
prefabFile = "GoodsUI"

event_listener = {
    {EVENT_ID.GOODS.SHOW_REWARD, "testCallback"},
}

function close()
    close("close ========================= 1")
end

function destroyUI()
    print("destroyUI ========================= 1")
end

function testCallback()

end

function init()
    print("pkgUIGoodsMain init")
end

function show()
    print("pkgUIGoodsMain show")
end