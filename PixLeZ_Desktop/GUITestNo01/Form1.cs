using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net.Http;

namespace GUITestNo01
{
    public partial class Form1 : Form
    {

        private static readonly HttpClient client = new HttpClient();
        string address;
        Color color;
        int value;
        double valD;

        public Form1()
        {
            InitializeComponent();

            address = "localhost:5500";
            // address = "192.168.178.55:8080";
            color = Color.White;
            label1.Text = color.ToString();
            int value = (int) numericUpDownTime.Value;
            textBoxAddress.Text = address;
 
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void buttonColor_Click(object sender, EventArgs e)
        {
            if (colorDialog1.ShowDialog() == DialogResult.OK)
            {
                colorBox1.BackColor = colorDialog1.Color;
                color = colorDialog1.Color;
                string s = "";
                if (color.R.ToString("X").Length == 1)
                    s = s + "0" + color.R.ToString("X");
                else
                    s = s +color.R.ToString("X");
                if (color.G.ToString("X").Length == 1)
                    s = s + "0" + color.G.ToString("X");
                else
                    s = s + color.G.ToString("X");
                if (color.B.ToString("X").Length == 1)
                    s = s + "0" + color.B.ToString("X");
                else
                    s = s + color.B.ToString("X");

                label1.Text = s;
           
                sendInformation("/set/color/" + s);
            }
                
           
        }

        private void textBoxAddress_TextChanged(object sender, EventArgs e)
        {
            this.address = textBoxAddress.Text;
        }

        private void sendButtonStart_Click(object sender, EventArgs e)
        {
            sendInformation("/start");
        }

        private async void sendInformation(string command)
        {
            string send = "http://" + address + command;

            var responseString = "";

            try
            {
               if(command.Contains("status"))
                {
                    responseString = await client.GetStringAsync(send);
                    labelStatusServer.Text = responseString.ToString();
                } 
                else
                {
                    responseString = await client.GetStringAsync(send);
                    labelResponseString.Text = responseString.ToString();
                }
            }
            catch(Exception ex)
            {
                responseString = ex.Message;
            }

        }

        private void sendButtonStop_Click(object sender, EventArgs e)
        {
            sendInformation("/stop");
        }

        private void numericUpDownTime_ValueChanged(object sender, EventArgs e)
        {
            valD = (double)numericUpDownTime.Value;
            string s = valD.ToString();
            s = s.Replace(',', '.');
            if(!s.Contains('.'))
            {
                s = s + ".0";
            }
            sendInformation("/set/time/" + s);
        }

        private void numericUpDownTimer_ValueChanged(object sender, EventArgs e)
        {
            valD = (double)numericUpDownTimer.Value;
            string s = valD.ToString();
            s = s.Replace(',', '.');
            if (!s.Contains('.'))
            {
                s = s + ".0";
            }
            sendInformation("/set/timer/" + s);
        }

        private void numericUpDownNumber_ValueChanged(object sender, EventArgs e)
        {
            value = (int)numericUpDownNumber.Value;
            sendInformation("/set/number/" + value);
        }

        private void numericUpDownMode_ValueChanged(object sender, EventArgs e)
        {
            value = (int)numericUpDownMode.Value;
            sendInformation("/select/mode/" + value);
            numericUpDownEffect.Value = -1;
        }

        private void numericUpDownEffect_ValueChanged(object sender, EventArgs e)
        {
            value = (int)numericUpDownEffect.Value;
            sendInformation("/select/effect/" + value);
            numericUpDownMode.Value = -1;
        }

        private void sendButtonRestartApp_Click(object sender, EventArgs e)
        {
            Application.Restart();
        }

        private void buttonStatusRequest_Click(object sender, EventArgs e)
        {
            sendInformation("/status");
        }

        private void buttonLoop_Click(object sender, EventArgs e)
        {
            value = (int)numericUpDownMode.Value;
            sendInformation("/select/mode/" + value);

            value = (int)numericUpDownEffect.Value;
            sendInformation("/select/effect/" + value);
        }
    }
}
