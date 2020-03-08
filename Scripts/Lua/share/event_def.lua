
-- 事件定义
-- 每一类型事件分配100个事件id

EVENT_ID =  {

	--[[
	客户端事件定义规则：表名以CLIENT_开头,每个功能占位100个位置,必须紧接前一个功能分配
	--]]

	-- 客户端事件, 10001, 10100
	CLIENT_LOGIN = {
		LOGIN					=   10001,		-- 直接登录
		ENTER_GAME				=	10002		-- 进入游戏
	},
	
	CLIENT_BATTLE = {
		READY					=   20001,
		START					=   20002,
		SPAWN_MONSTER			=   20003,
		KILL_MONSTER			=   20004,
	}
}