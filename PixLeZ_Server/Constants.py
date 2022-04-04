#!/usr/bin/env python

import adafruit_ws2801
import board

# ! Select your pixel count
# 5 * 32 = 160 LEDs

PIXEL_COUNT = 160

# Hardware SPI
SPI_PORT = 0
SPI_DEVICE = 0
pixels = adafruit_ws2801.WS2801(board.SCLK, board.MOSI, PIXEL_COUNT, auto_write=False)
