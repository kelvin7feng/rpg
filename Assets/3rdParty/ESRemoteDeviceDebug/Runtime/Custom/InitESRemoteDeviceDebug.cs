using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    [RequireComponent(typeof(ESRemoteDeviceDebugClient))]
    public class InitESRemoteDeviceDebug : MonoBehaviour
    {
        const string c_Name = "Remote Debug";

        public static void Init()
        {
            ESRemoteDeviceDebugClient client = FindObjectOfType<ESRemoteDeviceDebugClient>();
            if (client == null)
            {
                GameObject go = new GameObject(c_Name);
                go.AddComponent<InitESRemoteDeviceDebug>();
            }
        }

        void OnEnable()
        {
            InitCustom();
            Destroy(this);
        }

        void InitCustom()
        {
            UnityComponentPropertyDefine.AddUnityComponentPropertyDefine();
            CustomComponentPropertyDefine.AddCustomComponentPropertyDefine();

            CustomUpdatePropertyUtility.AddCustomUpdateProperty();
            CustomJsonConverter.AddCustomJsonConverter();
        }

    }
}

