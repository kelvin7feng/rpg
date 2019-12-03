using UnityEngine;
using UnityEngine.SceneManagement;
using SLua;
using System;

namespace KG
{
    [CustomLuaClass]
    public class NetWorkMgr : MonoBehaviour
    {
        private static IntPtr tcpClient;
        private static bool isConnecting = false;
        private static bool connected = false;

        public static void SetConnected(bool connectedTag)
        {
            connected = connectedTag;
        }
        
        public static bool Connect(string ip, int port)
        {
            tcpClient = ShareAPI.CreateTcpClient();
            isConnecting = ShareAPI.Connect(tcpClient, ip, port);
            if (isConnecting)
            {
                Debug.Log("try to connect");
            }
            return isConnecting;
        }
        
        public static void Send(string msg)
        {
            if(!connected){
                //reconenect
            }

            bool ret = ShareAPI.Send(tcpClient, msg, msg.Length);
            if (ret)
            {
                Debug.Log("send successfully");
            }
            else
            {
                Debug.Log("failed to send");
            }
        }

        public static void SendToServer(uint serverId, uint eventId, string msg)
        {
            bool ret = ShareAPI.SendToServer(tcpClient, serverId, eventId, msg, msg.Length);
            if (ret)
            {
                Debug.Log("send successfully");
            }
            else
            {
                Debug.Log("failed to send");
            }
        }

        public static void RunLoopOnce()
        {
            ShareAPI.RunLoopOnce(tcpClient);
        }

        public static void Disconnect()
        {
            ShareAPI.Disconnect(tcpClient);
        }
    }

}
