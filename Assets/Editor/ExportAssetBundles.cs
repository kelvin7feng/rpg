using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

public class ExportAssetBundles {

    static string outputPath = "Assets/AssetBundles";
    static string[] buildPathList = new string[] { "Assets/ABRes"};
    static List<AssetBundleBuild> assetBundleBuildList = new List<AssetBundleBuild>();

    [MenuItem("Assets/BuildAsset")]
    static void ExportResource()
    {
        if (Directory.Exists(outputPath) == false)
        {
            Directory.CreateDirectory(outputPath);
        }
        
        BuildAssetBundles(outputPath);
    }

    public static void getFiles(string path)
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
                getFiles(strDirPath);
            }
        }
    }

    public static AssetBundleManifest BuildAssetBundles(string outputPath)
    {
        assetBundleBuildList.Clear();
        for (int i = 0; i < buildPathList.Length; ++i)
        {
            string searchPath = buildPathList[i];
            getFiles(searchPath);
        }

        return BuildPipeline.BuildAssetBundles(outputPath, assetBundleBuildList.ToArray(), BuildAssetBundleOptions.None, EditorUserBuildSettings.activeBuildTarget);
    }
}
