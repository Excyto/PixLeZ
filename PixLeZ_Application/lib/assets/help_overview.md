# PixLeZ - Documentation
## Quick Start
Once you set up the server using your Raspberry Pi (please refer to the readme on the server for this) and have it running (using `python app.py`), you need to first head over to the settings-section to specify the connection.
Enter the IP address of your raspi and the number of LEDs on your light strip. You only need to do this once.
After that, head over to `Controller`, start the server and assign a color of your choice. Finally, you can open `effects` and select an effect of your choice by long-pressing the button.

## Controller
The controller allows you to specify various parameters for your effects. For example, many effects (besides, e.g. Rainbow) need you to specify a color. In order to avoid seeing no effects, set a color other than black using the sliders.
The first three sliders red, green and blue allow you to compose your color, whereas the fourth slider controls the intensity of the color. Set it to a high level in order to make the effects darker.
The number-parameter specifies how many pixles are shown, this is not used for all effects (but for example for walking pixles).

## Custom Themes
This section allows you to create your own themes and effects. 
tbd

## Effects
In this tab you can start various effects. Try them out to see what they look like! :)
In order to select an effect, hold the button until a small icon appears. By this, you should be prevented from accidentally switching effects.

## Modes
This is similar to effects, but more ambient-oriented. Here, you can also switch off the lights.

## Settings
In this section, you specify the IP-Address of your server and the number of LEDs your light-strip is equipped with. 

## Additional help
If you have any questions or need additional help, feel free to create an [issue](https://github.com/Excyto/PixLeZ/issues) or contact one of the contributors. We will be happy to help you!