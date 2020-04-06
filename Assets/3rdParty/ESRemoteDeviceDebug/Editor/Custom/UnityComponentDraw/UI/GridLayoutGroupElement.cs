using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace ESRemoteDeviceDebug
{
    public class GridLayoutGroupElement : BaseComponentElement, IComponentDraw
    {
        public GridLayoutGroupElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "constraintCount":
                                break;
                            case "constraint":
                                DrawConstraint(data);
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

        void DrawConstraint(ChangeData constraintData)
        {
            DrawProperty(constraintData);

            using (new EditorGUI.IndentLevelScope())
            {
                switch ((GridLayoutGroup.Constraint)constraintData.IntValue)
                {
                    case GridLayoutGroup.Constraint.FixedColumnCount:
                    case GridLayoutGroup.Constraint.FixedRowCount:
                        DrawProperty(GetChangeData("constraintCount"));
                        break;
                }
            }
        }
    }
}

