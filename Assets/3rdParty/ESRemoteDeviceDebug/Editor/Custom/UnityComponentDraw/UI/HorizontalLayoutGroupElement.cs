using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class HorizontalLayoutGroupElement : BaseComponentElement, IComponentDraw
    {
        public HorizontalLayoutGroupElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "padding":
                            case "spacing":
                            case "childAlignment":
                                DrawProperty(data);
                                break;
                        }
                    }

                    DrawController("Control Child Size", "childControlWidth", "childControlHeight");
                    DrawController("Use Child Scale", "childScaleWidth", "childScaleHeight");
                    DrawController("Control Force Expand", "childForceExpandWidth", "childForceExpandHeight");
                }
            }

            EndDraw();
        }

        void DrawController(string label, string widthName, string heightName)
        {
            ChangeData widthData = GetChangeData(widthName);
            ChangeData heightData = GetChangeData(heightName);
            if (widthData == null || heightData == null)
                return;

            Rect rect = DrawPosition;
            rect.height = LINE_HEIGHT;

            rect.width = 130 + InspectorView.LabelWidthOffset;
            EditorGUI.LabelField(rect, label);

            rect.x += rect.width + 4;
            string toggleLabel = "Width";
            rect.width = 30 + ESGUIHelper.CalcSize(toggleLabel).x;

            bool newWidthValue = EditorGUI.ToggleLeft(rect, toggleLabel, widthData.BoolValue);
            if (newWidthValue != widthData.BoolValue)
            {
                widthData.BoolValue = newWidthValue;
                UpdateProperty(widthData);
            }

            toggleLabel = "Height";
            rect.x = rect.xMax + 4;
            rect.width = 30 + ESGUIHelper.CalcSize(toggleLabel).x;

            bool newHeightValue = EditorGUI.ToggleLeft(rect, toggleLabel, heightData.BoolValue);
            if (newHeightValue != heightData.BoolValue)
            {
                heightData.BoolValue = newHeightValue;
                UpdateProperty(heightData);
            }

            m_LineCount++;
            DrawPosition.y = rect.yMax + m_Space;
        }
    }
}

