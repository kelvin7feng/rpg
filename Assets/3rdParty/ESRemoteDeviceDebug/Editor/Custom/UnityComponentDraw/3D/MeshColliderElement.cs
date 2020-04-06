using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class MeshColliderElement : BaseComponentElement, IComponentDraw
    {
        public MeshColliderElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "convex":
                                DrawProperty(data, null, OnChangeConvex);
                                break;
                            case "isTrigger":
                                DrawIsTrigger(data);
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

        void DrawIsTrigger(ChangeData isTriggerData)
        {
            using (new EditorGUI.IndentLevelScope())
            {
                using(new EditorGUI.DisabledGroupScope(!GetChangeData("convex").BoolValue))
                {
                    DrawProperty(isTriggerData);
                }
            }
        }

        void OnChangeConvex(ChangeData convexData)
        {
            if (convexData.BoolValue)
                return;

            ChangeData isTriggerData = GetChangeData("isTrigger");
            if (!isTriggerData.BoolValue)
                return;

            isTriggerData.BoolValue = false;
            UpdateProperty(isTriggerData);
        }
    }
}

