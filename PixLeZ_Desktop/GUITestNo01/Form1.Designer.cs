namespace GUITestNo01
{
    partial class Form1
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            this.textBoxAddress = new System.Windows.Forms.TextBox();
            this.colorBox1 = new System.Windows.Forms.PictureBox();
            this.buttonColor = new System.Windows.Forms.Button();
            this.colorDialog1 = new System.Windows.Forms.ColorDialog();
            this.label1 = new System.Windows.Forms.Label();
            this.sendButtonStart = new System.Windows.Forms.Button();
            this.sendButtonStop = new System.Windows.Forms.Button();
            this.sendButtonRestartApp = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.numericUpDownTime = new System.Windows.Forms.NumericUpDown();
            this.label3 = new System.Windows.Forms.Label();
            this.labelResponseString = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label4 = new System.Windows.Forms.Label();
            this.numericUpDownTimer = new System.Windows.Forms.NumericUpDown();
            this.label5 = new System.Windows.Forms.Label();
            this.numericUpDownMode = new System.Windows.Forms.NumericUpDown();
            this.label6 = new System.Windows.Forms.Label();
            this.numericUpDownEffect = new System.Windows.Forms.NumericUpDown();
            this.label7 = new System.Windows.Forms.Label();
            this.numericUpDownNumber = new System.Windows.Forms.NumericUpDown();
            this.label8 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.labelStatusServer = new System.Windows.Forms.Label();
            this.buttonStatusRequest = new System.Windows.Forms.Button();
            this.buttonLoop = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.colorBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownTime)).BeginInit();
            this.groupBox1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownTimer)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownMode)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownEffect)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownNumber)).BeginInit();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // textBoxAddress
            // 
            this.textBoxAddress.Location = new System.Drawing.Point(101, 34);
            this.textBoxAddress.Name = "textBoxAddress";
            this.textBoxAddress.Size = new System.Drawing.Size(156, 20);
            this.textBoxAddress.TabIndex = 0;
            this.textBoxAddress.TextChanged += new System.EventHandler(this.textBoxAddress_TextChanged);
            // 
            // colorBox1
            // 
            this.colorBox1.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.colorBox1.Location = new System.Drawing.Point(101, 60);
            this.colorBox1.Name = "colorBox1";
            this.colorBox1.Size = new System.Drawing.Size(75, 23);
            this.colorBox1.TabIndex = 1;
            this.colorBox1.TabStop = false;
            // 
            // buttonColor
            // 
            this.buttonColor.Location = new System.Drawing.Point(20, 60);
            this.buttonColor.Name = "buttonColor";
            this.buttonColor.Size = new System.Drawing.Size(75, 23);
            this.buttonColor.TabIndex = 2;
            this.buttonColor.Text = "Color";
            this.buttonColor.UseVisualStyleBackColor = true;
            this.buttonColor.Click += new System.EventHandler(this.buttonColor_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(182, 65);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(57, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "HEX-Code";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // sendButtonStart
            // 
            this.sendButtonStart.Location = new System.Drawing.Point(20, 123);
            this.sendButtonStart.Name = "sendButtonStart";
            this.sendButtonStart.Size = new System.Drawing.Size(75, 23);
            this.sendButtonStart.TabIndex = 4;
            this.sendButtonStart.Text = "Start";
            this.sendButtonStart.UseVisualStyleBackColor = true;
            this.sendButtonStart.Click += new System.EventHandler(this.sendButtonStart_Click);
            // 
            // sendButtonStop
            // 
            this.sendButtonStop.Location = new System.Drawing.Point(101, 123);
            this.sendButtonStop.Name = "sendButtonStop";
            this.sendButtonStop.Size = new System.Drawing.Size(75, 23);
            this.sendButtonStop.TabIndex = 5;
            this.sendButtonStop.Text = "Stop";
            this.sendButtonStop.UseVisualStyleBackColor = true;
            this.sendButtonStop.Click += new System.EventHandler(this.sendButtonStop_Click);
            // 
            // sendButtonRestartApp
            // 
            this.sendButtonRestartApp.Location = new System.Drawing.Point(182, 90);
            this.sendButtonRestartApp.Name = "sendButtonRestartApp";
            this.sendButtonRestartApp.Size = new System.Drawing.Size(75, 23);
            this.sendButtonRestartApp.TabIndex = 6;
            this.sendButtonRestartApp.Text = "Restart App";
            this.sendButtonRestartApp.UseVisualStyleBackColor = true;
            this.sendButtonRestartApp.Click += new System.EventHandler(this.sendButtonRestartApp_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(17, 37);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(64, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "IP - Address";
            // 
            // numericUpDownTime
            // 
            this.numericUpDownTime.DecimalPlaces = 3;
            this.numericUpDownTime.Increment = new decimal(new int[] {
            5,
            0,
            0,
            131072});
            this.numericUpDownTime.Location = new System.Drawing.Point(101, 153);
            this.numericUpDownTime.Maximum = new decimal(new int[] {
            10000,
            0,
            0,
            0});
            this.numericUpDownTime.Name = "numericUpDownTime";
            this.numericUpDownTime.Size = new System.Drawing.Size(156, 20);
            this.numericUpDownTime.TabIndex = 8;
            this.numericUpDownTime.ValueChanged += new System.EventHandler(this.numericUpDownTime_ValueChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(20, 155);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(75, 13);
            this.label3.TabIndex = 9;
            this.label3.Text = "Time in sec [s]";
            // 
            // labelResponseString
            // 
            this.labelResponseString.AutoSize = true;
            this.labelResponseString.Location = new System.Drawing.Point(6, 16);
            this.labelResponseString.Name = "labelResponseString";
            this.labelResponseString.Size = new System.Drawing.Size(98, 13);
            this.labelResponseString.TabIndex = 10;
            this.labelResponseString.Text = "Network Response";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.labelResponseString);
            this.groupBox1.Location = new System.Drawing.Point(20, 314);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(237, 46);
            this.groupBox1.TabIndex = 11;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Logfile";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(20, 13);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(241, 13);
            this.label4.TabIndex = 12;
            this.label4.Text = "_______________________________________";
            // 
            // numericUpDownTimer
            // 
            this.numericUpDownTimer.DecimalPlaces = 2;
            this.numericUpDownTimer.Increment = new decimal(new int[] {
            10,
            0,
            0,
            0});
            this.numericUpDownTimer.Location = new System.Drawing.Point(101, 180);
            this.numericUpDownTimer.Maximum = new decimal(new int[] {
            100000,
            0,
            0,
            0});
            this.numericUpDownTimer.Name = "numericUpDownTimer";
            this.numericUpDownTimer.Size = new System.Drawing.Size(156, 20);
            this.numericUpDownTimer.TabIndex = 13;
            this.numericUpDownTimer.ValueChanged += new System.EventHandler(this.numericUpDownTimer_ValueChanged);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(20, 182);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(78, 13);
            this.label5.TabIndex = 14;
            this.label5.Text = "Timer in sec [s]";
            // 
            // numericUpDownMode
            // 
            this.numericUpDownMode.Location = new System.Drawing.Point(101, 236);
            this.numericUpDownMode.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.numericUpDownMode.Name = "numericUpDownMode";
            this.numericUpDownMode.Size = new System.Drawing.Size(156, 20);
            this.numericUpDownMode.TabIndex = 15;
            this.numericUpDownMode.Value = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.numericUpDownMode.ValueChanged += new System.EventHandler(this.numericUpDownMode_ValueChanged);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(20, 238);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(34, 13);
            this.label6.TabIndex = 16;
            this.label6.Text = "Mode";
            // 
            // numericUpDownEffect
            // 
            this.numericUpDownEffect.Location = new System.Drawing.Point(101, 263);
            this.numericUpDownEffect.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.numericUpDownEffect.Name = "numericUpDownEffect";
            this.numericUpDownEffect.Size = new System.Drawing.Size(156, 20);
            this.numericUpDownEffect.TabIndex = 17;
            this.numericUpDownEffect.Value = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.numericUpDownEffect.ValueChanged += new System.EventHandler(this.numericUpDownEffect_ValueChanged);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(20, 265);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(35, 13);
            this.label7.TabIndex = 18;
            this.label7.Text = "Effect";
            // 
            // numericUpDownNumber
            // 
            this.numericUpDownNumber.Location = new System.Drawing.Point(101, 207);
            this.numericUpDownNumber.Name = "numericUpDownNumber";
            this.numericUpDownNumber.Size = new System.Drawing.Size(156, 20);
            this.numericUpDownNumber.TabIndex = 19;
            this.numericUpDownNumber.ValueChanged += new System.EventHandler(this.numericUpDownNumber_ValueChanged);
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(20, 209);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(44, 13);
            this.label8.TabIndex = 20;
            this.label8.Text = "Number";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.labelStatusServer);
            this.groupBox2.Location = new System.Drawing.Point(20, 366);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(237, 151);
            this.groupBox2.TabIndex = 21;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Status";
            // 
            // labelStatusServer
            // 
            this.labelStatusServer.AutoEllipsis = true;
            this.labelStatusServer.AutoSize = true;
            this.labelStatusServer.Location = new System.Drawing.Point(7, 16);
            this.labelStatusServer.Name = "labelStatusServer";
            this.labelStatusServer.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.labelStatusServer.Size = new System.Drawing.Size(71, 13);
            this.labelStatusServer.TabIndex = 0;
            this.labelStatusServer.Text = "Status Server";
            // 
            // buttonStatusRequest
            // 
            this.buttonStatusRequest.Location = new System.Drawing.Point(20, 90);
            this.buttonStatusRequest.Name = "buttonStatusRequest";
            this.buttonStatusRequest.Size = new System.Drawing.Size(156, 23);
            this.buttonStatusRequest.TabIndex = 22;
            this.buttonStatusRequest.Text = "Status";
            this.buttonStatusRequest.UseVisualStyleBackColor = true;
            this.buttonStatusRequest.Click += new System.EventHandler(this.buttonStatusRequest_Click);
            // 
            // buttonLoop
            // 
            this.buttonLoop.Location = new System.Drawing.Point(182, 123);
            this.buttonLoop.Name = "buttonLoop";
            this.buttonLoop.Size = new System.Drawing.Size(75, 23);
            this.buttonLoop.TabIndex = 23;
            this.buttonLoop.Text = "Eff/Mode";
            this.buttonLoop.UseVisualStyleBackColor = true;
            this.buttonLoop.Click += new System.EventHandler(this.buttonLoop_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.ClientSize = new System.Drawing.Size(284, 529);
            this.Controls.Add(this.buttonLoop);
            this.Controls.Add(this.buttonStatusRequest);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.numericUpDownNumber);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.numericUpDownEffect);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.numericUpDownMode);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.numericUpDownTimer);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.numericUpDownTime);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.sendButtonRestartApp);
            this.Controls.Add(this.sendButtonStop);
            this.Controls.Add(this.sendButtonStart);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.buttonColor);
            this.Controls.Add(this.colorBox1);
            this.Controls.Add(this.textBoxAddress);
            this.Cursor = System.Windows.Forms.Cursors.Arrow;
            this.Name = "Form1";
            this.Text = "Led Controller";
            this.TopMost = true;
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.colorBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownTime)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownTimer)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownMode)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownEffect)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownNumber)).EndInit();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxAddress;
        private System.Windows.Forms.PictureBox colorBox1;
        private System.Windows.Forms.Button buttonColor;
        private System.Windows.Forms.ColorDialog colorDialog1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button sendButtonStop;
        private System.Windows.Forms.Button sendButtonStart;
        private System.Windows.Forms.Button sendButtonRestartApp;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.NumericUpDown numericUpDownTime;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label labelResponseString;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.NumericUpDown numericUpDownTimer;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.NumericUpDown numericUpDownMode;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.NumericUpDown numericUpDownEffect;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.NumericUpDown numericUpDownNumber;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Label labelStatusServer;
        private System.Windows.Forms.Button buttonStatusRequest;
        private System.Windows.Forms.Button buttonLoop;
    }
}

