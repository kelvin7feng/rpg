using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace KG
{
    public class UpdateMgr : MonoBehaviour
    {

        void Start()
        {
            WWWTool.Instance.DownloadAsync("http://127.0.0.1/game.json", CheckUpdate);
        }

        public void CheckUpdate(string text)
        {
            GameJson gameJson = JsonUtility.FromJson<GameJson>(text);
            int lastestVersion = gameJson.version;
            int localVerstion = JsonTool.Instance.GetLocalVersion();
            if (lastestVersion > localVerstion)
            {
                Debug.Log("need to update");
            }
            else
            {
                Debug.Log("no need to update");
            }
        }
    }
}