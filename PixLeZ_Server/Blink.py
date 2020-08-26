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
                # pixels.set_pixels(self.color)
                for i in range(len(self.colorList)):
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                pixels.show()

            # 1) Effect - Walking Pixels
            if self.effect == 1:
                pixels.clear()
                pixels.show()
                for i in range(pixels.count()):
                    for j in reversed(range(i, pixels.count())):
                        pixels.clear()
                        for k in range(i):
                            pixels.set_pixel(k, int(self.colorList[k], 16))
                            time.sleep(self.time)
                        pixels.set_pixel(j, int(self.colorList[j], 16))
                        pixels.show()
                        time.sleep(self.time)
            # 2) Effect - Walking Pixels reverse
            if self.effect == 2:
                pixels.clear()
                pixels.show()
                for i in range(pixels.count()):
                    for j in range(i, pixels.count()):
                        pixels.clear()
                        for k in range(i):
                            pixels.set_pixel(k, int(self.colorList[k], 16))
                            time.sleep(self.time)
                        pixels.set_pixel(j, int(self.colorList[j], 16))
                        pixels.show()
                        time.sleep(self.time)
            # 3) Effect - Fill number Pixels (even distribution)
            if self.effect == 3:
                pixels.clear()
                step = pixels.count() / self.number
                for i in range(0, self.number):
                    pixels.set_pixel(min(int(i * step), pixels.count() - 1), self.color)
                pixels.show()
            # 4) Effect - Get empty Pixels
            if self.effect == 4:
                for i in range(len(self.colorList)):
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                pixels.show()
                tmpTimer = self.timer / pixels.count()
                for i in range(pixels.count()):
                    pixels.set_pixel(i, 0)
                    pixels.show()
                    time.sleep(tmpTimer)
            # 5) Effect - Countdown Pixels
            if self.effect == 5:
                pixels.clear()
                pixels.show()
                tmpTimer = self.timer / pixels.count()
                for i in range(pixels.count()):
                    pixels.set_pixel(i, Adafruit_WS2801.RGB_to_color(255, 0, 0))
                    pixels.show()
                    time.sleep(tmpTimer)
                for i in range(5):
                    pixels.set_pixels(Adafruit_WS2801.RGB_to_color(0, 0, 0))
                    pixels.show()
                    time.sleep(1)
                    pixels.set_pixels(Adafruit_WS2801.RGB_to_color(255, 0, 0))
                    pixels.show()
                    time.sleep(1)
                break
            # 6) Effect - Pulsing Pixels
            if self.effect == 6:
                stateTmp = 0;
                tupelTmp = Adafruit_WS2801.color_to_RGB(self.color)
                while True:
                    if stateTmp == 0:
                        if tupelTmp[0] < 10 or tupelTmp[1] < 10 or tupelTmp[2] < 10:
                            stateTmp = 1
                        else:
                            tupelTmp = (tupelTmp[0] - 5, tupelTmp[1] - 5, tupelTmp[2] - 5)
                    else:
                        if tupelTmp[0] > 245 or tupelTmp[1] > 245 or tupelTmp[2] > 245:
                            stateTmp = 0
                        else:
                            tupelTmp = (tupelTmp[0] + 5, tupelTmp[1] + 5, tupelTmp[2] + 5)
                    pixels.set_pixels(Adafruit_WS2801.RGB_to_color(tupelTmp[0], tupelTmp[1], tupelTmp[2]))
                    pixels.show()
                    time.sleep(self.time)
            # TODO
            # 7) Effect - Dim-off Pixels
            if self.effect == 7:
                pixels.set_pixels(self.color)
                tupelTmp = Adafruit_WS2801.color_to_RGB(self.color)
                pixels.show()
                tmpTimer = self.timer / pixels.count()
                print(tmpTimer)
                # step = self.number
                step = 10
                for j in range(int(256 // step)):
                    for i in range(pixels.count()):
                        (r, g, b) = Adafruit_WS2801.color_to_RGB(pixels.get_pixel(i))
                        # rint(str(r) + str(g) + str(b))
                        # print(str(pixels.get_pixel_rgb(i)))
                        r = int(max(0, r - step))
                        g = int(max(0, g - step))
                        b = int(max(0, b - step))
                        # print(str(r) + str(g) + str(b))
                        pixels.set_pixel(i, Adafruit_WS2801.RGB_to_color(r, g, b))
                        pixels.show
                    pixels.show()
                    time.sleep(tmpTimer)
            # 8) Effect - Rainbow Pixels (Static color changing)
            if self.effect == 8:
                for j in range(256):  # one cycle of all 256 colors in the wheel
                    for i in range(pixels.count()):
                        pixels.set_pixel(i, self.wheel(((i * 256 // pixels.count()) + j) % 256))
                    pixels.show()
                    if self.time > 0:
                        time.sleep(self.time)
            # 9) Effect - Walking Rainbow Pixels
            if self.effect == 9:
                pixels.clear()
                pixels.show()
                for i in range(pixels.count()):
                    # tricky math! we use each pixel as a fraction of the full 96-color wheel
                    # (thats the i / strip.numPixels() part)
                    # Then add in j which makes the colors go around per pixel
                    # the % 96 is to make the wheel cycle around
                    pixels.set_pixel(i, self.wheel(((i * 256 // pixels.count())) % 256))
                    pixels.show()
                    if self.time > 0:
                        time.sleep(self.time)
            # 10) Effect - Pulsing Rainbow Pixels
            if self.effect == 10:
                for j in range(256):  # one cycle of all 256 colors in the wheel
                    for i in range(pixels.count()):
                        pixels.set_pixel(i, self.wheel(((256 // pixels.count() + j)) % 256))
                    pixels.show()
                    if self.time > 0:
                        time.sleep(self.time)
            # -------------- NO DOKU -----------------
            # 11) Effect - Cyclon Pixels
            if self.effect == 11:
                for i in range(pixels.count() - self.number - 2):
                    pixels.set_pixels(0)
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                    for j in range(1, self.number + 1):
                        pixels.set_pixel(i + j, int(self.colorList[i + j], 16))
                    pixels.set_pixel(i + self.number + 1, int(self.colorList[i + self.number + 1], 16))
                    pixels.show()
                    time.sleep(self.time)
                time.sleep(self.time)
                for i in reversed(range(pixels.count() - self.number - 2)):
                    pixels.set_pixels(0)
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                    for j in range(1, self.number + 1):
                        pixels.set_pixel(i + j, int(self.colorList[i + j], 16))
                    pixels.set_pixel(i + self.number + 1, int(self.colorList[i + self.number + 1], 16))
                    pixels.show()
                    time.sleep(self.time)
            # 12) Effect - Twinkle Pixels
            if self.effect == 12:
                pixels.set_pixels(0)
                for i in range(pixels.count()):
                    pixels.set_pixel(random.randint(0, pixels.count() - 1), self.color)
                    pixels.show()
                    time.sleep(self.time)
            # 13) Effect - Twinkle Random Pixels
            if self.effect == 13:
                pixels.set_pixels(0)
                for i in range(pixels.count()):
                    pixels.set_pixel(random.randint(0, pixels.count() - 1),
                                     Adafruit_WS2801.RGB_to_color(random.randint(0, 255),
                                                                  random.randint(0, 255),
                                                                  random.randint(0, 255)))
                    pixels.show()
                    time.sleep(self.time)
            # TODO: Pixel n outside the count of pixels erl?
            # 14) Effect - Sparkle Pixels
            if self.effect == 14:
                pTmp = random.randint(0, pixels.count() - 1)
                pixels.set_pixel(pTmp, int(self.colorList[pTmp], 16))
                pixels.show()
                time.sleep(self.time)
                pixels.set_pixel(pTmp, 0)
            # TODO: wie in 18 erl?
            # 15) Effect - Snow Sparkle Pixels
            if self.effect == 15:
                for i in range(len(self.colorList)):
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                pixels.show()
                pTmp = random.randint(0, pixels.count() - 1)
                pixels.set_pixel(pTmp, Adafruit_WS2801.RGB_to_color(0, 0, 0))
                pixels.show()
                time.sleep(self.time)
                pixels.set_pixel(pTmp, int(self.colorList[pTmp], 16))
                time.sleep(self.time)
            # 16) Effect - Running Pixels
            if self.effect == 16:
                posTmp = 0
                tupelTmp = Adafruit_WS2801.color_to_RGB(self.color)
                for j in range(pixels.count() * 2):
                    posTmp = posTmp + 1
                    for i in range(pixels.count()):
                        pixels.set_pixel(i, Adafruit_WS2801.RGB_to_color(
                            (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[0])),
                            (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[1])),
                            (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[2]))))
                    pixels.show()
                    time.sleep(self.time)
            # 17) Effect - Theater chase Pixels
            if self.effect == 17:
                for j in range(10):
                    for q in range(3):
                        for i in range(0, pixels.count() - 3, 3):
                            pixels.set_pixel(i + q, int(self.colorList[i + q], 16))
                        pixels.show()
                        time.sleep(self.time)
                        for i in range(0, pixels.count() - 3, 3):
                            pixels.set_pixel(i + q, 0)
                        pixels.show()
            # TODO: Pixel n outside the count of pixels
            # 18) Effect - Center bounce Pixels
            if self.effect == 18:
                # outside to center
                for i in range((pixels.count() - self.number) / 2):
                    pixels.set_pixels(0)
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                    for j in range(1, self.number):
                        pixels.set_pixel(i + j, int(self.colorList[i + j], 16))
                    pixels.set_pixel(i + self.number + 1, int(self.colorList[i + self.number + 1], 16))
                    pixels.set_pixel(pixels.count() - i - 1, int(self.colorList[pixels.count() - i - 1], 16))
                    for j in range(self.number + 1):
                        pixels.set_pixel(pixels.count() - i - j - 1,
                                         int(self.colorList[pixels.count() - i - j - 1], 16))
                    pixels.set_pixel(pixels.count() - i - self.number - 1,
                                     int(self.colorList[pixels.count() - i - self.number - 1], 16))

                    pixels.show()
                    time.sleep(self.time)
                time.sleep(self.time)
                # center to outside
                for i in reversed(range(0, (pixels.count() - self.number) / 2)):
                    pixels.set_pixels(0)
                    pixels.set_pixel(i, int(self.colorList[i], 16))
                    for j in range(1, self.number + 1):
                        pixels.set_pixel(i + j, int(self.colorList[i + j], 16))
                    pixels.set_pixel(i + self.number + 1, int(self.colorList[i + self.number + 1], 16))
                    pixels.set_pixel(pixels.count() - i - 1, int(self.colorList[pixels.count() - i - 1], 16))
                    for j in range(self.number + 1):
                        pixels.set_pixel(pixels.count() - i - j - 1,
                                         int(self.colorList[pixels.count() - i - j - 1], 16))
                    pixels.set_pixel(pixels.count() - i - self.number - 1,
                                     int(self.colorList[pixels.count() - i - self.number - 1], 16))

                    pixels.show()
                    time.sleep(self.time)
            # 22) Effect - Fire Pixels
            if self.effect == 67:
                '''
                TODO:
                gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::Yellow, CRGB::White);
                gPal = CRGBPalette16( CRGB::Black, CRGB::Blue, CRGB::Aqua,  CRGB::White);
                gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::White);
                '''
                for i in range(pixels.count()):
                    pos = int(pixels.count() / 4)
                    if i < pos:
                        for j in range(pos):
                            pixels.set_pixel(j, 0)
                    elif i < (pos * 2):
                        for j in range(pos, pos * 2):
                            # pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(166, 0, 0))
                            pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(4, 20, 128))
                    elif i < (pos * 3):
                        for j in range(pos * 2, pos * 3):
                            # pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(237, 232, 5))
                            pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(29, 60, 203))
                    else:
                        for j in range(pos * 3, pixels.count()):
                            pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(255, 255, 255))
                    pixels.show()

                cooldownTmp = 0
                # fast flames cool down 55
                cooling = 20
                # chance dass flamme entzuendet 120
                sparking = 120
                # heat = range(0, pixels.count())
                heat = [0] * pixels.count()

                for i in range(pixels.count()):
                    cooldownTmp = random.randint(0, ((cooling * 10) / pixels.count()) + 2);
                    if cooldownTmp > heat[i]:
                        heat[i] = 0
                    else:
                        heat[i] = heat[i] - cooldownTmp

                for k in reversed(range(2, pixels.count() - 1)):
                    heat[k] = (heat[k - 1] + heat[k - 2] + heat[k - 2]) / 3

                if random.randint(0, 255) < sparking:
                    y = random.randint(0, 7)
                    heat[y] = heat[y] + random.randint(160, 255)

                for j in range(pixels.count()):
                    t = int(round((heat[j] / 255.0) * 191))
                    heatramp = t & 0x3F
                    heatramp <<= 2

                    if t > 0x80:
                        pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(255, 255, heatramp))
                    elif t > 0x40:
                        pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(255, heatramp, 0))
                    else:
                        pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(heatramp, 0, 0))
                pixels.show()
                time.sleep(self.time)

            # TODO: doesnt work
            # 23) Effect - Meteor Pixels
            if self.effect == 68:
                meteorTrailDecay = 64
                pixels.set_pixels(0)
                for i in range(pixels.count() * 2):
                    for j in range(pixels.count()):
                        if random.randint(0, 10) > 5:
                            r, g, b = Adafruit_WS2801.color_to_RGB(pixels.get_pixel(j))
                            if r <= 10:
                                r = 0
                            else:
                                r = r - int((r * meteorTrailDecay / 256))
                            if g <= 10:
                                g = 0
                            else:
                                g = g - int((g * meteorTrailDecay / 256))
                            if b <= 10:
                                b = 0
                            else:
                                b = b - int((b * meteorTrailDecay / 256))
                            pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(r, g, b))
                    for j in range(self.number):
                        if (i - j < pixels.count()) and (i - j >= 0):
                            pixels.set_pixel(i - j, self.color)
                pixels.show()
                time.sleep(self.time)

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
