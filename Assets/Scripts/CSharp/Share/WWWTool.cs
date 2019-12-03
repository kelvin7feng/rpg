using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class WWWTool : MonoBehaviour {

    private static WWWTool _Instance;

    public static WWWTool Instance
    {
        get
        {
            if (_Instance == null)
            {
                GameObject go = GameObject.Find("Tools");
                if (go == null)
                {
                    go = new GameObject("Tools");
                    GameObject.DontDestroyOnLoad(go);
                }

                _Instance = go.AddComponent<WWWTool>();
            }
            return _Instance;
        }
    }

    public void DownloadAsync(string url, Action<string> callback)
    {
        StartCoroutine(DownloadFromeWWW(url, callback));
    }

    protected IEnumerator DownloadFromeWWW(string url, Action<string> callback)
    {
        WWW www = new WWW(url);
        yield return www;
        callback(www.text);
    }
}
