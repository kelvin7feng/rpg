using UnityEditor;
using UnityEngine;
using System.Linq;
using System.IO;
using System.Collections.Generic;

public class AssetBundleWindow : EditorWindow
{
    int platformIndex = 0;
    string[] platformOptions = { "Windows", "Android", "iOS", "OSX" };
    public string AssetBundlesOutputPath = "AssetBundles";
    static string[] buildPathList = new string[] { "Assets/ABRes" };
    static List<AssetBundleBuild> assetBundleBuildList = new List<AssetBundleBuild>();

    [MenuItem("Tool/AssetBundle")]
    public static void ShowWindow()
    {
        GetWindow<AssetBundleWindow>("AssetBundle");
    }

    void OnGUI()
    {
        platformIndex = EditorGUI.Popup(new Rect(0, 0, position.width, 20), "Target Platform:", platformIndex, platformOptions);
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        string platformFolder = platformOptions[platformIndex];
        AssetBundlesOutputPath = EditorGUILayout.TextField("Output Path:", AssetBundlesOutputPath);
        BuildTarget buildTarget = GetBuildTarget(platformIndex);
        if (GUILayout.Button("Build All Asset Bundles"))
        {
            BuildAllAssetBundles(AssetBundlesOutputPath, buildTarget);
        }
    }

    static void BuildAllAssetBundles(string outputPath, BuildTarget buildTarget)
    {
        Debug.Log("outputPath : " + outputPath);
        if (!Directory.Exists(outputPath))
        {
            Directory.CreateDirectory(outputPath);
        }

        BuildAssetBundles(outputPath, buildTarget);
        KG.FileTool.Instance.CopyAssetBundleToStreamingPath();
    }

    public static AssetBundleManifest BuildAssetBundles(string outputPath, BuildTarget buildTarget)
    {
        assetBundleBuildList.Clear();
        for (int i = 0; i < buildPathList.Length; ++i)
        {
            string searchPath = buildPathList[i];
            GetFiles(searchPath);
        }

        return BuildPipeline.BuildAssetBundles(outputPath, assetBundleBuildList.ToArray(), BuildAssetBundleOptions.None, buildTarget);
    }

    public static void GetFiles(string path)
    {
        var arrFiles = Directory.GetFiles(path, "*.*").Where(s => !s.EndsWith(".meta")).ToArray();

        if (arrFiles.Length > 0)
        {
            foreach (string strFile in arrFiles)
            {
                var importer = AssetImporter.GetAtPath(strFile);
                if (importer == null)
                {
                    continue;
                }

                var assetBundleName = importer.assetBundleName;
                var assetBundleVariant = importer.assetBundleVariant;
                AssetBundleBuild abb = new AssetBundleBuild();
                abb.assetBundleName = assetBundleName;
                abb.assetNames = new string[] { strFile };
                if (!string.IsNullOrEmpty(assetBundleVariant))
                {
                    abb.assetBundleVariant = assetBundleVariant;
                }
                assetBundleBuildList.Add(abb);
            }
        }

        string[] arrDirPath = Directory.GetDirectories(path);

        if (arrDirPath.Length > 0)
        {
            for (int i = 0; i < arrDirPath.Length; i++)
            {
                string strDirPath = arrDirPath[i];
                GetFiles(strDirPath);
            }
        }
    }

    public static BuildTarget GetBuildTarget(int target)
    {
        switch (target)
        {
            case 0:
                return BuildTarget.StandaloneWindows64;
            case 1:
                return BuildTarget.Android;
            case 2:
                return BuildTarget.iOS;
            case 3:
                return BuildTarget.StandaloneOSX;
            default:
                return BuildTarget.StandaloneWindows64;
        }
    }
}