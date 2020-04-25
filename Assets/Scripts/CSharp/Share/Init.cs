using UnityEngine;
using System.IO;
using SLua;
using System;
using System.Threading;

namespace KG
{
    public class Init : MonoBehaviour
    { 
        public static bool connectServer = false;
        public static int sendCount = 0;

        void Awake()
        {
            //KG.Logger.Instance.Register();

            LuaSvr svr = new LuaSvr();
            LuaSvr.mainState.loaderDelegate += LuaReourcesFileLoader;
            svr.init(null, () =>
            {
                svr.start("main");
            });
            Application.targetFrameRate = 30;
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
        }

        void Start()
        {

        }

        void Update()
        {
            CustomZip.CheckUnzipCallback();
        }

        void OnDestory()
        {
            
        }

        private void CppCallBack(int value)
        {
            Debug.Log("CppCallBack " + value);
        }

        public byte[] LuaReourcesFileLoader(string fileName, ref string absoluteFn)
        {
            byte[] fileBytes = null;
            string filePath = null;
            if (WhetherGetScriptFromPersistentDataPath(fileName))
            {
                filePath = GetScriptPersistentDataPath(fileName);
            }
            else
            {
                filePath = GetStreamingAssetPath(fileName);
            }
            if (filePath.Contains("://"))
            {
                WWW www = new WWW(filePath);
                while (!www.isDone)
                {
                    Thread.Sleep(30);
                }
                fileBytes = www.bytes;
            }
            else
            {
                fileBytes = System.IO.File.ReadAllBytes(filePath);
            }
            return fileBytes;
        }

        public static string GetStreamingAssetPath(string fileName)
        {
            if (!fileName.Contains(".lua"))
            {
                fileName += ".lua";
            }
            string filePath = null;
#if UNITY_ANDROID  //android
            filePath = System.IO.Path.Combine(Application.streamingAssetsPath, "Scripts/Lua/" + fileName);
#elif UNITY_IPHONE //iPhone
            filePath = Application.streamingAssetsPath + "/Scripts/Lua/" + fileName;
#elif UNITY_STANDALONE_WIN || UNITY_EDITOR
            filePath = Application.dataPath + "/../Scripts/Lua/" + fileName;
            bool bExist = System.IO.File.Exists(filePath);
            if (!bExist)
            {
                //for share
                filePath = Application.dataPath + "/../../" + fileName;
            }
#else
            filePath = string.Empty;
#endif
                return filePath;
        }

        public static string GetScriptPersistentDataPath(string fileName)
        {
            if (!fileName.Contains(".lua"))
            {
                fileName += ".lua";
            }
            string filePath = Application.persistentDataPath + "/Scripts/Lua/" + fileName;
            bool bExist = System.IO.File.Exists(filePath);
            if (!bExist)
            {
                //for share
                filePath = Application.persistentDataPath + "/" + fileName;
            }
            return filePath;
        }

        public static bool WhetherGetScriptFromPersistentDataPath(string fileName)
        {
            string filePath = GetScriptPersistentDataPath(fileName);
            bool bExist = System.IO.File.Exists(filePath);
            return bExist;
        }

        void OnApplicationQuit()
        {
            Debug.Log("Application ending after " + Time.time + " seconds");
        }
    }
}