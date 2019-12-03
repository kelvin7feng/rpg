using UnityEngine;
using SLua;

namespace KG
{
    [CustomLuaClass]
    public class MinimapFollow : MonoBehaviour
    {
        public Transform target;
        public float height;

        void LateUpdate()
        {
            if (target == null)
                return;

            transform.position = target.position + Vector3.up * height;
        }

        public void SetTarget(Transform transform)
        {
            target = transform;
        }
    }
}