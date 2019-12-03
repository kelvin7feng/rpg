using UnityEngine;
using UnityEngine.EventSystems;

namespace KG
{
    public class VirtualCameraJoystick : MonoBehaviour, IDragHandler, IPointerUpHandler, IPointerDownHandler
    {
        public CameraController cameraController;
        Vector3 startPoint = Vector3.zero;

        void Start()
        {

        }

        public void OnDrag(PointerEventData eventData)
        {
            Vector2 pos = eventData.position;
            float yaw = pos.x - startPoint.x;
            startPoint = pos;
        }

        public void OnPointerDown(PointerEventData eventData)
        {
            startPoint = eventData.pressPosition;
        }

        public void OnPointerUp(PointerEventData eventData)
        {
            startPoint = Vector3.zero;
        }
    }
}