using System;
using UnityEngine;
using SLua;

namespace KG
{
    [CustomLuaClassAttribute]
    public class Layer
    {
        public static int DEFAULT = 0;
        public static int GROUND = 8;
        
        public static int MASK_FOR_GROUND = 1 << GROUND;
    }
}

