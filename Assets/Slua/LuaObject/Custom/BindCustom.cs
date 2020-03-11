using System;
using System.Collections.Generic;
namespace SLua {
	[LuaBinder(3)]
	public class BindCustom {
		public static Action<IntPtr>[] GetBindList() {
			Action<IntPtr>[] list= {
				Lua_iTween.reg,
				Lua_NodeCanvas_Framework_GraphOwner.reg,
				Lua_KG_LuaBaseCondition.reg,
				Lua_KG_LuaCondition.reg,
				Lua_KG_LuaBaseAction.reg,
				Lua_KG_LuaAction.reg,
				Lua_NodeCanvas_BehaviourTrees_BehaviourTree.reg,
				Lua_NodeCanvas_BehaviourTrees_BehaviourTreeOwner.reg,
				Lua_KG_AgentAreaBaker.reg,
				Lua_KG_AreaMask.reg,
				Lua_KG_AssetLoader.reg,
				Lua_KG_CameraController.reg,
				Lua_KG_EventTriggerListener.reg,
				Lua_KG_Layer.reg,
				Lua_KG_MinimapFollow.reg,
				Lua_KG_NavMeshSurfaceMgr.reg,
				Lua_PlayerController.reg,
				Lua_KG_AssetBundleUtils.reg,
				Lua_LuaValueInfo.reg,
				Lua_LuaDebugTool.reg,
				Lua_KG_LuaMonoBehaviour.reg,
				Lua_KG_NetWorkMgr.reg,
				Lua_KG_SceneHelper.reg,
				Lua_KG_BaseTrigger.reg,
				Lua_KG_MonsterTrigger.reg,
				Lua_KG_TerrianTrigger.reg,
				Lua_System_Collections_Generic_List_1_int.reg,
				Lua_System_String.reg,
				Lua_UnityEngine_AI_NavMesh.reg,
				Lua_UnityEngine_AI_NavMeshAgent.reg,
			};
			return list;
		}
	}
}
