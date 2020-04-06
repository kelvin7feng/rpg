using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace ESRemoteDeviceDebug
{
    public class CanvasScalerElement : BaseComponentElement, IComponentDraw
    {
        public CanvasScalerElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
        {
        }

        public void Draw()
        {
            StartDraw();

            if (m_IsFoldout)
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    foreach (var data in ComponentData.propertyList)
                    {
                        switch (data.propertyName)
                        {
                            case "uiScaleMode":
                                DrawUIScaleMode(data);
                                break;
                            case "referencePixelsPerUnit":
                                DrawProperty(data);
                                break;
                        }
                    }
                }
            }

            EndDraw();
        }

        void DrawUIScaleMode(ChangeData uiScaleModeData)
        {
            DrawProperty(uiScaleModeData);

            switch ((CanvasScaler.ScaleMode)uiScaleModeData.IntValue)
            {
                case CanvasScaler.ScaleMode.ConstantPixelSize:
                    DrawProperty(GetChangeData("scaleFactor"));
                    break;
                case CanvasScaler.ScaleMode.ScaleWithScreenSize:
                    DrawScaleWithScreenSize();
                    break;
                case CanvasScaler.ScaleMode.ConstantPhysicalSize:
                    DrawProperty(GetChangeData("physicalUnit"));
                    DrawProperty(GetChangeData("fallbackScreenDPI"));
                    DrawProperty(GetChangeData("defaultSpriteDPI"));
                    break;
            }
        }

        void DrawScaleWithScreenSize()
        {
            DrawProperty(GetChangeData("referenceResolution"));

            ChangeData screenMatchModeData = GetChangeData("screenMatchMode");
            DrawProperty(screenMatchModeData);
            switch ((CanvasScaler.ScreenMatchMode)screenMatchModeData.IntValue)
            {
                case CanvasScaler.ScreenMatchMode.MatchWidthOrHeight:
                    DrawProperty(GetChangeData("matchWidthOrHeight"));
                    break;
            }
        }
    }
}

