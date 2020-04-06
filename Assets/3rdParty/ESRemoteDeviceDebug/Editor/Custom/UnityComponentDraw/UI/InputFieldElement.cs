using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace ESRemoteDeviceDebug
{
    public class InputFieldElement : BaseComponentElement, IComponentDraw
    {
        public InputFieldElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "lineType":
                            case "caretColor":
                            case "inputType":
                            case "keyboardType":
                            case "characterValidation":
                                break;
                            case "contentType":
                                DrawContentType(data);
                                break;
                            case "customCaretColor":
                                DrawCustomCaretColor(data);
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

        void DrawContentType(ChangeData contentTypeData)
        {
            DrawProperty(contentTypeData);
            switch ((InputField.ContentType)contentTypeData.IntValue)
            {
                case InputField.ContentType.Standard:
                case InputField.ContentType.Autocorrected:
                    using (new EditorGUI.IndentLevelScope())
                    {
                        DrawProperty(GetChangeData("lineType"));
                    }
                    break;
                case InputField.ContentType.IntegerNumber:
                case InputField.ContentType.DecimalNumber:
                case InputField.ContentType.Alphanumeric:
                case InputField.ContentType.Name:
                case InputField.ContentType.EmailAddress:
                case InputField.ContentType.Password:
                case InputField.ContentType.Pin:
                    break;
                case InputField.ContentType.Custom:
                    using (new EditorGUI.IndentLevelScope())
                    {
                        DrawProperty(GetChangeData("lineType"));
                        DrawProperty(GetChangeData("inputType"));
                        DrawProperty(GetChangeData("keyboardType"));
                        DrawProperty(GetChangeData("characterValidation"));
                    }
                    break;
            }
        }

        void DrawCustomCaretColor(ChangeData customCaretColorData)
        {
            DrawProperty(customCaretColorData);
            if (customCaretColorData.BoolValue)
                DrawProperty(GetChangeData("caretColor"));
        }
    }
}

