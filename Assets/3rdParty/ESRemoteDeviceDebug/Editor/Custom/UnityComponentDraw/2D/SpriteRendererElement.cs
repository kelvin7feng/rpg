using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class SpriteRendererElement : BaseComponentElement, IComponentDraw
    {
        public SpriteRendererElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView) { }

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
                            case "flipY":
                            case "size":
                            case "tileMode":
                                break;
                            case "drawMode":
                                DrawDrawMode(data);
                                break;
                            case "flipX":
                                DrawFlip(data);
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

        void DrawFlip(ChangeData flipXData)
        {
            Rect rect = DrawPosition;
            rect.height = LINE_HEIGHT;

            rect.width = 130 + InspectorView.LabelWidthOffset;
            EditorGUI.LabelField(rect, "Flip");

            rect.x += rect.width + 4;
            string toggleLabel = "X";
            rect.width = 30 + ESGUIHelper.CalcSize(toggleLabel).x;

            bool newXValue = EditorGUI.ToggleLeft(rect, toggleLabel, flipXData.BoolValue);
            if (newXValue != flipXData.BoolValue)
            {
                flipXData.BoolValue = newXValue;
                UpdateProperty(flipXData);
            }

            toggleLabel = "Y";
            rect.x = rect.xMax + 4;
            rect.width = 30 + ESGUIHelper.CalcSize(toggleLabel).x;

            ChangeData flipYData = GetChangeData("flipY");
            bool newYValue = EditorGUI.ToggleLeft(rect, toggleLabel, flipYData.BoolValue);
            if (newYValue != flipYData.BoolValue)
            {
                flipYData.BoolValue = newYValue;
                UpdateProperty(flipYData);
            }

            m_LineCount++;

            DrawPosition.y = rect.yMax + m_Space;
        }

        void DrawDrawMode(ChangeData drawModeData)
        {
            DrawProperty(drawModeData);
            
            using(new EditorGUI.IndentLevelScope())
            {
                switch ((SpriteDrawMode)drawModeData.IntValue)
                {
                    case SpriteDrawMode.Sliced:
                        DrawProperty(GetChangeData("size"));
                        break;
                    case SpriteDrawMode.Tiled:
                        DrawProperty(GetChangeData("size"));
                        DrawProperty(GetChangeData("tileMode"));
                        break;
                }
            }
        }
    }
}

