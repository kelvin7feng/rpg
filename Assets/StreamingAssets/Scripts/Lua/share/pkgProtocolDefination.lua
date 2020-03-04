doNameSpace("pkgProtocolDefination")

-- 事件定义
-- 每一类型事件分配100个事件id

--[[
客户端事件定义规则：表名以CLIENT_开头,每个功能占位100个位置,必须紧接前一个功能分配
--]]

-- 客户端事件, 10001, 10100
CLIENT_LOGIN = {
    LOGIN					=   10001,		-- 登录
}
