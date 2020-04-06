using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace ESRemoteDeviceDebug
{
    public static class UnityCompomentDrawFactory
    {
        [InitializeOnLoadMethod]
        internal static void InitUnityCompomentDraw()
        {
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(ParticleSystem), (componentInstanceId, inspectorView) => { return new ParticleSystemElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(Camera), (componentInstanceId, inspectorView) => { return new CameraElement(componentInstanceId, inspectorView); });

            #region UI

            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(Slider), (componentInstanceId, inspectorView) => { return new SliderElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(Image), (componentInstanceId, inspectorView) => { return new ImageElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(Canvas), (componentInstanceId, inspectorView) => { return new CanvasElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(CanvasScaler), (componentInstanceId, inspectorView) => { return new CanvasScalerElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(InputField), (componentInstanceId, inspectorView) => { return new InputFieldElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(ScrollRect), (componentInstanceId, inspectorView) => { return new ScrollRectElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(LayoutElement), (componentInstanceId, inspectorView) => { return new LayoutElementElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(GridLayoutGroup), (componentInstanceId, inspectorView) => { return new GridLayoutGroupElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(HorizontalLayoutGroup), (componentInstanceId, inspectorView) => { return new HorizontalLayoutGroupElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(VerticalLayoutGroup), (componentInstanceId, inspectorView) => { return new VerticalLayoutGroupElement(componentInstanceId, inspectorView); });

            #endregion

            #region 2D

            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(SpriteRenderer), (componentInstanceId, inspectorView) => { return new SpriteRendererElement(componentInstanceId, inspectorView); });

            #endregion

            #region 3D

            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(MeshCollider), (componentInstanceId, inspectorView) => { return new MeshColliderElement(componentInstanceId, inspectorView); });
            ComponentDrawFactory.AddCustomComponentDrawAction(typeof(Light), (componentInstanceId, inspectorView) => { return new LightElement(componentInstanceId, inspectorView); });
            
            #endregion
        }
    }
}

