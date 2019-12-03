using UnityEngine;
using SLua;

namespace KG
{
    [CustomLuaClass]
    public class CameraController : MonoBehaviour
    {

        private const float MIN_Y = 20.0f;
        private const float MAX_Y = 70.0f;

        public Transform target;

        public float pitchSpeed = 10f;
        public float pitchInput = 0.0f;

        public float yawSpeed = 10f;
        public float yawInput = 0.0f;

        public float currentX = 0.0f;
        public float currentY = 0.0f;
        public float distance = 10.0f;

        void Update()
        {
            currentX += pitchInput * pitchSpeed * Time.deltaTime;
            currentY -= yawInput * yawSpeed * Time.deltaTime;
            currentY = Mathf.Clamp(currentY, MIN_Y, MAX_Y);
        }

        void LateUpdate()
        {
            if (target == null)
                return;

            Vector3 dir = new Vector3(0, 0, -distance);
            Quaternion rotation = Quaternion.Euler(currentY, currentX, 0);
            transform.position = target.position + rotation * dir;
            transform.LookAt(target.position + Vector3.up * 2);
        }

        public void SetDeltaInput(float pitch, float yaw)
        {
            pitchInput = pitch;
            yawInput = yaw;
        }

        public void SetTarget(Transform transform)
        {
            target = transform;
        }
    }
}