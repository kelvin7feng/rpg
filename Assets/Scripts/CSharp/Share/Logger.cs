using UnityEngine;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace KG {
    public class Logger
    {
        private static Logger _Instance;

        public static Logger Instance
        {
            get
            {
                if (_Instance == null)
                {
                    _Instance = new Logger();
                }
                return _Instance;
            }
        }

        static readonly Dictionary<LogType, string> logTypeColors = new Dictionary<LogType, string>
        {
            { LogType.Assert, "normal"},
            { LogType.Error, "error" },
            { LogType.Exception, "error" },
            { LogType.Log, "normal" },
            { LogType.Warning, "warning" },
        };
        
        public void Register()
        {
            Application.logMessageReceived -= HandleLog;
            Application.logMessageReceived += HandleLog;
        }

        public void Unregister()
        {
            Application.logMessageReceived -= HandleLog;
        }

        void HandleLog(string logString, string stackTrace, LogType type)
        {
            if (type == LogType.Log)
            {
                DebugConsole.Log(logString, logTypeColors[type]);
            }
            else
            {
                string[] sArray = Regex.Split(logString, "\n");
                foreach (string str in sArray)
                {
                    DebugConsole.Log(str, logTypeColors[type]);
                }
            }
        }
    }
}