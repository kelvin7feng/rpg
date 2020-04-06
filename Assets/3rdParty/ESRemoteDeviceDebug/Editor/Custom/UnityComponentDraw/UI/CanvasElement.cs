using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class CanvasElement : BaseComponentElement, IComponentDraw
    {
        public CanvasElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
        {
            m_FixedHeight = m_Space;
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
                            case "renderMode":
                                DrawRenderMode(data);
                                break;
                            case "additionalShaderChannels":
                                DrawProperty(data);
                                break;
                        }
                    }
                }
            }

            EndDraw();
        }

        void DrawRenderMode(ChangeData renderModeData)
        {
            DrawProperty(renderModeData);

            using (new EditorGUI.IndentLevelScope())
            {
                switch ((RenderMode)renderModeData.IntValue)
                {
                    case RenderMode.ScreenSpaceOverlay:
                        DrawScreenSpaceOverlay();
                        break;
                    case RenderMode.ScreenSpaceCamera:
                        DrawScreenSpaceCamera();
                        break;
                    case RenderMode.WorldSpace:
                        DrawWorldSpace();
                        break;
                }
            }
        }

        void DrawScreenSpaceOverlay()
        {
            DrawProperty(GetChangeData("pixelPerfect"));
            DrawProperty(GetChangeData("sortingOrder"));
            // TODO 
            DrawProperty(GetChangeData("targetDisplay"));
        }

        void DrawScreenSpaceCamera()
        {
            DrawProperty(GetChangeData("pixelPerfect"));

            ChangeData renderCamera = GetChangeData("worldCamera");
            DrawProperty(renderCamera);
            if (renderCamera.ObjectReference.instanceId != 0)
            {
                DrawProperty(GetChangeData("planeDistance"));
                DrawProperty(GetChangeData("sortingLayerID"));
            }
            else
                RemoteDeviceDebugWindow.Instance.ShowNotification(ESGUIHelper.TempContent("Render Camera Is None"));

            DrawProperty(GetChangeData("sortingOrder"), ObjectNames.NicifyVariableName("OderInLayer"));
        }

        void DrawWorldSpace()
        {
            DrawProperty(GetChangeData("worldCamera"), ObjectNames.NicifyVariableName("eventCamera"));
            DrawProperty(GetChangeData("sortingLayerID"));
            DrawProperty(GetChangeData("sortingOrder"), ObjectNames.NicifyVariableName("OderInLayer"));
        }
    }
}

