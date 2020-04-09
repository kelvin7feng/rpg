using UnityEngine;
using UnityEngine.SceneManagement;
using System.Collections;
using SLua;

namespace KG
{
	[CustomLuaClass]
	public class SceneHelper : MonoBehaviour {

        private static SceneHelper _Instance;
        public static AsyncOperation operation;

        public static SceneHelper Instance
        {
            get
            {
                if (_Instance == null)
                {
                    GameObject go = GameObject.Find("SceneHelper");
                    if (go == null)
                    {
                        go = new GameObject("SceneHelper");
                        GameObject.DontDestroyOnLoad(go);
                    }

                    _Instance = go.AddComponent<SceneHelper>();
                }
                return _Instance;
            }
        }

        public void LoadSceneSync(string sceneName, LoadSceneMode loadSceneMode, LuaFunction funcCallback)
        {
            SceneManager.LoadScene(sceneName, loadSceneMode);
            if (funcCallback != null)
            {
                funcCallback.call(sceneName, loadSceneMode);
            }
        }
        
        public void LoadSceneAsync(string sceneName, LoadSceneMode loadSceneMode, LuaFunction funcCallback)
        {
            StartCoroutine(LoadAsynchronously(sceneName, loadSceneMode, funcCallback));
        }

        protected IEnumerator LoadAsynchronously(string sceneName, LoadSceneMode loadSceneMode, LuaFunction funcCallback)
        {
            operation = SceneManager.LoadSceneAsync(sceneName, loadSceneMode);

            while (!operation.isDone)
            {
                float progress = Mathf.Clamp01(operation.progress / .9f);
                yield return null;
            }

            if (funcCallback != null)
            {
                funcCallback.call();
                operation = null;
            }
        }
    }
}