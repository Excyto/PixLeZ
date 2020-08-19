# [PixLeZ - Documentation](https://www.markdownguide.org/basic-syntax/#overview)

[![alt text](https://img.shields.io/github/followers/Excyto?label=Github&style=social)](https://github.com/Excyto)
[![GitHub license](https://img.shields.io/badge/license-MIT-brightgreen)](https://github.com/Excyto)
[![GitHub version](https://img.shields.io/badge/Open-Source-brightgreen)](https://github.com/Excyto)

[![GitHub version](https://img.shields.io/badge/Code-Python-brightgreen)](https://github.com/Excyto)

## PixLeZ-Simulator

The PixLeZ-Simulator is developed for simulating, debuging and testing the Adafruit_WS2801 pixels wihtout using the hardware. It is using the same [API](https://github.com/adafruit/Adafruit_Python_WS2801/blob/master/Adafruit_WS2801/WS2801.py) for maniupulating the pixels, so it is possible to copy and paste the code between the simulator and the hardware without changing too much. Only the call of the converter methods have to be adjust.

You can run your own code in `PixelSimulatorConfig.py`. There is the method `coding()` for this purpose, which will be executed in a while loop. The possibilities of manipulating the pixels are listed in the section below.

For executing the simulator run `PixelSimulator.py`.

After starting the application select the amount of your pixels, and enter it. Now you can use the menubar on the top left.

- Press the button `run program` for executing your code.
- Press the button `stop program` for stopping the execution of the code.
- Press the button `step forward` to step until the method `set_pixels` or `set_pixel` is executed.
- Select the combobox `show` to activate the `step show` button.
- Press the button `step show` to step until the next `show()` method is executed. This will simulate the procedure of the hardware best.

## Possibilities of manipulating pixels

This Methods are object methods and need to be called with the corrisponding object of the simulator.

Set the pixel at position `pos` or all pixels to 24-bit RGB color value.

```python
set_pixels(self, color)
set_pixel(self, pos, color)
```

Set the pixel at position `pos` or all pixels to 8-bit red, blue, green values.

```python
set_pixels_rgb(self, r, g, b)
set_pixel_rgb(self, pos, r, g, b)
```

Return the color of the pixel at position `pos` as a 24-bit RGB `color` or as an Tupel of `(r, g, b)`

```python
get_pixel(self, pos)
get_pixel_rgb(self, pos)
```

Print the set pixels. For the Adafruit_WS2801 the method has to called for printing the pixels.

```python
show(self)
```

Returns the number of pixels.

```python
count(self)
```

Set all pixels to `#FFFFFF`

```python
clear(self)
```

Converter methods, can be used to convert in different color schemes and return this to an `string`, `int`, `(r, g, b)`. To convert to all schemes the methods can be stacked.

```python
RGB_to_color(self, r, g, b)
color_to_RGB(self, color)
hex_to_RGB(self, hex)
RGB_to_hex(self, r, g, b)
```

## Links

- [Adafruit_WS2801 Library GitHub](https://github.com/adafruit/Adafruit_Python_WS2801/blob/master/Adafruit_WS2801/WS2801.py)
- [Tkinter Framework](https://realpython.com/python-gui-tkinter/)
