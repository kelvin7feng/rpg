using System;
using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class LayoutElementElement : BaseComponentElement, IComponentDraw
    {
        public LayoutElementElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "ignoreLayout":
                                DrawIgnoreLayout(data);
                                break;
                            case "layoutPriority":
                                DrawProperty(data);
                                break;
                        }
                    }
                }
            }

            EndDraw();
        }

        ComponentData GetGameObjectComponentData(Type type)
        {
            if (!InspectorTab.Instance.AllGameObjectInspectorViewMap.ContainsKey(ComponentData.gameObjectInstanceId))
                return null;

            GameObjectData goData = InspectorTab.Instance.AllGameObjectInspectorViewMap[ComponentData.gameObjectInstanceId].GameObjectData;

            foreach (var componentId in goData.componentInstanceIdList)
            {
                if (!InspectorTab.Instance.AllComponentMap.ContainsKey(componentId))
                    continue;

                ComponentData componentData = InspectorTab.Instance.AllComponentMap[componentId];
                if (componentData.Type == type)
                    return componentData;
            }

            return null;
        }

        void DrawIgnoreLayout(ChangeData ignoreLayoutData)
        {
            DrawProperty(ignoreLayoutData);
            if (ignoreLayoutData.BoolValue)
                return;

            ComponentData componentData = GetGameObjectComponentData(typeof(RectTransform));

            ChangeData rectData = GetChangeData(componentData, "rect");

            DrawLayoutElementField(GetChangeData("minWidth"), 0);
            DrawLayoutElementField(GetChangeData("minHeight"), 0);
            DrawLayoutElementField(GetChangeData("preferredWidth"), rectData.RectValue.width);
            DrawLayoutElementField(GetChangeData("preferredHeight"), rectData.RectValue.height);
            DrawLayoutElementField(GetChangeData("flexibleWidth"), 1);
            DrawLayoutElementField(GetChangeData("flexibleHeight"), 1);
        }

        void DrawLayoutElementField(ChangeData data, float defaultValue)
        {
            Rect rect = DrawPosition;
            rect.height = LINE_HEIGHT;
            rect.width = 170 + InspectorView.LabelWidthOffset;

            bool hasChange = false;

            bool curEnabled = data.FloatValue >= 0;
            bool enabled = EditorGUI.Toggle(rect, GetVariableName(data), curEnabled);
            if (enabled != curEnabled)
            {
                data.FloatValue = (enabled ? defaultValue : -1);
                hasChange = true;
            }

            if (data.FloatValue >= 0)
            {
                rect.x = rect.xMax;
                rect.width = DrawPosition.width - rect.x;

                float old = EditorGUIUtility.labelWidth;
                EditorGUIUtility.labelWidth = 4; // Small invisible label area for drag zone functionality
                float newValue = EditorGUI.FloatField(rect, new GUIContent(" "), data.FloatValue);
                if (newValue != data.FloatValue)
                {
                    data.FloatValue = Mathf.Max(0, newValue);
                    hasChange = true;
                }
                EditorGUIUtility.labelWidth = old;
            }

            if (hasChange)
                UpdateProperty(data);

            m_LineCount++;
            DrawPosition.y = rect.yMax + m_Space;
        }
    }
}

