#if UNITY_EDITOR
using NodeCanvas.Framework;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace ParadoxNotion.Design
{
    class EditorCustomUtils
    {
        public static bool IsLuaClass(GUIContent content)
        {
            if (content.text.Equals("Str Lua Cls"))
            {
                return true;
            }
            return false;
        }

        public static bool IsAction(object context)
        {
            if (context == null)
                return false;
            bool isAction = context is KG.LuaAction;
            if (isAction)
            {
                return true;
            }
            return false;
        }

        public static void GenericPopup(GUIContent content, BBParameter bbParam, object context)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label("Str Lua Cls");
            bool isAction = IsAction(context);
            string[] options = GetFileList(isAction);
            int index = 0;
            if (bbParam.value != null)
            {
                for (int i = 0; i < options.Length; i++)
                {
                    if (options[i].IndexOf((string)bbParam.value) > -1)
                    {
                        index = i;
                        break;
                    }
                }
            }
            index = EditorGUILayout.Popup(index, options);
            if (index <= 0) bbParam.value = null;
            else bbParam.value = options[index];
            GUILayout.EndHorizontal();
        }

        public static string[] GetFileList(bool isAction)
        {
            List<string> options = new List<string>() { "None" };

            string fullPath = "";
            if (isAction)
            {
                fullPath = Application.dataPath + "/../Scripts/Lua/game/ai/action/";
            }
            else
            {
                fullPath = Application.dataPath + "/../Scripts/Lua/game/ai/condition/";
            }
            //Debug.Log(fullPath);
            if (Directory.Exists(fullPath))
            {
                DirectoryInfo dinfo = new DirectoryInfo(fullPath);
                FileInfo[] fi = dinfo.GetFiles();
                int size = dinfo.GetFiles().Length;
                string fileName;
                for (int i = 0; i < size; i++)
                {
                    fileName = fi[i].Name;
                    fileName = fileName.Substring(0, fileName.Length - 4);
                    options.Add(fileName);
                }
            }

            return options.ToArray();
        }
    }
}
#endif