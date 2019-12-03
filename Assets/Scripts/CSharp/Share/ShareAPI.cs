using System.Runtime.InteropServices;
using System;
using System.Text;
using UnityEngine;

namespace KG
{
    public class ShareAPI
    {
        public delegate void DebugCallback(string message);
        public delegate void NetMsgCallback(uint eventId, string str);
        public delegate void ConnectCallback(bool connected);

        const string DLL_NAME = "client_core";

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern IntPtr CreateTcpClient();

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern void Disconnect(IntPtr tcpClient);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern bool RunLoopOnce(IntPtr tcpClient);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern bool Connect(IntPtr tcpClient, [MarshalAs(UnmanagedType.LPStr)]string ip, int port);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern bool Send(IntPtr tcpClient, [MarshalAs(UnmanagedType.LPStr)]string msg, int size);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern bool SendToServer(IntPtr tcpClient, uint serverId, uint eventId, [MarshalAs(UnmanagedType.LPStr)]string msg, int size);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern int Add(int a, int b);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern void CallCSharp(Action<int> action, int input);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern IntPtr CreateSharedAPI(int ID);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern int GetMyIDPlusTen(IntPtr api);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern void DeleteSharedAPI(IntPtr api);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern void RegisterDebugCallback(DebugCallback callback);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern void RegisterNetMsgCallback(NetMsgCallback callback);

        [DllImport(DLL_NAME, CharSet = CharSet.Unicode)]
        public static extern void RegisterConnectCallback(ConnectCallback callback);

        public static void Init()
        {
            RegisterDebugCallback(new DebugCallback(DebugMethod));
            RegisterNetMsgCallback(new NetMsgCallback(NetMsg));
            RegisterConnectCallback(new ConnectCallback(OnConnectCallBack));
        }
        
        private static void DebugMethod(string message)
        {
            Debug.Log(message);
        }

        private static void NetMsg(uint eventId, string message)
        {
            if (eventId > 0)
            {
                Debug.Log(eventId);
                Debug.Log(message);
            }
        }

        private static void OnConnectCallBack(bool connected)
        {
            Debug.Log("connectStatus " + connected);
            KG.NetWorkMgr.SetConnected(connected);
        }
    }
}