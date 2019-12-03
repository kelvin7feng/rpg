using SLua;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace KG
{
    [CustomLuaClassAttribute]
    public class AssetLoader
    {
        public static Object LoadAssetAsync(string assetBundleName, string assetName)
        {
#if UNITY_EDITOR
            string[] assetPaths = AssetDatabase.GetAssetPathsFromAssetBundleAndAssetName(assetBundleName, assetName);
            if (assetPaths.Length == 0)
            {
                Debug.LogError("There is no asset with name \"" + assetName + "\" in " + assetBundleName);
                return null;
            }
            
            Object target = AssetDatabase.LoadMainAssetAtPath(assetPaths[0]);
            return target;
#else
            return null;
#endif
        }
    }
}