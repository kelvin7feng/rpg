
-- 事件定义
-- 每一类型事件分配100个事件id

EVENT_ID =  {

	--[[
	客户端事件定义规则：表名以CLIENT_开头,每个功能占位100个位置,必须紧接前一个功能分配
	--]]
	CMD = {
		CMD_1					= 1,			-- 升级
	},

	SYSTEM = {
		NOTIFY				    = 100,			-- Toast消息
	},

	-- 客户端事件, 10001, 10100
	CLIENT_LOGIN = {
		LOGIN					=   10001,		-- 直接登录
		ENTER_GAME				=	10002		-- 进入游戏
	},
	
	BASE_INFO = {
		ON_LEVEL_CHANGE			=   10101,		-- 玩家等级
	},
	
	CLIENT_BATTLE = {
		READY					=   20001,
		START					=   20002,
		SPAWN_MONSTER			=   20003,
		KILL_MONSTER			=   20004,
		CHALLENGE_BOSS			=   20005,
	},
	
	GOODS = {
		UPDATE_DATA			    =   30001,
		SHOW_REWARD			    =   30002,
	},
	
	EQUIP = {
		UPDATE_DATA			    =   40001,
		DELETE_EQUIP		    =   40002,
		WEAR_EQUIP			    =   40003,
		ON_WEAR_EQUIP		    =   40004,
		TAKE_OFF			    =   40005,
		ON_TAKE_OFF			    =   40006,
		LEVEL_UP			    =   40007,
		ON_LEVEL_UP			    =   40008,
	},

	HOME = {
		LEVEL_UP			    =   50001,
	},
	
	ACHIEVEMENT = {
		GET_REWARD			    =   60001,
		ON_UPDATE_ACHIEVEMENT   =   60002,
	},
}

CLIENT_EVENT = {
	MONSTER_DEAD				= "monster_dead",
	PLAYER_HURT					= "player_hurt",
	UPDATE_LEVEL				= "update_level",
	UPDATE_GOODS				= "update_goods",
	UPDATE_EQUIP				= "update_equip",
	UPDATE_WEAR_EQUIP   		= "update_wear_equip",
	UPDATE_TAKE_OFF_EQUIP  		= "update_take_off_equip",
	UPDATE_LEVEL_UP_EQUIP  		= "update_level_up_equip",
	UPDATE_USER_LEVEL	  		= "update_user_level",
	UPDATE_ACHIEVEMENT	  		= "update_achievement",
}
