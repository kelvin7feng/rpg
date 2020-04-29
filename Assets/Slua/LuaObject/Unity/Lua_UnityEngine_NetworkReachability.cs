using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_UnityEngine_NetworkReachability : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"UnityEngine.NetworkReachability");
		addMember(l,0,"NotReachable");
		addMember(l,1,"ReachableViaCarrierDataNetwork");
		addMember(l,2,"ReachableViaLocalAreaNetwork");
		LuaDLL.lua_pop(l, 1);
	}
}
