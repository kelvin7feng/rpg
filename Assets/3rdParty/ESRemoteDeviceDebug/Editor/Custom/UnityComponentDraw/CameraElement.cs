using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class CameraElement : BaseComponentElement, IComponentDraw
    {
        enum ProjectionType { Perspective, Orthographic };

        public CameraElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "farClipPlane":
                                break;
                            case "nearClipPlane":
                                DrawLabelField("Clipping Planes");
                                using (new EditorGUI.IndentLevelScope())
                                {
                                    DrawProperty(data);
                                    DrawProperty(GetChangeData("farClipPlane"));
                                }
                                break;
                            case "backgroundColor":
                                if (GetChangeData("clearFlags").IntValue != (int)CameraClearFlags.Nothing)
                                    DrawProperty(data);
                                break;
                            case "orthographic":
                                DrawOrthographic(data);
                                break;
                            case "fieldOfView":
                                if (!GetChangeData("orthographic").BoolValue)
                                    DrawProperty(data);
                                break;
                            case "orthographicSize":
                                if (GetChangeData("orthographic").BoolValue)
                                    DrawProperty(data);
                                break;
                            case "usePhysicalProperties":
                                if (!GetChangeData("orthographic").BoolValue)
                                {
                                    DrawProperty(data);
                                    if (data.BoolValue)
                                        using (new EditorGUI.IndentLevelScope())
                                            DrawSensorType();
                                }
                                break;
                            case "focalLength":
                            case "sensorSize":
                            case "lensShift":
                                if (!GetChangeData("usePhysicalProperties").BoolValue)
                                    break;

                                using (new EditorGUI.IndentLevelScope())
                                {
                                    DrawProperty(data);
                                }
                                break;
                            default:
                                DrawProperty(data);
                                break;
                        }
                    }
                }
            }

            EndDraw();
        }

        void DrawOrthographic(ChangeData orthographicData)
        {
            Rect rect = DrawPosition;
            ProjectionType projectionType = orthographicData.BoolValue ? ProjectionType.Orthographic : ProjectionType.Perspective;

            rect.height = LINE_HEIGHT;
            m_LineCount++;

            ProjectionType newType = (ProjectionType)EditorGUI.EnumPopup(rect, "Projection", projectionType);
            if (newType != projectionType)
            {
                orthographicData.BoolValue = (newType == ProjectionType.Orthographic);
                UpdateProperty(orthographicData);
            }

            DrawPosition.y = rect.yMax + m_Space;
        }

        #region DrawSensorType

        static readonly string[] k_ApertureFormatNames =
        {
            "8mm",
            "Super 8mm",
            "16mm",
            "Super 16mm",
            "35mm 2-perf",
            "35mm Academy",
            "Super-35",
            "65mm ALEXA",
            "70mm",
            "70mm IMAX",
            "Custom"
        };

        static readonly Vector2[] k_ApertureFormatValues =
        {
            new Vector2(4.8f, 3.5f) , // 8mm
            new Vector2(5.79f, 4.01f) , // Super 8mm
            new Vector2(10.26f, 7.49f) , // 16mm
            new Vector2(12.52f, 7.41f) , // Super 16mm
            new Vector2(21.95f, 9.35f) , // 35mm 2-perf
            new Vector2(21.0f, 15.2f) , // 35mm academy
            new Vector2(24.89f, 18.66f) , // Super-35
            new Vector2(54.12f, 25.59f) , // 65mm ALEXA
            new Vector2(70.0f, 51.0f) , // 70mm
            new Vector2(70.41f, 52.63f), // 70mm IMAX
        };

        void DrawSensorType()
        {
            Rect rect = DrawPosition;
            rect.height = LINE_HEIGHT;
            m_LineCount++;

            ChangeData sensorSizeData = GetChangeData("sensorSize");

            int filmGateIndex = Array.IndexOf(k_ApertureFormatValues, new Vector2((float)Math.Round(sensorSizeData.Vector2Value.x, 3), (float)Math.Round(sensorSizeData.Vector2Value.y, 3)));
            int selectIndex = filmGateIndex == -1 ? k_ApertureFormatNames.Length - 1 : filmGateIndex;

            int newSelectIndex = EditorGUI.Popup(rect, "Sensor Type", selectIndex, k_ApertureFormatNames);
            if (newSelectIndex != selectIndex && newSelectIndex < k_ApertureFormatValues.Length)
            {
                sensorSizeData.Vector2Value = k_ApertureFormatValues[newSelectIndex];
                UpdateProperty(sensorSizeData);
            }

            DrawPosition.y = rect.yMax + m_Space;
        }

        #endregion
    }
}

