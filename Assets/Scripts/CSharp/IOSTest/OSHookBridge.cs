using UnityEngine;
using System;
using System.Runtime.InteropServices;

public class OSHookBridge : MonoBehaviour
{
    [DllImport("__Internal")]
    public static extern void CallMethod();

    [DllImport("__Internal")]
    public static extern IntPtr ReturnString();

    [DllImport("__Internal")]
    public static extern int ReturnInt();
}
