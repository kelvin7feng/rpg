using SLua;
using UnityEngine;

namespace KG
{
    [CustomLuaClass]
    public class RendererSortingOrder : MonoBehaviour
    {
        [Tooltip("等于0就是由脚本自动设置order")]
        public int sortingOrder;

        private void setSortingOrder()
        {
            var renderers = GetComponentsInChildren<Renderer>();
            foreach (var r in renderers)
            {
                r.sortingOrder = sortingOrder;
            }
        }

        private void Start()
        {

            var trans = GetComponentsInChildren<Transform>();
            if (trans != null)
            {
                var dLayer = LayerMask.NameToLayer("UI");
                foreach (var child in trans)
                {
                    child.gameObject.layer = dLayer;
                }
            }
            if (sortingOrder == 0)
            {
                var canvas = transform.root.GetComponent<Canvas>();
                if (canvas)
                {
                    sortingOrder = canvas.sortingOrder + 1;
                }
            }
            setSortingOrder();
        }

        private void Update()
        {
#if UNITY_EDITOR
            setSortingOrder();
#endif
        }
    }
}