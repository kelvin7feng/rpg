using SLua;
using System;
using System.IO;
using System.Text;
using UnityEngine;

namespace KG
{
    [CustomLuaClass]
    public class CustomFile
    {
        public static FileStream CreateFileStream(string path, int buffSize)
        {
            string directory = Path.GetDirectoryName(path);
            if (!Directory.Exists(directory)) Directory.CreateDirectory(directory);

            FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.Write, FileShare.ReadWrite, buffSize);
            fs.Seek(fs.Length, SeekOrigin.Current);
            return fs;
        }

        public static void GetReadStream(string path, out byte[] readBuffer)
        {
            if (IsFileExits(path) == false)
            {
                readBuffer = null;
                return;
            }

            using (FileStream fs = File.OpenRead(path))
            {
                readBuffer = new byte[fs.Length];
                fs.Read(readBuffer, 0, readBuffer.Length);
                fs.Close();
            }
        }
        
        public static long GetFileSize(string path)
        {
            if (IsFileExits(path) == false)
            {
                return 0;
            }

            using (FileStream fs = File.OpenRead(path))
            {
                long length = fs.Length;
                fs.Close();
                return length;
            }
        }
        
        public static void DeleteFile(string path)
        {
            if (IsFileExits(path) == false)
            {
                return;
            }

            File.Delete(path);
        }

        public static bool MoveFile(string sourceFileName, string destFileName)
        {
            try
            {
                if (!File.Exists(sourceFileName))
                {
                    return false;
                }

                // Ensure that the target does not exist.
                if (File.Exists(destFileName))
                {
                    File.Delete(destFileName);
                }

                // Move the file.
                File.Move(sourceFileName, destFileName);
                // Console.WriteLine("{0} was moved to {1}.", sourceFileName, destFileName);
            }
            catch (Exception e)
            {
                Debug.LogErrorFormat("The process failed: {0}", e.ToString());
                return false;
            }

            return true;
        }


        private static void DeleteFolderRecursive(string directoryName)
        {
            if (Directory.Exists(directoryName))
            {
                foreach (string d in Directory.GetFileSystemEntries(directoryName))
                {
                    if (File.Exists(d))
                    {
                        FileInfo fi = new FileInfo(d);
                        //if (fi.Attributes.ToString().IndexOf("ReadOnly") != -1)
                        //    fi.Attributes = FileAttributes.Normal;
                        fi.Delete();
                    }
                    else
                    {
                        DirectoryInfo d1 = new DirectoryInfo(d);
                        if (d1.GetFiles().Length != 0 || d1.GetDirectories().Length != 0)
                        {
                            DeleteFolderRecursive(d1.FullName);
                        }
                        Directory.Delete(d);
                    }
                }
            }
        }

        public static void DeleteDir(string directoryName)
        {
            if (!Directory.Exists(directoryName))
            {
                return;
            }

            DeleteFolderRecursive(directoryName);

            if (Directory.GetDirectories(directoryName).Length == 0 && Directory.GetFiles(directoryName).Length == 0)
            {
                Directory.Delete(directoryName);
            }
        }

        public static Boolean IsFileExits(string path)
        {
            return File.Exists(path);
        }

        public static void CreateDir(string directoryName)
        {
            if (!Directory.Exists(directoryName))
            {
                Directory.CreateDirectory(directoryName);
            }
        }

        public static byte[] GetBytes(string bodyString)
        {
            byte[] bodyRaw = Encoding.UTF8.GetBytes(bodyString);
            return bodyRaw;
        }

        public static void SaveFile(string savePath, byte[] bytes)
        {
            if (IsFileExits(savePath))
                DeleteFile(savePath);

            File.WriteAllBytes(savePath, bytes);
        }

        public static string ReadAllText(string filePath)
        {
            if (!IsFileExits(filePath))
                return "";

            string txtString = File.ReadAllText(filePath);
            return txtString;
        }
    }
}