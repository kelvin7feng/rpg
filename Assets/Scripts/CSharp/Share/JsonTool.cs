using UnityEngine;
using System.IO;

namespace KG
{
    [System.Serializable]
    public class GameJson
    {
        public int version;
        public string webURL;
        public string serverIP;
        public int serverPort;
    }

    public class JsonTool
    {
        public string path;
        public string fileName = "game.json";
        private static JsonTool _Instance;

        public static JsonTool Instance
        {
            get
            {
                if (_Instance == null)
                {
                    _Instance = new JsonTool();
                }
                return _Instance;
            }
        }

        private void Start()
        {
            /*path = GetGameJsonPath();
            string jsonString = File.ReadAllText(path);
            GameJson gameJson = JsonUtility.FromJson<GameJson>(jsonString);
            Debug.Log(gameJson.version);
            Debug.Log(gameJson.webURL);
            gameJson.version = gameJson.version + 1;
            Save(path, JsonUtility.ToJson(gameJson));*/
        }

        public string GetServerIp()
        {
            path = GetGameJsonPath();
            string jsonString = File.ReadAllText(path);
            GameJson gameJson = JsonUtility.FromJson<GameJson>(jsonString);
            return gameJson.serverIP;
        }

        public int GetServerPort()
        {
            path = GetGameJsonPath();
            string jsonString = File.ReadAllText(path);
            GameJson gameJson = JsonUtility.FromJson<GameJson>(jsonString);
            return gameJson.serverPort;
        }

        public int GetLocalVersion()
        {
            path = GetGameJsonPath();
            string jsonString = File.ReadAllText(path);
            GameJson gameJson = JsonUtility.FromJson<GameJson>(jsonString);
            return gameJson.version;
        }

        private string GetGameJsonPath()
        {
            return FileTool.Instance.GetFilePath(fileName);
        }

        private void Save(string path, string json)
        {
            File.WriteAllText(path, json);
        }
    }
}