
-- 数据库名字
DATABASE_TABLE_NAME = 
{
	GLOBAL 				=  "global",
	ACCCUNT				=  "account",
	REGISTER 			=  "register",
	GAME_DATA 			=  "gamedata"
}

-- 全局配置字段
DATABASE_TABLE_GLOBAL_FIELD = 
{
	USER_ID								= "UserGlobalId",
}

-- 全局配置默认值
DATABASE_TABLE_GLOBAL_DEFALUT = 
{
	[DATABASE_TABLE_GLOBAL_FIELD.USER_ID] = 100001,
}

-- 游戏数据表名
GAME_DATA_TABLE_NAME = 
{
	USER_INFO							= "UserInfo",
	BASE_INFO							= "BaseInfo",
	BATTLE_INFO							= "BattleInfo",
	BAG_INFO							= "BagInfo",
}

-- 数据字段表
GAME_DATA_FIELD_NAME = {}

-- 用户表数据
GAME_DATA_FIELD_NAME.UserInfo = 
{
	DEVICE_ID								= "DeviceId",
	REGISTER_IP								= "RegisterIp",
	PHONE_NO								= "PhoneNo"
}

-- 游戏基础字段
GAME_DATA_FIELD_NAME.BaseInfo = 
{
	USER_ID									= "UserId",
	AVATAR									= "Avatar",
	SEX 									= "Sex",
	NAME									= "Name",
	DIAMOND 								= "Diamond",
	GOLD 									= "Gold",
	LEVEL 									= "Level",
	LAST_LOGIN_TIME							= "LastLoginTime",
}

-- 战斗数据
GAME_DATA_FIELD_NAME.BattleInfo = 
{
	CUR_CHALLENGE_TYPE							= "CurChallengeType",
	NEXT_CHALLENGE_TYPE							= "NextChallengeType",
	NORMAL_TYPE									= "NormalType",
	BOSS_TYPE									= "BossType",
	CUR_LEVEL									= "CurLevel",
	CUR_MONSTER_ID								= "CurMonsterId",
	LAST_COLLECT_TIME   						= "LastCollectTime",
}

-- 背包数据
GAME_DATA_FIELD_NAME.BagInfo = 
{

}

-- 战斗类型
BATTLE_CHALLENGE_TYPE = {
	NORMAL_TYPE 								= 1,
	BOSS_TYPE 									= 2,
	[1]			= GAME_DATA_FIELD_NAME.BattleInfo.NORMAL_TYPE,
	[2]			= GAME_DATA_FIELD_NAME.BattleInfo.BOSS_TYPE,
}

-- 数据库字段,构建该表是为了初始化玩家数据时直接引用
DATABASE_TABLE_FIELD = 
{

	[GAME_DATA_TABLE_NAME.USER_INFO]	= 
	{
		[GAME_DATA_FIELD_NAME.UserInfo.DEVICE_ID]				 = "",		-- 设备Id
		[GAME_DATA_FIELD_NAME.UserInfo.REGISTER_IP]				 = "",		-- 注册Ip	
		[GAME_DATA_FIELD_NAME.UserInfo.PHONE_NO]				 = "",		-- 电话
	},

	[GAME_DATA_TABLE_NAME.BASE_INFO]	= 
	{
		[GAME_DATA_FIELD_NAME.BaseInfo.USER_ID] 				 = 0,		-- 玩家Id
		[GAME_DATA_FIELD_NAME.BaseInfo.AVATAR]					 = 0,		-- 职业头像
		[GAME_DATA_FIELD_NAME.BaseInfo.SEX]					     = 0,		-- 性别
		[GAME_DATA_FIELD_NAME.BaseInfo.NAME]					 = "Guest",	-- 名字
		[GAME_DATA_FIELD_NAME.BaseInfo.DIAMOND]				     = 0,		-- 钻石
		[GAME_DATA_FIELD_NAME.BaseInfo.GOLD]				     = 5000,	-- 金币
		[GAME_DATA_FIELD_NAME.BaseInfo.LEVEL]				     = 1,		-- 等级
		[GAME_DATA_FIELD_NAME.BaseInfo.LAST_LOGIN_TIME]		     = 0,	    -- 上次登录时间
		[GAME_DATA_FIELD_NAME.BaseInfo.LAST_LOGIN_TIME]		     = 0,	    -- 上次登录时间
	},

	[GAME_DATA_TABLE_NAME.BATTLE_INFO]	= 
	{
		[GAME_DATA_FIELD_NAME.BattleInfo.CUR_LEVEL]	 			 = 1,		-- 当前关卡
		[GAME_DATA_FIELD_NAME.BattleInfo.CUR_MONSTER_ID]	 	 = 1,		-- 当前怪物Id
		[GAME_DATA_FIELD_NAME.BattleInfo.NEXT_CHALLENGE_TYPE] 	 = 1,		-- 即将挑战类型
		[GAME_DATA_FIELD_NAME.BattleInfo.CUR_CHALLENGE_TYPE] 	 = 1,		-- 当前挑战类型
		[GAME_DATA_FIELD_NAME.BattleInfo.LAST_COLLECT_TIME]	     = 0,		-- 挂机时间
	},

	[GAME_DATA_TABLE_NAME.BAG_INFO]	= 
	{
		["1"]													 = 5000,
		["2"]													 = 100,
	},
}
