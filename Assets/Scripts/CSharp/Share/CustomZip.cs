using SLua;
using System;
using System.IO;
using System.Text;
using UnityEngine;
using System.Threading;
using System.Collections.Generic;
using ICSharpCode.SharpZipLib.Zip;

namespace KG
{
    [CustomLuaClass]
    public class CustomZip
    {

        private static List<Action> _unzipActionList = new List<Action>();

        private static List<Action> _actionList = new List<Action>();
        private static List<Action> _runActinList = new List<Action>();

        private static List<Action> _errorActionList = new List<Action>();
        private static List<Action> _errorRunActinList = new List<Action>();

        private static void unzipThread(string filePath, string outputPath, Action<long> endCallback, Action<string> errorCallback, int writeBufferSize)
        {
            try
            {
                using (ZipInputStream s = new ZipInputStream(File.OpenRead(filePath)))
                {
                    ZipEntry theEntry;
                    long writeSize = 0;
                    while ((theEntry = s.GetNextEntry()) != null)
                    {
                        string directoryName = Path.GetDirectoryName(theEntry.Name);
                        // create directory
                        if (directoryName.Length > 0)
                        {
                            directoryName = Path.Combine(outputPath, directoryName);
                            if (!Directory.Exists(directoryName))
                            {
                                Directory.CreateDirectory(directoryName);
                            }
                        }
                        else
                        {
                            directoryName = outputPath;
                        }

                        string fileName = Path.GetFileName(theEntry.Name);
                        if (fileName != String.Empty)
                        {
                            using (FileStream streamWriter = File.Create(Path.Combine(directoryName, fileName)))
                            {
                                int size = writeBufferSize;
                                byte[] data = new byte[size];
                                while (true)
                                {
                                    size = s.Read(data, 0, data.Length);
                                    if (size > 0)
                                    {
                                        writeSize += size;
                                        streamWriter.Write(data, 0, size);
                                    }
                                    else
                                    {
                                        lock (_actionList)
                                        {
                                            //用List保存，writeSize会递增
                                            List<long> l = new List<long>() { writeSize };
                                            _actionList.Add(() => { endCallback(l[0]); });
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch(ZipException ex)
            {
                lock (_errorActionList)
                {
                    _errorActionList.Add(() => { errorCallback(ex.Message); });
                }
            }
        }

        private static void runUnzipAction(object state)
        {
            if (_unzipActionList.Count > 0)
            {
                foreach (Action action in _unzipActionList)
                {
                    action();
                }
                _unzipActionList.Clear();
            }
        }

        //获取压缩包大小
        public static long GetTotalSize(string filePath)
        {
            if (Application.platform == RuntimePlatform.WindowsPlayer)
            {
                ZipConstants.DefaultCodePage = Encoding.UTF8.CodePage;
            }

            long totalSize = 0;
            try
            {
                using (ZipFile zipFile = new ZipFile(filePath))
                {
                    foreach (ZipEntry e in zipFile)
                    {
                        if (e.IsFile)
                        {
                            totalSize += e.Size;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.LogError(ex.Message);
            }
            return totalSize;
        }

        public static void Unzip(string filePath, string outputPath, Action<long> endCallback, Action<string> errorCallback, int writeBufferSize)
        {
            if (!File.Exists(filePath) || CustomFile.GetFileSize(filePath) <= 0)
            {
                 return;
            }

            if (Application.platform == RuntimePlatform.WindowsPlayer)
            {
                ZipConstants.DefaultCodePage = Encoding.UTF8.CodePage;
            }

            _unzipActionList.Add(() => unzipThread(filePath, outputPath, endCallback, errorCallback, writeBufferSize));
            //https://www.cnblogs.com/OpenCoder/p/4587249.html
            ThreadPool.SetMaxThreads(2, 2);
            ThreadPool.QueueUserWorkItem(new WaitCallback(runUnzipAction));
        }
        
        [DoNotToLua]
        public static void CheckUnzipCallback()
        {
            lock(_actionList)
            {
                if(_actionList.Count > 0)
                {
                    _runActinList.Clear();
                    _runActinList.AddRange(_actionList);
                    _actionList.Clear();
                }
            }

            if (_runActinList.Count > 0)
            {
                foreach (Action action in _runActinList)
                {
                    action();
                }
               _runActinList.Clear();
            }

            lock (_errorActionList)
            {
                if (_errorActionList.Count > 0)
                {
                    _errorRunActinList.Clear();
                    _errorRunActinList.AddRange(_errorActionList);
                    _errorActionList.Clear();
                }
            }

            if (_errorRunActinList.Count > 0)
            {
                foreach (Action action in _errorRunActinList)
                {
                    action();
                }
                _errorRunActinList.Clear();
            }
        }
    }
}