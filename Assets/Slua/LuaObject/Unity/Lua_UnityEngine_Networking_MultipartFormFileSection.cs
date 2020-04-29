using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_UnityEngine_Networking_MultipartFormFileSection : LuaObject {
	[SLua.MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			#if DEBUG
			var method = System.Reflection.MethodBase.GetCurrentMethod();
			string methodName = GetMethodName(method);
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.BeginSample(methodName);
			#else
			Profiler.BeginSample(methodName);
			#endif
			#endif
			int argc = LuaDLL.lua_gettop(l);
			UnityEngine.Networking.MultipartFormFileSection o;
			if(matchType(l,argc,2,typeof(string),typeof(System.Byte[]),typeof(string),typeof(string))){
				System.String a1;
				checkType(l,2,out a1);
				System.Byte[] a2;
				checkArray(l,3,out a2);
				System.String a3;
				checkType(l,4,out a3);
				System.String a4;
				checkType(l,5,out a4);
				o=new UnityEngine.Networking.MultipartFormFileSection(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(argc==2){
				System.Byte[] a1;
				checkArray(l,2,out a1);
				o=new UnityEngine.Networking.MultipartFormFileSection(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(System.Byte[]))){
				System.String a1;
				checkType(l,2,out a1);
				System.Byte[] a2;
				checkArray(l,3,out a2);
				o=new UnityEngine.Networking.MultipartFormFileSection(a1,a2);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(string),typeof(System.Text.Encoding),typeof(string))){
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				System.Text.Encoding a3;
				checkType(l,4,out a3);
				System.String a4;
				checkType(l,5,out a4);
				o=new UnityEngine.Networking.MultipartFormFileSection(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(argc==4){
				System.String a1;
				checkType(l,2,out a1);
				System.Text.Encoding a2;
				checkType(l,3,out a2);
				System.String a3;
				checkType(l,4,out a3);
				o=new UnityEngine.Networking.MultipartFormFileSection(a1,a2,a3);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string),typeof(string))){
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				o=new UnityEngine.Networking.MultipartFormFileSection(a1,a2);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			return error(l,"New object failed.");
		}
		catch(Exception e) {
			return error(l,e);
		}
		#if DEBUG
		finally {
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.EndSample();
			#else
			Profiler.EndSample();
			#endif
		}
		#endif
	}
	[SLua.MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_sectionName(IntPtr l) {
		try {
			#if DEBUG
			var method = System.Reflection.MethodBase.GetCurrentMethod();
			string methodName = GetMethodName(method);
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.BeginSample(methodName);
			#else
			Profiler.BeginSample(methodName);
			#endif
			#endif
			UnityEngine.Networking.MultipartFormFileSection self=(UnityEngine.Networking.MultipartFormFileSection)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.sectionName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
		#if DEBUG
		finally {
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.EndSample();
			#else
			Profiler.EndSample();
			#endif
		}
		#endif
	}
	[SLua.MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_sectionData(IntPtr l) {
		try {
			#if DEBUG
			var method = System.Reflection.MethodBase.GetCurrentMethod();
			string methodName = GetMethodName(method);
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.BeginSample(methodName);
			#else
			Profiler.BeginSample(methodName);
			#endif
			#endif
			UnityEngine.Networking.MultipartFormFileSection self=(UnityEngine.Networking.MultipartFormFileSection)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.sectionData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
		#if DEBUG
		finally {
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.EndSample();
			#else
			Profiler.EndSample();
			#endif
		}
		#endif
	}
	[SLua.MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_fileName(IntPtr l) {
		try {
			#if DEBUG
			var method = System.Reflection.MethodBase.GetCurrentMethod();
			string methodName = GetMethodName(method);
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.BeginSample(methodName);
			#else
			Profiler.BeginSample(methodName);
			#endif
			#endif
			UnityEngine.Networking.MultipartFormFileSection self=(UnityEngine.Networking.MultipartFormFileSection)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.fileName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
		#if DEBUG
		finally {
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.EndSample();
			#else
			Profiler.EndSample();
			#endif
		}
		#endif
	}
	[SLua.MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_contentType(IntPtr l) {
		try {
			#if DEBUG
			var method = System.Reflection.MethodBase.GetCurrentMethod();
			string methodName = GetMethodName(method);
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.BeginSample(methodName);
			#else
			Profiler.BeginSample(methodName);
			#endif
			#endif
			UnityEngine.Networking.MultipartFormFileSection self=(UnityEngine.Networking.MultipartFormFileSection)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.contentType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
		#if DEBUG
		finally {
			#if UNITY_5_5_OR_NEWER
			UnityEngine.Profiling.Profiler.EndSample();
			#else
			Profiler.EndSample();
			#endif
		}
		#endif
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"UnityEngine.Networking.MultipartFormFileSection");
		addMember(l,"sectionName",get_sectionName,null,true);
		addMember(l,"sectionData",get_sectionData,null,true);
		addMember(l,"fileName",get_fileName,null,true);
		addMember(l,"contentType",get_contentType,null,true);
		createTypeMetatable(l,constructor, typeof(UnityEngine.Networking.MultipartFormFileSection));
	}
}
