using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Newtonsoft.Json.Converters
{
    public static class JsonHelper
    {
        public static string GetComponentValue(Component component, Type type)
        {
            string value = $"Name:{ (component == null ? "None" : component.name) }, Type: { type }";
            if (component != null)
                value = $"{value}, InstanceID: { component.GetInstanceID() }";

            return value;
        }
        
    }
}

