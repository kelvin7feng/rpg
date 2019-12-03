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

        public void OnDrawGizmos()
        {
#if UNITY_EDITOR
            foreach (MonsterObject monsterObject in monsters)
            {
                if (monsterObject != null)
                {
                    Transform spawnTransform = monsterObject.spawnPosition;
                    if (spawnTransform)
                    {
                        //draw arrow
                        ForGizmo(spawnTransform.position + Vector3.up * 0.1f, spawnTransform.forward, Color.green);
                    }
                }
            }
#endif
        }

        public static void ForGizmo(Vector3 pos, Vector3 direction, Color color, float arrowHeadLength = 0.25f, float arrowHeadAngle = 20.0f)
        {
            if (direction.Equals(Vector3.zero))
            {
                return;
            }

            Gizmos.color = color;
            Gizmos.DrawRay(pos, direction);

            Vector3 right = Quaternion.LookRotation(direction) * Quaternion.Euler(0, 180 + arrowHeadAngle, 0) * new Vector3(0, 0, 1);
            Vector3 left = Quaternion.LookRotation(direction) * Quaternion.Euler(0, 180 - arrowHeadAngle, 0) * new Vector3(0, 0, 1);
            Gizmos.DrawRay(pos + direction, right * arrowHeadLength);
            Gizmos.DrawRay(pos + direction, left * arrowHeadLength);
        }
    }
}