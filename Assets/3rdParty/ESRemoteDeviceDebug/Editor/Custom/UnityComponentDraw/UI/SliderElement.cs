using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class SliderElement : BaseComponentElement, IComponentDraw
    {
        public SliderElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
        {
        }

        void UpdateRange()
        {
            ChangeData minValue = GetChangeData("minValue");
            ChangeData maxValue = GetChangeData("maxValue");
            ChangeData value = GetChangeData("value");
            if (minValue == null || maxValue == null || value == null)
                return;

            value.SetRange(new RangeValue(minValue.FloatValue), new RangeValue(maxValue.FloatValue));
        }

        public void Draw()
        {
            StartDraw();

            if (m_IsFoldout)
            {
                UpdateRange();

                using (new EditorGUI.IndentLevelScope())
                {
                    foreach (var data in ComponentData.propertyList)
                        DrawProperty(data);
                }
            }

            EndDraw();
        }
    }
}

