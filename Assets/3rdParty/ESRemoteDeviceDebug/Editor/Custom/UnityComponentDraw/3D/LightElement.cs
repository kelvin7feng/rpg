using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class LightElement : BaseComponentElement, IComponentDraw
    {
        public LightElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
        {
        }

        public void Draw()
        {
            StartDraw();

            if (m_IsFoldout)
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    DrawLightType();
                    DrawProperty(GetChangeData("color"));

                    using (new EditorGUI.DisabledGroupScope(true))
                    {
                        DrawProperty(GetChangeData("lightmapBakeType"));
                    }

                    DrawProperty(GetChangeData("intensity"));
                    DrawProperty(GetChangeData("bounceIntensity"));

                    DrawShadowType();

                    DrawProperty(GetChangeData("flare"));
                    DrawProperty(GetChangeData("renderMode"));
                    DrawProperty(GetChangeData("cullingMask"));
                }
            }

            EndDraw();
        }

        void DrawLightType()
        {
            ChangeData lightTypeData = GetChangeData("type");
            DrawProperty(lightTypeData);
            switch ((LightType)lightTypeData.IntValue)
            {
                case LightType.Spot:
                    DrawProperty(GetChangeData("range"));
                    DrawProperty(GetChangeData("spotAngle"));
                    break;
                case LightType.Directional:
                    break;
                case LightType.Point:
                    DrawProperty(GetChangeData("range"));
                    break;
                case LightType.Area:
                    using (new EditorGUI.DisabledGroupScope(true))
                    {
                        DrawProperty(GetChangeData("range"));
                    }
                    break;
            }
        }

        void DrawShadowType()
        {
            ChangeData lightTypeData = GetChangeData("type");
            ChangeData shadowsTypeData = GetChangeData("shadows");

            Rect rect = DrawPosition;
            if (lightTypeData.IntValue == (int)LightType.Area)
            {
                rect.height = LINE_HEIGHT;
                m_LineCount++;
                bool isToggle = shadowsTypeData.IntValue != (int)LightShadows.None;
                bool shadows = EditorGUI.Toggle(rect, "Cast Shadows", isToggle);
                if (shadows != isToggle)
                {
                    shadowsTypeData.IntValue = shadows ? (int)LightShadows.Soft : (int)LightShadows.None;
                    UpdateProperty(shadowsTypeData);
                }

                DrawPosition.y = rect.yMax + m_Space;
                return;
            }

            DrawProperty(shadowsTypeData);

            ChangeData bakeTypeData = GetChangeData("lightmapBakeType");
            if (bakeTypeData != null)
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    switch ((LightmapBakeType)bakeTypeData.IntValue)
                    {
                        case LightmapBakeType.Realtime:
                            DrawRealtime(lightTypeData, shadowsTypeData);
                            using (new EditorGUI.IndentLevelScope(-1))
                            {
                                DrawProperty(GetChangeData("cookie"));
                            }
                            break;
                        case LightmapBakeType.Baked:
                            DrawBaked(lightTypeData, shadowsTypeData);
                            break;
                        case LightmapBakeType.Mixed:
                            break;
                    }
                }
            }
            else
            {
                DrawRealtime(lightTypeData, shadowsTypeData);
                DrawProperty(GetChangeData("cookie"));
            }
        }

        void DrawBaked(ChangeData lightTypeData, ChangeData shadowsTypeData)
        {
            if (shadowsTypeData.IntValue == (int)LightShadows.None)
                return;

            using (new EditorGUI.IndentLevelScope())
            {
                using (new EditorGUI.DisabledGroupScope(shadowsTypeData.IntValue == (int)LightShadows.Hard))
                {
                    switch ((LightType)lightTypeData.IntValue)
                    {
                        case LightType.Directional:
                            DrawProperty(GetChangeData("shadowAngle"));
                            break;
                        case LightType.Spot:
                        case LightType.Point:
                            DrawProperty(GetChangeData("shadowRadius"));
                            break;
                    }
                }
            }
        }

        void DrawRealtime(ChangeData lightTypeData, ChangeData shadowsTypeData)
        {
            if (shadowsTypeData.IntValue == (int)LightShadows.None)
                return;

            using (new EditorGUI.IndentLevelScope())
            {
                DrawLabelField("Realtime Shadows");

                using (new EditorGUI.IndentLevelScope())
                {
                    DrawProperty(GetChangeData("shadowStrength"));
                    DrawProperty(GetChangeData("shadowResolution"));
                    DrawProperty(GetChangeData("shadowBias"));
                    DrawProperty(GetChangeData("shadowNormalBias"));
                    DrawProperty(GetChangeData("shadowNearPlane"));
                }
            }
        }

    }
}

