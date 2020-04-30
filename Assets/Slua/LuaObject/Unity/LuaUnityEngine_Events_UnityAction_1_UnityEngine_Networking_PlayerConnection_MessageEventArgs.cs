
using System;
using System.Collections.Generic;
namespace SLua
{
    public partial class LuaDelegation : LuaObject
    {

        static internal void Lua_UnityEngine_Events_UnityAction_1_UnityEngine_Networking_PlayerConnection_MessageEventArgs(LuaFunction ld ,UnityEngine.Networking.PlayerConnection.MessageEventArgs a1) {
            IntPtr l = ld.L;
            int error = pushTry(l);

			pushValue(l,a1);
			ld.pcall(1, error);
			LuaDLL.lua_settop(l, error-1);
		}
	}
}
