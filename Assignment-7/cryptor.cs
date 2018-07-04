using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;

namespace AesEncryptor
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                var shellcode = textBox1.Text.ToString();
                var EncryptionKey = textBox2.Text.ToString();

                if (shellcode.Length > 1 && EncryptionKey.Length > 1)
                {
                    byte[] clearBytes = Encoding.Unicode.GetBytes(shellcode);
                    using (Aes encryptor = Aes.Create())
                    {
                        Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                        encryptor.Key = pdb.GetBytes(32);
                        encryptor.IV = pdb.GetBytes(16);
                        using (MemoryStream ms = new MemoryStream())
                        {
                            using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                            {
                                cs.Write(clearBytes, 0, clearBytes.Length);
                                cs.Close();
                            }
                            shellcode = Convert.ToBase64String(ms.ToArray());
                        }
                    }
                    textBox5.Text = shellcode;
                }
                else if (shellcode.Length < 2)
                {
                    MessageBox.Show("Enter shellcode");
                }
                else if (EncryptionKey.Length < 2)
                {
                    MessageBox.Show("Enter Encryption Key");
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Something went wrong!! Please enter correct shellcode or key!!");
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                var shellcode = textBox3.Text.ToString();
                var DecryptionKey = textBox4.Text.ToString();

                if (shellcode.Length > 1 && DecryptionKey.Length > 1)
                {
                    byte[] cipherBytes = Convert.FromBase64String(shellcode);
                    using (Aes encryptor = Aes.Create())
                    {
                        Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(DecryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                        encryptor.Key = pdb.GetBytes(32);
                        encryptor.IV = pdb.GetBytes(16);
                        using (MemoryStream ms = new MemoryStream())
                        {
                            using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                            {
                                cs.Write(cipherBytes, 0, cipherBytes.Length);
                                cs.Close();
                            }
                            shellcode = Encoding.Unicode.GetString(ms.ToArray());
                        }
                    }
                    textBox6.Text = shellcode;
                    string path1 = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                    string path = path1 + '\\' + "shellcode.c";

                    if (!File.Exists(path))
                    {
                        File.Create(path).Dispose();

                        using (TextWriter tw = new StreamWriter(path))
                        {
                            tw.WriteLine("#include<stdio.h>");
                            tw.WriteLine("#include<string.h>");
                            tw.WriteLine("unsigned char code[] = \\");
                            tw.WriteLine("\"" + textBox6.Text + "\";");
                            tw.WriteLine("main()");
                            tw.WriteLine("{");
                            tw.WriteLine("printf(\"Shellcode Length:  %d\", strlen(code));");
                            tw.WriteLine("int(*ret)() = (int(*)())code;");
                            tw.WriteLine("ret();");
                            tw.WriteLine("}");
                        }

                    }
                    else if (File.Exists(path))
                    {
                        using (TextWriter tw = new StreamWriter(path))
                        {
                            tw.WriteLine("#include<stdio.h>");
                            tw.WriteLine("#include<string.h>");
                            tw.WriteLine("unsigned char code[] = \\");
                            tw.WriteLine("\"" + textBox6.Text + "\";");
                            tw.WriteLine("main()");
                            tw.WriteLine("{");
                            tw.WriteLine("printf(\"Shellcode Length:  %d\", strlen(code));");
                            tw.WriteLine("int(*ret)() = (int(*)())code;");
                            tw.WriteLine("ret();");
                            tw.WriteLine("}");
                        }
                    }
                    MessageBox.Show("Shellcode successfully generated location :" + path);
                }
                else if (shellcode.Length < 2)
                {
                    MessageBox.Show("Enter shellcode");
                }
                else if (DecryptionKey.Length < 2)
                {
                    MessageBox.Show("Enter Encryption Key");
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Something went wrong!! Please enter correct shellcode or key!!");
            }

        }
    }
}
