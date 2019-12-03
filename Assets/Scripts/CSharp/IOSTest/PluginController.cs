using UnityEngine;
using System.Runtime.InteropServices;

public class PluginController : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Debug.Log("OSHookBridge.ReturnInt():" + OSHookBridge.ReturnInt());
        Debug.Log("OSHookBridge.ReturnString():" + Marshal.PtrToStringAuto(OSHookBridge.ReturnString()));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
