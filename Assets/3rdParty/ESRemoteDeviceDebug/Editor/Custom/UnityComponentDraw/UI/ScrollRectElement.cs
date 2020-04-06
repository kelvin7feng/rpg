using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace ESRemoteDeviceDebug
{
    public class ScrollRectElement : BaseComponentElement, IComponentDraw
    {
        public ScrollRectElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "movementType":
                                DrawMovementType(data);
                                break;
                            case "inertia":
                                DrawInertia(data);
                                break;
                            case "horizontalScrollbar":
                                DrawScrollbar(data, "horizontalScrollbarVisibility", "horizontalScrollbarSpacing");
                                break;
                            case "verticalScrollbar":
                                DrawScrollbar(data, "verticalScrollbarVisibility", "verticalScrollbarSpacing");
                                break;
                            case "elasticity":
                            case "decelerationRate":
                            case "horizontalScrollbarVisibility":
                            case "horizontalScrollbarSpacing":
                            case "verticalScrollbarVisibility":
                            case "verticalScrollbarSpacing":
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

        void DrawMovementType(ChangeData movementTypeData)
        {
            DrawProperty(movementTypeData);
            switch ((ScrollRect.MovementType)movementTypeData.IntValue)
            {
                case ScrollRect.MovementType.Elastic:
                    using (new EditorGUI.IndentLevelScope())
                    {
                        DrawProperty(GetChangeData("elasticity"));
                    }
                    break;
            }
        }

        void DrawInertia(ChangeData inertiaData)
        {
            DrawProperty(inertiaData);
            if (inertiaData.BoolValue)
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    DrawProperty(GetChangeData("decelerationRate"));
                }
            }
        }

        void DrawScrollbar(ChangeData scrollbarData, string visibilityName, string spacingName)
        {
            DrawProperty(scrollbarData);
            if (scrollbarData.ObjectReference.instanceId != 0)
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    DrawProperty(GetChangeData(visibilityName));
                    DrawProperty(GetChangeData(spacingName));
                }
            }
        }
    }
}

