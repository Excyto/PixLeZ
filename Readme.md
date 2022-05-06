# PixLeZ - Documentation

[![alt text](https://img.shields.io/github/stars/Excyto/PixLeZ?style=social)](https://github.com/Excyto/PixLeZ)
[![alt text](https://img.shields.io/github/v/release/Excyto/PixLeZ?color=g)](https://github.com/Excyto/PixLeZ)
[![GitHub license](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/Excyto/PixLeZ/blob/master/LICENSE)
[![GitHub version](https://img.shields.io/badge/Open-Source-brightgreen)](https://github.com/Excyto/PixLeZ)

[![GitHub version](https://img.shields.io/badge/Hardware-Raspberry%20Pi-brightgreen)](hhttps://github.com/Excyto/PixLeZ)
[![GitHub version](https://img.shields.io/badge/Server-Python-brightgreen)](https://github.com/Excyto/PixLeZ)
[![GitHub version](https://img.shields.io/badge/Client-C%23%20%7C%20Flutter-brightgreen)](https://github.com/Excyto/PixLeZ)

[![alt text](https://img.shields.io/github/followers/Excyto?label=Excyto&style=social)](https://github.com/Excyto)
[![alt text](https://img.shields.io/github/followers/TheRisenPhoenix?label=TheRisenPhoenix&style=social)](https://github.com/TheRisenPhoenix)

## Introduction

PixLeZ is a Software-Bundle for controlling the [WS2801 Pixels](https://github.com/adafruit/Adafruit_CircuitPython_WS2801) with a Raspberry Pi.  
The Bundle contains a server application, running on the Raspberry Pi and different clients to control the server.

## Content

- Raspberry Pi Setup (Hardware and Software)
- PixLeZ-Server running on the Raspberry Pi
  - API calls via local network and the browser
  - Effects and Modes
  - Own Effects and Modes
  - Example: Use the API
- PixLeZ-Application, a cross platform app, developed with `flutter`
- About
- Links

## Setup the Raspberry Pi

### Hardware

For the Hardware part, follow the descriptions bellow.

- [Raspberry Pi Tutorial Setup (ger)](https://tutorials-raspberrypi.de/raspberry-pi-ws2801-rgb-led-streifen-anschliessen-steuern/)
- [Raspberry Pi Tutorial Setup (en)](https://tutorials-raspberrypi.com/how-to-control-a-raspberry-pi-ws2801-rgb-led-strip/)

### Software

For the software part you have to install some `python` libraries with the following commands.

```sh
sudo apt-get update
sudo apt-get install python3
sudo apt-get install python-pip -y
sudo pip install adafruit-circuitpython-ws2801
sudo pip install flask
```

## PixLeZ-Server

> Path: `./PixLeZ_Server`

The base of the application is a simple flask server running with python, controlling your [WS2801 Pixels](https://github.com/adafruit/Adafruit_CircuitPython_WS2801). After the configuration of your Raspberry Pi with the packages in the Software part, you need to move the `./PixLeZ_Server` directory to your Raspberry Pi. After that, you can simply run the server inside the directory using the following command.

```sh
python app.py
```

The PixLeZ-Server is now accessible via the local network. For [configuration](https://flask.palletsprojects.com/en/1.1.x/api/?highlight=run#flask.Flask.run) changes modify the statement below in the file `app.py` and restart the application `app.py` after.

```python
app.run(debug=True, port=8080, host="0.0.0.0")
```

### API calls

After installing, the PixLeZ-Server provides the following API. The API is used by the applications described in the next few sections, but can also be used via a webbrowser or an other application.  
The term `changeable during runtime` is used to describe that the attributes can be changed during the execution of an effect or mode. The change of attributes with `non changeable during runtime` will be changed after selecting a new effect or mode, or after doing an `/stop` and `/start`.
Each time you select an effect, the mode attribute will turn to `-1` and backwards. Furthermore after selecting an effect or mode, the program will automatically do an `/stop` and `/start`.

```python
# starts the process -> only call in the beginning or after a stop
@app.route('/start')

# stops the process
@app.route('/stop')

# String color in HEX -> Example /set/color/FF00FF
# changable during runtime
@app.route('/set/color/<string:color>')

# time as floating number
# changable during runtime
@app.route('/set/time/<float:post_id>')

# timer as floating number
# non changable during runtime
@app.route('/set/timer/<float:post_id>')

# number as integer
# changable during runtime
@app.route('/set/number/<int:post_id>')

# mode as integer -> the mode will automatically change and the effect is set to 0
# changable during runtime
@app.route('/select/mode/<int:post_id>')

# effect as integer -> the effect will automatically change and the mode is set to 0
# changable during runtime
@app.route('/select/effect/<int:post_id>')

# returns the status of the attributes
@app.route('/status')

# Set a custom Color Theme
# Body: List of hex-colors
# changable during runtime
@app.route('/set/pixels', methods=['POST'])
```

### Effects and Modes

The following tables describes the different effects and modes which can be used. In the last column there are some shortcuts used to give the opportunity for manipulating the effects or modes.

- c := Color in Hex
- t := time in sec
- tr := timer in sec
- n := number in x

#### Effects

|Index    |Name  |Decription  |Config  |
|---------|---------|---------|---------|
|-1    |Init                    |No Effect active| |
|0     |Shine                   |Switching all Pixels on |c|
|1     |Walking Pixels          |Pixels walking to one side|c, t|
|2     |Walking Pixels reverse  |Pixels walking to the other side|c, t|
|3     |Fill it                 |Insort the selected number of Pixels|c, n|
|4     |Get empty               |And the Pixels are going away|c, tr|
|5     |Final countdown         |Countdown with red Pixels|tr|
|6     |Pulsing Pixels          |Pulsating Pixels everywhere|c, t|
|7     |Dim Off                 |Dim the Pixels off|c, tr|
|8     |Rainbow Mode            |The Pixels change in the Spectrum of the Rainbow|t|
|9     |Rainbow Walk            |Pixels walking in the Spectrum of the Rainbow|t|
|10    |Rainbow Puls            |Pixels pulsing in the Spectrum of the Rainbow|t|
|11    |Cyclon Pixels           |Pixels making a huge Cyclon|c, t, n|
|12    |Twinkle It              |Pixels can twinkle|c, t|
|13    |Twinkle It Colorful     |Pixels can twinkle in different colors|t|
|14    |The Sparkle Pixels      |What a sparkle Pixel|c, t|
|15    |Snow Sparkling          |Feeling like snowin|c, t|
|16    |Pixel Runner            |They are running very fast|c, t|
|17    |Theater Chase Pixels    |Maybe Pixels visited a Theater|c, t|
|18    |Bouncing Pixels         |And they bounce to center and back|c, t, n|
|19    |tbd                     |         |         |

#### Modes

|Index    |Name  |Decription  |Config  |
|---------|---------|---------|---------|
|-1    |Initial                 |No Mode active| |
|0     |Shine It|Normal light Pixel mode|c|
|1     |Chill Mode|Chillin with the Pixels||
|2     |Color Theme|Use your custom color Pixel theme|c|
|2     |No Effect|Nope, not today||
|3     |tbd|||

### Add your own Effects and Modes

You are able to add your own effects and modes to the PixLeZ-Package. Feel free to share your code with me and I will extend the PixLeZ-Package with your features or simply create a Pull Request.  

Add your code in `Blink.py` under the last effect or mode, depending on your purpose. Just add an further `if-condition` with an unique `index`.  

```python
if self.effect == [unique effect Number]:
  # insert your code here
if self.mode == [unique mode Numer]:
  # insert your code here
```

Implement the logic of the effect in `Effects.py`.
Use the [adafruit-ws2801 API](https://github.com/adafruit/Adafruit_CircuitPython_WS2801) to expand the code.

After adding, you are able to call the effects and modes with an simple flask API call or an application.  

You are not able to select your added effects and modes with the PixLeZ-Application. You'll have to add it to the App by hand. 
We are aware of this issue and will think of a better solution in an upcoming iteration.

### Example: Use the API

How to start an effect and manipulate it. If you use an application do the same steps but without the API calls.

1. Select a color or color theme with `/set/color/<string:color>` or `/set/pixels`
1. Select your effect with `/select/effect/1`
1. Use `/start` to start the application
1. You can manipulate the effect with setting different attributes during runtime. As example `/set/color/AA0011` or `/set/time/0.001`
1. Select an other effect during runtime with `/select/effect/16`

## PixLeZ-Application

> Path: `./PixLeZ_Application`

The PixLeZ-Application is the main part of the project. The application provides a lot of possibilities for configuration the Pixels.

The PixLeZ-Application is made with `flutter`. Flutters advantage is in running code on every platform. For more information check the [Flutter](https://flutter.dev/) webpage.  

You have two options to run the PixLeZ-Application

1. Set up a [Flutter environment](https://flutter.dev/docs/get-started/install) and compile it on your specific platform (Web, Android, IOS, Mac, Win,...)
2. Download the predefined installation packages and install it on the specific platform

## About

PixLeZ was originally created by [Tobias Schreiweis](https://github.com/Excyto) in 2020.  
Later, [Timo](https://github.com/TheRisenPhoenix) joined as a maintainer and contributor.

It started as a private project with the main focus to improve their python skills with the Raspberry Pi and learning new programing languages like dart with the framework flutter. After some requests from other people getting the application Tobias decided to publish it on GitHub.

You are welcome to extend the PixLeZ-Bundle or send us your ideas and we will be glad to add your code and ideas to this repository.

If we can be of assistance, please do not hesitate to contact us.

[![alt text](https://img.shields.io/github/followers/Excyto?label=Excyto&style=social)](https://github.com/Excyto)
[![alt text](https://img.shields.io/github/followers/TheRisenPhoenix?label=TheRisenPhoenix&style=social)](https://github.com/TheRisenPhoenix)

## Links

- [Raspberry Pi Tutorial Setup (ger)](https://tutorials-raspberrypi.de/raspberry-pi-ws2801-rgb-led-streifen-anschliessen-steuern/)
- [Raspberry Pi Tutorial Setup (en)](https://tutorials-raspberrypi.com/how-to-control-a-raspberry-pi-ws2801-rgb-led-strip/)
- [Adafruit_WS2801 Library GitHub](https://github.com/adafruit/Adafruit_CircuitPython_WS2801)
- [Inspiration of some Arduino LED effects](https://www.tweaking4all.com/hardware/arduino/adruino-led-strip-effects/)
- [Flask Framework](https://flask.palletsprojects.com)
- [Tkinter Framework](https://realpython.com/python-gui-tkinter/)
- [Flutter](https://flutter.dev/)
