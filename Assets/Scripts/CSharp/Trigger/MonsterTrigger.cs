using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SLua;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace KG
{
    [CustomLuaClassAttribute]
    public class MonsterTrigger : BaseTrigger
    {
        [System.Serializable]
        public class MonsterObject
        {
            public int monsterId;
            public Transform spawnPosition;
        }

        public List<MonsterObject> monsters = new List<MonsterObject>();

        protected override void Start()
        {
            base.Start();
            SetTriggerCount(1);
            SetTriggerName("monster_trigger");
        }
    }
}