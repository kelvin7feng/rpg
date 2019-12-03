using System;
using System.Collections;
using UnityEngine;
using SLua;
using System.Collections.Generic;

namespace KG
{
    [CustomLuaClass]
    public class AssetBundleUtils : MonoBehaviour
    {
        #region:STREAMING_ASSET_PATH
        public static readonly string STREAMING_ASSET_PATH =
#if UNITY_ANDROID   // Android
            Application.streamingAssetsPath;
#elif UNITY_IPHONE  // iPhone
            Application.dataPath + "/Raw/";
#else               // PC or other platform
            Application.streamingAssetsPath + "/../../AssetBundles";
#endif
        #endregion
        #region:MANIFET_NAME
        public static readonly string MANIFET_NAME = "AssetBundles";
        #endregion

        private Dictionary<string, AssetBundle> loadedAssetBundle = new Dictionary<string, AssetBundle>();

        private static AssetBundleUtils _Instance;

        public static AssetBundleUtils Instance
        {
            get
            {
                if (_Instance == null)
                {
                    GameObject go = GameObject.Find("AssetBundleUtils");
                    if (go == null)
                    {
                        go = new GameObject("AssetBundleUtils");
                        GameObject.DontDestroyOnLoad(go);
                    }

                    _Instance = go.AddComponent<AssetBundleUtils>();
                }
                return _Instance;
            }
           
        }

        static public void UnloadAssetBundle(string assetBundleName)
        {
            
        }

        public void LoadAssetSync(string assetBundleName, LuaFunction funcCallback)
        {

            if (!IsLoaded(assetBundleName))
            {
                AssetBundle ab = AssetBundle.LoadFromFile(STREAMING_ASSET_PATH + "/" + assetBundleName);
                SetAssetBundleLoad(assetBundleName, ab);
            }

            if (funcCallback != null)
            {
                funcCallback.call();
            }
        }

        public void LoadAssetAsync(string assetBundleName, string assetName, LuaFunction funcCallback)
        {
            StartCoroutine(LoadAssetAsyncInternal(assetBundleName, assetName, funcCallback));
        }

        protected IEnumerator LoadAssetAsyncInternal(string assetBundleName, string assetName, LuaFunction funcCallback)
        {
            AssetBundle ab = null;
            if (!IsLoaded(assetBundleName))
            {
                AssetBundleCreateRequest request = AssetBundle.LoadFromFileAsync(STREAMING_ASSET_PATH + "/" + assetBundleName);
                yield return request;
                ab = request.assetBundle;
                SetAssetBundleLoad(assetBundleName, ab);
            }
            else
            {
                ab = GetLoadedAssetBundle(assetBundleName);
            }

            Debug.Log("assetBundleName:" + assetBundleName + "," + assetName);
            string[] names = ab.GetAllAssetNames();
            for (int i = 0; i < names.Length; i++)
            {
                Debug.Log(names[i]);
            }

            LoadDependenciedAssetBundle(assetBundleName);
            AssetBundleRequest abRequest = ab.LoadAssetAsync(assetName);
            yield return abRequest;
            GameObject go = abRequest.asset as GameObject;
            if (funcCallback != null)
            {
                funcCallback.call(go);
            }
        }

        public AssetBundleManifest LoadDependenciedAssetBundle(string assetName)
        {
            AssetBundle manifesAB = null;
            if (!IsLoaded(MANIFET_NAME))
            {
                manifesAB = AssetBundle.LoadFromFile(STREAMING_ASSET_PATH + "/" + MANIFET_NAME);
                SetAssetBundleLoad(MANIFET_NAME, manifesAB);
            }

            manifesAB = GetLoadedAssetBundle(MANIFET_NAME);
            AssetBundleManifest manifest = manifesAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
            string[] strs = manifest.GetAllDependencies(assetName);
            foreach (var assetBundleName in strs)
            {
                if (!IsLoaded(assetBundleName))
                {
                    AssetBundle ab = AssetBundle.LoadFromFile(STREAMING_ASSET_PATH + "/" + assetBundleName);
                    SetAssetBundleLoad(assetBundleName, ab);
                }
            }
            return manifest;
        }

        public void SetAssetBundleLoad(string assetBundleName, AssetBundle ab)
        {
            if (!loadedAssetBundle.ContainsKey(assetBundleName))
            {
                loadedAssetBundle.Add(assetBundleName, ab);
            }
        }

        public AssetBundle GetLoadedAssetBundle(string assetBundleName)
        {
            AssetBundle ab = null;
            if (loadedAssetBundle.ContainsKey(assetBundleName))
            {
                ab = loadedAssetBundle[assetBundleName];
            }
            return ab;
        }

        public bool IsLoaded(string assetBundleName)
        {
            if (loadedAssetBundle.ContainsKey(assetBundleName))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
