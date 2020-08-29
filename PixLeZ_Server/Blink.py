#!/usr/bin/env python

import sys
import random
import math

import time
import RPi.GPIO as GPIO

import Adafruit_WS2801
import Adafruit_GPIO.SPI as SPI

from multiprocessing import Process
from multiprocessing import Queue
from threading import Thread

from effects import Effects

'''
    PixLeZ - Server
    
'''

# ! Select your pixel count
# 5 * 32 = 160 LEDs
PIXEL_COUNT = 160

# Hardware SPI
SPI_PORT = 0
SPI_DEVICE = 0
pixels = Adafruit_WS2801.WS2801Pixels(PIXEL_COUNT, spi=SPI.SpiDev(SPI_PORT, SPI_DEVICE), gpio=GPIO)


class Blink(object):

    def __init__(self):
        self.value = 0
        self.color = Adafruit_WS2801.RGB_to_color(255, 255, 255)
        self.colorList = []
        for i in range(PIXEL_COUNT):
            self.colorList.append('000000')
        self.time = 0.1
        self.timer = 20.0
        self.number = 1
        self.mode = -1
        self.effect = -1
        self.queueColor = Queue()
        self.queueColorList = Queue()
        self.queueTime = Queue()
        self.queueNumber = Queue()
        self.process = Process(target=self.run,
                               args=(self.queueColor, self.queueColorList, self.queueTime, self.queueNumber,))

    # * -----------
    # * Basic control and status methods
    # * -----------

    def start(self):
        if not self.process.is_alive():
            self.process.start()

    def stop(self):
        if self.process.is_alive():
            self.process.terminate()
            pixels.clear()
            pixels.show()
            self.process = self.process = Process(target=self.run, args=(
            self.queueColor, self.queueColorList, self.queueTime, self.queueNumber,))

    def get_status(self):
        col1 = self.color_to_RGB(self.color)
        col2 = self.RGB_to_hex(col1[0], col1[1], col1[2])
        retStr = "color=" + str(col2) + ";\ntime=" + str(self.time) + ";\ntimer=" + str(self.timer) \
                 + ";\nnumber=" + str(self.number) + ";\nmode=" + str(self.mode) + ";\neffect=" + str(self.effect) \
                 + ";\nprocess=" + str(self.process.is_alive())
        return retStr

    # * -----------
    # * Converts the RGB in different color schemes
    # * -----------

    def RGB_to_color(self, r, g, b):
        return ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF)

    def color_to_RGB(self, color):
        return (color >> 16) & 0xFF, (color >> 8) & 0xFF, color & 0xFF

    def hex_to_RGB(self, hex):
        hex = hex.lstrip('#')
        # print('RGB =', tuple(int(hex[i:i + 2], 16) for i in (0, 2, 4)))
        return tuple(int(hex[i:i + 2], 16) for i in (0, 2, 4))

    def RGB_to_hex(self, r, g, b):
        st = '{:02x}{:02x}{:02x}'.format(r, g, b)
        st = st.upper()
        return st

    # * -----------
    # * Set methods uses by flask server
    # * -----------

    # value = Hex-String
    # color = 28-Bit Int Value
    def set_color(self, value):
        if self.process.is_alive():
            self.color = int(value, 16)
            self.queueColor.put(self.color)

            for i in range(PIXEL_COUNT):
                self.colorList[i] = value
            self.queueColorList.put(self.colorList)
        else:
            self.color = int(value, 16)
            for i in range(PIXEL_COUNT):
                self.colorList[i] = value

    # colors = Hex-String list
    def set_pixels(self, colors):
        if self.process.is_alive():
            self.colorList = colors
            self.queueColorList.put(self.colorList)
        else:
            self.colorList = colors

    # Set time for changing in some Effects
    def set_time(self, value):
        if self.process.is_alive():
            self.time = value
            self.queueTime.put(self.time)
        else:
            self.time = value

    # Set timer for an countdown / auto shutdown
    def set_timer(self, value):
        self.timer = value

    # Set number of LEDs
    def set_number(self, value):
        if self.process.is_alive():
            self.number = value
            self.queueNumber.put(self.number)
        else:
            self.number = value

    # Select the mode -> alive := restart Process
    def select_mode(self, value):
        if value != -1:
            self.effect = -1
            if self.process.is_alive():
                self.mode = value
                self.stop()
                time.sleep(0.2)
                self.start()
            else:
                self.mode = value

    # Select the effect -> alive := restart Process
    def select_effect(self, value):
        if value != -1:
            self.mode = -1
            if self.process.is_alive():
                self.effect = value
                self.stop()
                time.sleep(0.2)
                self.start()
            else:
                self.effect = value

    # * -----------
    # * Area of used Methods for the effects / modes
    # * -----------

    def wheel(self, pos):
        if pos < 85:
            return Adafruit_WS2801.RGB_to_color(pos * 3, 255 - pos * 3, 0)
        elif pos < 170:
            pos -= 85
            return Adafruit_WS2801.RGB_to_color(255 - pos * 3, 0, pos * 3)
        else:
            pos -= 170
            return Adafruit_WS2801.RGB_to_color(0, pos * 3, 255 - pos * 3)

    # col := (r, g, b) - Tupel
    def road_map(self, *col):
        length = len(col)
        part = int(pixels.count() / (len(col) - 1))
        for i in range(0, len(col) - 1):
            difR = col[i + 1][0] - col[i][0]
            difG = col[i + 1][1] - col[i][1]
            difB = col[i + 1][2] - col[i][2]
            difR = int(difR / part)
            difG = int(difG / part)
            difB = int(difB / part)
            # r, g, b = pixels.get_pixel_rgb(i)
            for j in range(part * i, part * (i + 1)):
                pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(
                    col[i][0] + (j * difR), col[i][1] + (j * difG), col[i][2] + (j * difB)))
            pixels.show()

    # * -----------
    # * Process loop
    # * -----------

    def checkQueue(self):
        # Reading Queues
        while True:
            if not self.queueColor.empty():
                self.color = self.queueColor.get()
            if not self.queueColorList.empty():
                self.colorList = self.queueColorList.get()
            if not self.queueTime.empty():
                self.time = self.queueTime.get()
            if not self.queueNumber.empty():
                self.number = self.queueNumber.get()
            time.sleep(1)

    # new process -> communication with queue
    def run(self, queueColor, queueColorList, queueTime, queueNumber):
        tmp = 0
        # check Queue -> oefters abfragen!
        t = Thread(target=self.checkQueue)
        t.setDaemon(True)
        t.start()
        while True:

            time.sleep(0.001)

            # * -----------
            # * Effects
            # * -----------

            # 0) led_on
            if self.effect == 0:
                Effects.showAll(self.colorList)

            # 1) Effect - Walking Pixels
            if self.effect == 1:
                Effects.walkingPixels(self.colorList, self.time, False)

            # 2) Effect - Walking Pixels reverse
            if self.effect == 2:
                Effects.walkingPixels(self.colorList, self.time, True)

            # 3) Effect - Fill number Pixels
            if self.effect == 3:
                Effects.fillNPixels(self.colorList, self.number)

            # 4) Effect - Get empty Pixels
            if self.effect == 4:
                Effects.emptyPixels(self.colorList, self.timer)

            # 5) Effect - Countdown Pixels
            if self.effect == 5:
                Effects.countdown(self.timer)

            # 6) Effect - Pulsing Pixels
            if self.effect == 6:
                Effects.pulsing(self.color, self.time)

            # 7) Effect - Dim-off Pixels
            if self.effect == 7:
                Effects.dimOff(self.color, self.timer)

            # 8) Effect - Rainbow Pixels (Static color changing)
            if self.effect == 8:
                Effects.rainbow(self, self.time)

            # 9) Effect - Walking Rainbow Pixels
            if self.effect == 9:
                Effects.rainbowWalking(self, self.time)

            # 10) Effect - Pulsing Rainbow Pixels
            if self.effect == 10:
                Effects.rainbowPulsing(self, self.time)

            # -------------- NO DOKU -----------------
            # 11) Effect - Cyclon Pixels
            if self.effect == 11:
                Effects.cyclon(self.colorList, self.number, self.time)

            # 12) Effect - Twinkle Pixels
            if self.effect == 12:
                Effects.twinkle(self.color, self.time)

            # 13) Effect - Twinkle Random Pixels
            if self.effect == 13:
                Effects.twinkleRandomColor(self.time)

            # 14) Effect - Sparkle Pixels
            if self.effect == 14:
                Effects.sparkle(self.colorList, self.time)

            # 15) Effect - Snow Sparkle Pixels
            if self.effect == 15:
                Effects.sparkleSnow(self.colorList, self.time)

            # 16) Effect - Running Pixels
            if self.effect == 16:
                Effects.running(self.color, self.time)

            # 17) Effect - Theater chase Pixels
            if self.effect == 17:
                Effects.theaterChase(self.colorList, self.time)

            # 18) Effect - Center bounce Pixels
            if self.effect == 18:
                Effects.centerBounce(self.colorList, self.number, self.time)

            # 22) Effect - Fire Pixels
            if self.effect == 67:
                Effects.fire(self.time)

            # 23) Effect - Meteor Pixels
            if self.effect == 68:
                Effects.meteor(self.color, self.number, self.time)

            # * -----------
            # * Modes
            # * -----------

            # 0) Mode - On Pixels
            if self.mode == 0:
                for i in range(len(self.colorList)):
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                pixels.show()
            # 1) Mode - Chill Pixels
            if self.mode == 1:
                self.road_map((178, 15, 174), (23, 197, 210), (37, 41, 88))
            # 2) Mode - Custom Color Theme
            if self.mode == 2:
                for i in range(len(self.colorList)):
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                pixels.show()
                time.sleep(self.time)
                # break

            # self.value = self.value + 1
            # print(self.value)
            # time.sleep(self.time)
