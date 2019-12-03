using UnityEngine;
using System.IO;
using SLua;
using System;
using System.Threading;

namespace KG
{
    public class Init : MonoBehaviour
    {
        //IntPtr sharedAPI;
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
        }

        void Start()
        {
            //KG.ShareAPI.Init();
            //ShareAPI.CallCSharp(CppCallBack, 100);
            //sharedAPI = ShareAPI.CreateSharedAPI(11);
            //tcpClient = ShareAPI.CreateTcpClient();
            //bool ret = ShareAPI.Connect(tcpClient,"127.0.0.1",7000);
            //Debug.Log("GetMyIDPlusTen:" + ShareAPI.GetMyIDPlusTen(sharedAPI));
            //string serverIp = JsonTool.Instance.GetServerIp();
            //int serverPort = JsonTool.Instance.GetServerPort();
            //connectServer = NetWorkMgr.Connect(serverIp, serverPort);
        }

        void Update()
        {
            //ShareAPI.RunLoopOnce(tcpClient);
            if (connectServer)
            {
                //NetWorkMgr.RunLoopOnce();
            }
        }

        void OnDestory()
        {
            //ShareAPI.DeleteSharedAPI(sharedAPI);
        }

        private void CppCallBack(int value)
        {
            Debug.Log("CppCallBack " + value);
        }

        public byte[] LuaReourcesFileLoader(string fileName, ref string absoluteFn)
        {
            byte[] fileBytes = null;
            string filePath = null;
            //Debug.Log("fileName:" + fileName);
            if (WhetherGetScriptFromPersistentDataPath(fileName))
            {
                //Debug.Log("Get File From Persistent");
                filePath = GetScriptPersistentDataPath(fileName);
                //Debug.Log(filePath);
            }
            else
            {
                //Debug.Log("Get File From Streaming File");
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
            return Application.persistentDataPath + "/Script/Lua/" + fileName;
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
            //KG.NetWorkMgr.Disconnect();
        }
    }
}