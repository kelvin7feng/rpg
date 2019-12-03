using System;
using UnityEngine;
using SLua;

namespace KG
{
    [CustomLuaClassAttribute]
    public class AreaMask
    {
        public static int ALL_AREA = -1;
        public static int WALKABLE = 0;
        public static int NOT_WALKABLE = 1;

        public static int MASK_FOR_ALL_AREA = -1;
        public static int MASK_FOR_WALKABLE = 1 << WALKABLE;
    }
}