using UnityEngine;
using System.Linq;
using System.Collections;
using System.IO;
namespace KG
{
    public class FileTool
    {
        private static FileTool _Instance;

        public static FileTool Instance
        {
            get
            {
                if (_Instance == null)
                {
                    _Instance = new FileTool();
                }
                return _Instance;
            }
        }

        public void CopyAssetBundleToStreamingPath()
        {
            CopyFile("AssetBundles", Application.streamingAssetsPath);
        }

        public void CopyFile(string srcPath, string destinationPath)
        {
            string[] filesList = Directory.GetFiles(srcPath);
            foreach (string f in filesList)
            {
                string targetPath = destinationPath + "/" + f.Substring(srcPath.Length + 1);
                if (File.Exists(targetPath))
                {
                    File.Copy(f, targetPath, true);
                }
                else
                {
                    File.Copy(f, targetPath);
                }
            }
        }

        IEnumerator DoCopy(string fileName, string srcPath, string destinationPath)
        {
            string src = srcPath + fileName;
            string des = destinationPath + fileName;
            WWW www = new WWW(src);
            yield return www;
            if (!string.IsNullOrEmpty(www.error))
            {
                Debug.Log("www.error:" + www.error);
            }
            else
            {
                if (File.Exists(des))
                {
                    File.Delete(des);
                }
                FileStream fsDes = File.Create(des);
                fsDes.Write(www.bytes, 0, www.bytes.Length);
                fsDes.Flush();
                fsDes.Close();
            }
            www.Dispose();
        }

        string GetStreamingPath()
        {
            string pre = "file://";
#if UNITY_EDITOR
            pre = "file://";
#elif UNITY_ANDROID
        pre = "";
#elif UNITY_IPHONE
	    pre = "file://";
#endif
            string path = pre + Application.streamingAssetsPath + "/";
            return path;
        }

        string GetPersistentPathForWWW()
        {
            string pre = "file://";
#if UNITY_EDITOR || UNITY_STANDALONE_WIN
            pre = "file:///";
#elif UNITY_ANDROID
        pre = "file://";
#elif UNITY_IPHONE
        pre = "file://";
#endif
            string path = pre + Application.persistentDataPath + "/";
            return path;
        }

        public string GetFilePath(string fileName)
        {
            string filePath = null;
            if (WhetherGetScriptFromPersistentDataPath(fileName))
            {
                //Debug.Log("Get File From Persistent");
                filePath = GetScriptPersistentDataPath(fileName);
            }
            else
            {
                //Debug.Log("Get File From Streaming File");
                filePath = GetStreamingAssetPath(fileName);
            }
            return filePath;
        }

        public string GetStreamingAssetPath(string fileName)
        {
            string filePath = null;
#if UNITY_ANDROID  //android
            filePath = Application.streamingAssetsPath + "/" + fileName;
#elif UNITY_IPHONE //iPhone
            filePath = Application.streamingAssetsPath + "/" +fileName;
#elif UNITY_STANDALONE_WIN || UNITY_EDITOR
            filePath = Application.streamingAssetsPath + "/" + fileName;
#else
            filePath = Application.streamingAssetsPath + "/" + fileName;
#endif

            return filePath;
        }

        public string GetScriptPersistentDataPath(string fileName)
        {
            return Application.persistentDataPath + "/" + fileName;
        }

        public bool WhetherGetScriptFromPersistentDataPath(string fileName)
        {
            string filePath = GetScriptPersistentDataPath(fileName);
            bool bExist = System.IO.File.Exists(filePath);
            return bExist;
        }
    }
}