#!/usr/bin/env python

import random
import math

import time
from typing import List

import Adafruit_WS2801

import Blink
import Constants

pixels = Constants.pixels


def showAll(colorList: List[str]):
    for i in range(len(colorList)):
        pixels.set_pixel(i, int(colorList[i], 16))
    pixels.show()


def walkingPixels(colorList: List[str], timespan: float, reverse: bool):
    pixels.clear()
    pixels.show()
    for i in range(pixels.count()):
        rangeTmp = range(i, pixels.count())
        if reverse:
            rangeTmp = reversed(rangeTmp)
        for j in rangeTmp:
            pixels.clear()
            for k in range(i):
                pixels.set_pixel(k, int(colorList[k], 16))
                time.sleep(timespan)
            pixels.set_pixel(j, int(colorList[j], 16))
            pixels.show()
            time.sleep(timespan)


def fillNPixels(color: int, number: int):
    pixels.clear()
    step = pixels.count() / number
    for i in range(0, number):
        pixels.set_pixel(min(int(i * step), pixels.count() - 1), color)
    pixels.show()


def emptyPixels(colorList: List[str], timer: float):
    for i in range(len(colorList)):
        pixels.set_pixel(i, int(colorList[i], 16))
    pixels.show()
    tmpTimer = timer / pixels.count()
    for i in range(pixels.count()):
        pixels.set_pixel(i, 0)
        pixels.show()
        time.sleep(tmpTimer)


def countdown(timer: float):
    pixels.clear()
    pixels.show()
    tmpTimer = timer / pixels.count()
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


def pulsing(color: int, timespan: float):
    stateTmp = 0
    tupelTmp = Adafruit_WS2801.color_to_RGB(color)
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
        time.sleep(timespan)


def dimOff(color: int, timer: float):
    # TODO
    pixels.set_pixels(color)
    tupelTmp = Adafruit_WS2801.color_to_RGB(color)
    pixels.show()
    tmpTimer = timer / pixels.count()
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
        pixels.show()
        time.sleep(tmpTimer)


def rainbow(blink: Blink, timespan: float):
    for j in range(256):  # one cycle of all 256 colors in the wheel
        for i in range(pixels.count()):
            pixels.set_pixel(i, blink.wheel(((i * 256 // pixels.count()) + j) % 256))
        pixels.show()
        if timespan > 0:
            time.sleep(timespan)


def rainbowWalking(blink: Blink, timespan: float):
    pixels.clear()
    pixels.show()
    for i in range(pixels.count()):
        # tricky math! we use each pixel as a fraction of the full 96-color wheel
        # (thats the i / strip.numPixels() part)
        # Then add in j which makes the colors go around per pixel
        # the % 96 is to make the wheel cycle around
        pixels.set_pixel(i, blink.wheel((i * 256 // pixels.count()) % 256))
        pixels.show()
        if timespan > 0:
            time.sleep(timespan)


def rainbowPulsing(blink: Blink, timespan: float):
    for j in range(256):  # one cycle of all 256 colors in the wheel
        for i in range(pixels.count()):
            pixels.set_pixel(i, blink.wheel((256 // pixels.count() + j) % 256))
        pixels.show()
        if timespan > 0:
            time.sleep(timespan)


def cyclon(colorList: List[str], number: int, timespan: float):
    for i in range(pixels.count() - number - 2):
        pixels.set_pixels(0)
        pixels.set_pixel(i, int(colorList[i], 16))
        for j in range(1, number + 1):
            pixels.set_pixel(i + j, int(colorList[i + j], 16))
        pixels.set_pixel(i + number + 1, int(colorList[i + number + 1], 16))
        pixels.show()
        time.sleep(timespan)
    time.sleep(timespan)
    for i in reversed(range(pixels.count() - number - 2)):
        pixels.set_pixels(0)
        pixels.set_pixel(i, int(colorList[i], 16))
        for j in range(1, number + 1):
            pixels.set_pixel(i + j, int(colorList[i + j], 16))
        pixels.set_pixel(i + number + 1, int(colorList[i + number + 1], 16))
        pixels.show()
        time.sleep(timespan)


def twinkle(color: int, timespan: float):
    pixels.set_pixels(0)
    for i in range(pixels.count()):
        pixels.set_pixel(random.randint(0, pixels.count() - 1), color)
        pixels.show()
        time.sleep(timespan)


def twinkleRandomColor(timespan: float):
    pixels.set_pixels(0)
    for i in range(pixels.count()):
        pixels.set_pixel(random.randint(0, pixels.count() - 1),
                         Adafruit_WS2801.RGB_to_color(random.randint(0, 255),
                                                      random.randint(0, 255),
                                                      random.randint(0, 255)))
        pixels.show()
        time.sleep(timespan)


# TODO: Pixel n outside the count of pixels erl?
def sparkle(colorList: List[str], timespan: float):
    pTmp = random.randint(0, pixels.count() - 1)
    pixels.set_pixel(pTmp, int(colorList[pTmp], 16))
    pixels.show()
    time.sleep(timespan)
    pixels.set_pixel(pTmp, 0)


# TODO: wie in 18 erl?
def sparkleSnow(colorList: List[str], timespan: float):
    for i in range(len(colorList)):
        pixels.set_pixel(i, int(colorList[i], 16))
    pixels.show()
    pTmp = random.randint(0, pixels.count() - 1)
    pixels.set_pixel(pTmp, Adafruit_WS2801.RGB_to_color(0, 0, 0))
    pixels.show()
    time.sleep(timespan)
    pixels.set_pixel(pTmp, int(colorList[pTmp], 16))
    time.sleep(timespan)


def running(color: int, timespan: float):
    posTmp = 0
    tupelTmp = Adafruit_WS2801.color_to_RGB(color)
    for j in range(pixels.count() * 2):
        posTmp = posTmp + 1
        for i in range(pixels.count()):
            pixels.set_pixel(i, Adafruit_WS2801.RGB_to_color(
                (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[0])),
                (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[1])),
                (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[2]))))
        pixels.show()
        time.sleep(timespan)


def theaterChase(colorList: List[str], timespan: float):
    for j in range(10):
        for q in range(3):
            for i in range(0, pixels.count() - 3, 3):
                pixels.set_pixel(i + q, int(colorList[i + q], 16))
            pixels.show()
            time.sleep(timespan)
            for i in range(0, pixels.count() - 3, 3):
                pixels.set_pixel(i + q, 0)
            pixels.show()


# TODO: Pixel n outside the count of pixels
def centerBounce(colorList: List[str], number: int, timespan: float):
    # outside to center
    for i in range(int((pixels.count() - number) / 2)):
        pixels.set_pixels(0)
        pixels.set_pixel(i, int(colorList[i], 16))
        for j in range(1, number):
            pixels.set_pixel(i + j, int(colorList[i + j], 16))
        pixels.set_pixel(i + number + 1, int(colorList[i + number + 1], 16))
        pixels.set_pixel(pixels.count() - i - 1, int(colorList[pixels.count() - i - 1], 16))
        for j in range(number + 1):
            pixels.set_pixel(pixels.count() - i - j - 1, int(colorList[pixels.count() - i - j - 1], 16))
        pixels.set_pixel(pixels.count() - i - number - 1,
                         int(colorList[pixels.count() - i - number - 1], 16))

        pixels.show()
        time.sleep(timespan)
    time.sleep(timespan)
    # center to outside
    for i in reversed(range(0, int((pixels.count() - number) / 2))):
        pixels.set_pixels(0)
        pixels.set_pixel(i, int(colorList[i], 16))
        for j in range(1, number + 1):
            pixels.set_pixel(i + j, int(colorList[i + j], 16))
        pixels.set_pixel(i + number + 1, int(colorList[i + number + 1], 16))
        pixels.set_pixel(pixels.count() - i - 1, int(colorList[pixels.count() - i - 1], 16))
        for j in range(number + 1):
            pixels.set_pixel(pixels.count() - i - j - 1, int(colorList[pixels.count() - i - j - 1], 16))
        pixels.set_pixel(pixels.count() - i - number - 1,
                         int(colorList[pixels.count() - i - number - 1], 16))

        pixels.show()
        time.sleep(timespan)


def fire(timespan: float):
    """
    TODO:
    gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::Yellow, CRGB::White);
    gPal = CRGBPalette16( CRGB::Black, CRGB::Blue, CRGB::Aqua,  CRGB::White);
    gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::White);
    """
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
        cooldownTmp = random.randint(0, ((cooling * 10) / pixels.count()) + 2)
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
    time.sleep(timespan)


# TODO: doesnt work
def meteor(color: int, number: int, timespan: float):
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
        for j in range(number):
            if (i - j < pixels.count()) and (i - j >= 0):
                pixels.set_pixel(i - j, color)
    pixels.show()
    time.sleep(timespan)
