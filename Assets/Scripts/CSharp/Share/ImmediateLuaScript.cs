using UnityEngine;
#if UNITY_EDITOR	
using UnityEditor;
#endif
using System.Collections;
using System.Collections.Generic;
using System.IO;
using SLua;
using System;

namespace XS
{
    public class ImmediateLuaScript : MonoBehaviour
    {
        public class ScriptInfo
        {
            public string strFileName;
            public string strFileFullPath;
            public System.DateTime dtLastWrite;
        }

        List<ScriptInfo> m_loadedScripts = new List<ScriptInfo>();
        int m_nNextScriptIndex = 0;

        private static ImmediateLuaScript _Instance;

        public static ImmediateLuaScript Instance
        {
            get
            {
                if (_Instance == null)
                {
                    GameObject resMgr = GameObject.Find("_ImmediateLuaScript");
                    if (resMgr == null)
                    {
                        resMgr = new GameObject("_ImmediateLuaScript");
                        GameObject.DontDestroyOnLoad(resMgr);
                    }

                    _Instance = resMgr.AddComponent<ImmediateLuaScript>();
                }
                return _Instance;
            }
        }

#if UNITY_EDITOR
        static int m_ImmediateLuaScriptInEditor = -1;
        const string kImmediateLuaScript = "ImmediateLuaScript";

        public static bool ImmediateLuaScriptInEditor
        {
            get
            {
                if (m_ImmediateLuaScriptInEditor == -1)
                    m_ImmediateLuaScriptInEditor = EditorPrefs.GetBool(kImmediateLuaScript, true) ? 1 : 0;

                return m_ImmediateLuaScriptInEditor != 0;
            }
            set
            {
                int newValue = value ? 1 : 0;
                if (newValue != m_ImmediateLuaScriptInEditor)
                {
                    m_ImmediateLuaScriptInEditor = newValue;
                    EditorPrefs.SetBool(kImmediateLuaScript, value);
                }
            }
        }

       ScriptInfo getScriptInfo(string strFileFullPath)
		{
            foreach (ScriptInfo info in m_loadedScripts)
            {   
                if(info.strFileFullPath == strFileFullPath)
                {
                    return info;
                }
            }
            return null;
		}

        ScriptInfo getOrCreateScriptInfo(string strFileName, string strFileFullPath)
        {
            ScriptInfo info = getScriptInfo(strFileFullPath);
            if (info != null) return info;

            info = new ScriptInfo();
            info.strFileName = strFileName;
            info.strFileFullPath = strFileFullPath;
            m_loadedScripts.Add(info);
            return info;
        }

        ScriptInfo getNextScriptInfo()
        {
            if (m_nNextScriptIndex >= m_loadedScripts.Count)
            {
                m_nNextScriptIndex = 0;
                return null;
            }

            return m_loadedScripts[m_nNextScriptIndex++];
        }

        string getFileFullPath(string strFileName)
        {
            string strFileFullPath;
            do
            {
                strFileFullPath = UnityEngine.Application.dataPath + "/../../../wz_client_lua/luaScript/" + strFileName + ".lua";
                if (System.IO.File.Exists(strFileFullPath))
                    break;
                strFileFullPath = UnityEngine.Application.dataPath + "/../../../wz_config/client/lua/" + strFileName + ".lua";
                if (System.IO.File.Exists(strFileFullPath))
                    break;
                strFileFullPath = UnityEngine.Application.dataPath + "/../../../" + strFileName + ".lua";
                if (System.IO.File.Exists(strFileFullPath))
                    break;
            } while (false);

            return strFileFullPath;
        }


        public void SetImmediateLuaScript(string strFileName)
        {
            if (!ImmediateLuaScriptInEditor) return;

            string strFileFullPath = getFileFullPath(strFileName);
            FileInfo fileInfo = new FileInfo(strFileFullPath);
            if(fileInfo.Exists)
            {
                ScriptInfo info = getOrCreateScriptInfo(strFileName, strFileFullPath);
                info.dtLastWrite = fileInfo.LastWriteTime;
            }
        }

        void checkScriptUpdate()
        {
            ScriptInfo info = getNextScriptInfo();
            if (info == null) return;

            FileInfo fileInfo = new FileInfo(info.strFileFullPath);
            if (info.dtLastWrite < fileInfo.LastWriteTime)
            {
                info.dtLastWrite = fileInfo.LastWriteTime;
                bool result = loadScriptFile(info.strFileName, info.strFileFullPath);
                if(!result)
                {
                    var L = LuaSvr.mainState.L;
                    string err = LuaDLL.lua_tostring(L, -1);
                    LuaDLL.lua_pop(L, 2);
                    throw new Exception(err);
                }
            }
        }

        void LateUpdate()
        {
            if (!ImmediateLuaScriptInEditor) return;
            for(int i=0;i<5; i++)
            {
                checkScriptUpdate();
            }
        }

        public static int newLoader(System.IntPtr L)
        {
            string fileName = LuaDLL.lua_tostring(L, 1);
            Instance.SetImmediateLuaScript(fileName);
            LuaObject.pushValue(L, true);
            LuaDLL.lua_pushnil(L);
            return 2;
        }

        public void AddLuaLoaders(System.IntPtr L)
        {
            LuaState.pushcsfunction(L, newLoader);
            int loaderFunc = LuaDLL.lua_gettop(L);

            LuaDLL.lua_getglobal(L, "package");
#if LUA_5_3
			LuaDLL.lua_getfield(L, -1, "searchers");
#else
            LuaDLL.lua_getfield(L, -1, "loaders");
#endif
            int loaderTable = LuaDLL.lua_gettop(L);

            // Shift table elements right
            for (int e = LuaDLL.lua_rawlen(L, loaderTable) + 1; e > 2; e--)
            {
                LuaDLL.lua_rawgeti(L, loaderTable, e - 1);
                LuaDLL.lua_rawseti(L, loaderTable, e);
            }
            LuaDLL.lua_pushvalue(L, loaderFunc);
            LuaDLL.lua_rawseti(L, loaderTable, 2);
            LuaDLL.lua_settop(L, 0);
/*
            LuaDLL.lua_getglobal(L, "package");                         / * L: package * /
            LuaDLL.lua_getfield(L, -1, "loaders");                      / * L: package, loaders * /

            // insert loader into index 2
            LuaState.pushcsfunction(L, newLoader);

            for (int i = (int)(LuaDLL.lua_rawlen(L, -2) + 1); i > 2; --i)
            {
                LuaDLL.lua_rawgeti(L, -2, i - 1);                                / * L: package, loaders, func, function * /
                                                                                 // we call lua_rawgeti, so the loader table now is at -3
                LuaDLL.lua_rawseti(L, -3, i);                                    / * L: package, loaders, func * /
            }
            LuaDLL.lua_rawseti(L, -2, 2);                                        / * L: package, loaders * /

            // set loaders into package
            LuaDLL.lua_setfield(L, -2, "loaders");                               / * L: package * /

            LuaDLL.lua_pop(L, 1);*/
        }

        // 加载lua文件
        bool loadScriptFile(string strFileName, string strFileFullPath)
        {
            FileStream fs = new FileStream(strFileFullPath, FileMode.Open);
            long size = fs.Length;
            byte[] bytes = new byte[size];
            fs.Read(bytes, 0, bytes.Length);
            fs.Close();

            bytes = LuaState.CleanUTF8Bom(bytes);

            var L = LuaSvr.mainState.L;
            if (bytes != null)
            {
                var nOldTop = LuaDLL.lua_gettop(L);

                var err = LuaDLL.luaL_loadbuffer(L, bytes, bytes.Length, "@" + strFileFullPath);

                if (err != 0)
                {
                    string errstr = LuaDLL.lua_tostring(L, -1);
                    LuaDLL.lua_pop(L, 1);
                    LuaObject.error(L, errstr);
                    return false;
                }

                err = LuaDLL.lua_pcall(L, 0, 0, 0);
                if (err != 0)
                {
                    string errstr = LuaDLL.lua_tostring(L, -1);
                    LuaDLL.lua_pop(L, 1);
                    LuaObject.error(L, errstr);
                    return false;
                }

                LuaDLL.lua_settop(L, nOldTop);

                Debug.Log(" *** Reload Lua File Successful : " + strFileName);

                return true;
            }

            LuaObject.error(L, "Can't find {0}", strFileFullPath);

            return false;
        }

#endif

    }
}
