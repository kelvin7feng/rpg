using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace ESRemoteDeviceDebug
{
    public class ImageElement : BaseComponentElement, IComponentDraw
    {
        public ImageElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
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
                            case "sprite":
                            case "color":
                            case "material":
                            case "raycastTarget":
                                DrawProperty(data);
                                break;
                            case "type":
                                DrawImageType(data);
                                break;
                        }
                    }
                }
            }

            EndDraw();
        }

        void DrawImageType(ChangeData imageTypeData)
        {
            ChangeData spriteData = GetChangeData("sprite");
            if (spriteData.ObjectReference.instanceId == 0)
                return;

            DrawProperty(imageTypeData);

            using (new EditorGUI.IndentLevelScope())
            {
                switch ((Image.Type)imageTypeData.IntValue)
                {
                    case Image.Type.Simple:
                        DrawProperty(GetChangeData("useSpriteMesh"));
                        DrawProperty(GetChangeData("preserveAspect"));
                        break;
                    case Image.Type.Sliced:
                    case Image.Type.Tiled:
                        DrawProperty(GetChangeData("fillCenter"));
                        break;
                    case Image.Type.Filled:
                        DrawFilled();
                        break;
                }
            }
        }

        void DrawFilled()
        {
            ChangeData fillMethodData = GetChangeData("fillMethod");
            DrawProperty(fillMethodData);

            ChangeData fillOriginData = GetChangeData("fillOrigin");

            string assemblyQualifiedName = null;
            switch ((Image.FillMethod)fillMethodData.IntValue)
            {
                case Image.FillMethod.Horizontal:
                    assemblyQualifiedName = typeof(Image.OriginHorizontal).AssemblyQualifiedName;
                    break;
                case Image.FillMethod.Vertical:
                    assemblyQualifiedName = typeof(Image.OriginVertical).AssemblyQualifiedName;
                    break;
                case Image.FillMethod.Radial90:
                    assemblyQualifiedName = typeof(Image.Origin90).AssemblyQualifiedName;
                    break;
                case Image.FillMethod.Radial180:
                    assemblyQualifiedName = typeof(Image.Origin180).AssemblyQualifiedName;
                    break;
                case Image.FillMethod.Radial360:
                    assemblyQualifiedName = typeof(Image.Origin360).AssemblyQualifiedName;
                    break;
            }

            fillOriginData.ChangeAssemblyQualifiedName(ChangeDataType.Enum, assemblyQualifiedName);

            DrawProperty(fillOriginData);
            DrawProperty(GetChangeData("fillAmount"));
            DrawProperty(GetChangeData("preserveAspect"));
        }
    }
}

