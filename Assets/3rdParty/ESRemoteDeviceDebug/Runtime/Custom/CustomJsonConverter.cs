using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Newtonsoft.Json.Converters;

namespace ESRemoteDeviceDebug
{
    public static class CustomJsonConverter
    {
        static bool s_IsUpdateProperty = false;

        public static void AddCustomJsonConverter()
        {
            if (s_IsUpdateProperty)
                return;

            s_IsUpdateProperty = true;

            ChangeData.CUSTOM_JSON_CONVERT_LIST.Add(new MainModuleConverter());
            ChangeData.CUSTOM_JSON_CONVERT_LIST.Add(new VelocityModuleConverter());
        }
    }
}

