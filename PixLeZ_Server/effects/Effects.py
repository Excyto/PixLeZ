#!/usr/bin/env python

import random
import math

import time
from typing import List

import adafruit_ws2801

import Blink
import Constants

pixels = Constants.pixels


def showAll(colorTupleList: List[tuple]):
    for i in range(len(colorTupleList)):
        pixels[i] = colorTupleList[i]
    pixels.show()


def walkingPixels(colorTupleList: List[tuple], timespan: float, reverse: bool):
    pixels.fill((0, 0, 0))
    pixels.show()
    for i in range(len(pixels)):
        rangeTmp = range(i, len(pixels))
        if reverse:
            rangeTmp = reversed(rangeTmp)
        for j in rangeTmp:
            pixels.fill((0, 0, 0))
            for k in range(i):
                pixels[k] = colorTupleList[k]
                time.sleep(timespan)
            pixels[j] = colorTupleList[j]
            pixels.show()
            time.sleep(timespan)


def fillNPixels(colorTuple: tuple, number: int):
    pixels.fill((0, 0, 0))
    step = len(pixels) / number
    for i in range(0, number):
        pixels[min(int(i * step), len(pixels) - 1)] = colorTuple
    pixels.show()


def emptyPixels(colorTupleList: List[tuple], timer: float):
    n_pixels = len(pixels)
    for i in range(len(colorTupleList)):
        pixels[i] = colorTupleList[i]
    pixels.show()
    tmpTimer = timer / n_pixels
    for i in range(n_pixels):
        pixels[i] = (0, 0, 0)
        pixels.show()
        time.sleep(tmpTimer)


def countdown(timer: float):
    pixels.fill((0, 0, 0))
    pixels.show()
    tmpTimer = timer / len(pixels)
    for i in range(len(pixels)):
        pixels[i] = (255, 0, 0)
        pixels.show()
        time.sleep(tmpTimer)
    for i in range(5):
        pixels.fill((0, 0, 0))
        pixels.show()
        time.sleep(1)
        pixels.fill((255, 0, 0))
        pixels.show()
        time.sleep(1)


def pulsing(color: tuple, timespan: float):
    stateTmp = 0
    tupelTmp = color
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
        pixels.fill(tupelTmp)
        pixels.show()
        time.sleep(timespan)


def dimOff(color: tuple, timer: float):
    # TODO
    pixels.fill(color)
    tupelTmp = color
    pixels.show()
    tmpTimer = timer / len(pixels)
    print(tmpTimer)
    # step = self.number
    step = 10
    for j in range(int(256 // step)):
        for i in range(len(pixels)):
            (r, g, b) = (pixels[i])
            # rint(str(r) + str(g) + str(b))
            # print(str(pixels.get_pixel_rgb(i)))
            r = int(max(0, r - step))
            g = int(max(0, g - step))
            b = int(max(0, b - step))
            # print(str(r) + str(g) + str(b))
            pixels[i] = (r, g, b)
        pixels.show()
        time.sleep(tmpTimer)


def rainbow(blink: Blink, timespan: float):
    for j in range(256):  # one cycle of all 256 colors in the wheel
        for i in range(len(pixels)):
            pixels[i] = blink.wheel(((i * 256 // len(pixels)) + j) % 256)
        pixels.show()
        if timespan > 0:
            time.sleep(timespan)


def rainbowWalking(blink: Blink, timespan: float):
    pixels.fill((0, 0, 0))
    pixels.show()
    for i in range(len(pixels)):
        # tricky math! we use each pixel as a fraction of the full 96-color wheel
        # (thats the i / strip.numPixels() part)
        # Then add in j which makes the colors go around per pixel
        # the % 96 is to make the wheel cycle around
        pixels[i] = blink.wheel((i * 256 // len(pixels)) % 256)
        pixels.show()
        if timespan > 0:
            time.sleep(timespan)


def rainbowPulsing(blink: Blink, timespan: float):
    for j in range(256):  # one cycle of all 256 colors in the wheel
        for i in range(len(pixels)):
            pixels[i] = blink.wheel((256 // len(pixels) + j) % 256)
        pixels.show()
        if timespan > 0:
            time.sleep(timespan)


def cyclon(colorList: List[tuple], number: int, timespan: float):
    for i in range(len(pixels) - number - 2):
        pixels.fill((0, 0, 0))
        pixels[i] = colorList[i]
        for j in range(1, number + 1):
            pixels[i + j] = colorList[i + j]
        pixels[i + number + 1] = colorList[i + number + 1]
        pixels.show()
        time.sleep(timespan)
    time.sleep(timespan)
    for i in reversed(range(len(pixels) - number - 2)):
        pixels.fill((0, 0, 0))
        pixels[i] = colorList[i]
        for j in range(1, number + 1):
            pixels[i + j] = colorList[i + j]
        pixels[i + number + 1] = colorList[i + number + 1]
        pixels.show()
        time.sleep(timespan)


def twinkle(color: tuple, timespan: float):
    pixels.fill((0, 0, 0))
    for i in range(len(pixels)):
        pixels[random.randint(0, len(pixels) - 1)] = color
        pixels.show()
        time.sleep(timespan)


def twinkleRandomColor(timespan: float):
    pixels.fill((0, 0, 0))
    for i in range(len(pixels)):
        pixels[random.randint(0, len(pixels) - 1)] = (random.randint(0, 255),
                                                      random.randint(0, 255),
                                                      random.randint(0, 255))
        pixels.show()
        time.sleep(timespan)


# TODO: Pixel n outside the count of pixels erl?
def sparkle(colorList: List[tuple], timespan: float):
    pTmp = random.randint(0, len(pixels) - 1)
    pixels[pTmp] = colorList[pTmp]
    pixels.show()
    time.sleep(timespan)
    pixels[pTmp] = (0, 0, 0)


# TODO: wie in 18 erl?
def sparkleSnow(colorList: List[tuple], timespan: float):
    for i in range(len(colorList)):
        pixels[i] = colorList[i]
    pixels.show()
    pTmp = random.randint(0, len(pixels) - 1)
    pixels[pTmp] = (0, 0, 0)
    pixels.show()
    time.sleep(timespan)
    pixels[pTmp] = colorList[pTmp]
    time.sleep(timespan)


def running(color: tuple, timespan: float):
    posTmp = 0
    tupelTmp = color
    for j in range(len(pixels) * 2):
        posTmp = posTmp + 1
        for i in range(len(pixels)):
            pixels[i] = (
                (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[0])),
                (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[1])),
                (int(((math.sin(i + posTmp) * 127 + 128) / 255) * tupelTmp[2])))
        pixels.show()
        time.sleep(timespan)


def theaterChase(colorList: List[tuple], timespan: float):
    for j in range(10):
        for q in range(3):
            for i in range(0, len(pixels) - 3, 3):
                pixels[i + q] = colorList[i + q]
            pixels.show()
            time.sleep(timespan)
            for i in range(0, len(pixels) - 3, 3):
                pixels[i + q] = (0, 0, 0)
            pixels.show()


# TODO: Pixel n outside the count of pixels
def centerBounce(colorList: List[tuple], number: int, timespan: float):
    # outside to center
    for i in range(int((len(pixels) - number) / 2)):
        pixels.fill((0, 0, 0))
        pixels[i] = colorList[i]
        for j in range(1, number):
            pixels[i + j] = colorList[i + j]
        pixels[i + number + 1] = colorList[i + number + 1]
        pixels[len(pixels) - i - 1] = colorList[len(pixels) - i - 1]
        for j in range(number + 1):
            pixels[len(pixels) - i - j - 1] = colorList[len(pixels) - i - j - 1]
        pixels[len(pixels) - i - number - 1] = colorList[len(pixels) - i - number - 1]

        pixels.show()
        time.sleep(timespan)
    time.sleep(timespan)
    # center to outside
    for i in reversed(range(0, int((len(pixels) - number) / 2))):
        pixels.fill((0, 0, 0))
        pixels[i] = colorList[i]
        for j in range(1, number + 1):
            pixels[i + j] = colorList[i + j]
        pixels[i + number + 1] = colorList[i + number + 1]
        pixels[len(pixels) - i - 1] = colorList[len(pixels) - i - 1]
        for j in range(number + 1):
            pixels[len(pixels) - i - j - 1] = colorList[len(pixels) - i - j - 1]
        pixels[len(pixels) - i - number - 1] = colorList[len(pixels) - i - number - 1]

        pixels.show()
        time.sleep(timespan)


def fire(timespan: float):
    """
    TODO:
    gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::Yellow, CRGB::White);
    gPal = CRGBPalette16( CRGB::Black, CRGB::Blue, CRGB::Aqua,  CRGB::White);
    gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::White);
    """
    for i in range(len(pixels)):
        pos = int(len(pixels) / 4)
        if i < pos:
            for j in range(pos):
                pixels[j] = (0, 0, 0)
        elif i < (pos * 2):
            for j in range(pos, pos * 2):
                # pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(166, 0, 0))
                pixels[j] = (4, 20, 128)
        elif i < (pos * 3):
            for j in range(pos * 2, pos * 3):
                # pixels.set_pixel(j, Adafruit_WS2801.RGB_to_color(237, 232, 5))
                pixels[j] = (29, 60, 203)
        else:
            for j in range(pos * 3, len(pixels)):
                pixels[j] = (255, 255, 255)
        pixels.show()

    cooldownTmp = 0
    # fast flames cool down 55
    cooling = 20
    # chance dass flamme entzuendet 120
    sparking = 120
    # heat = range(0, len(pixels))
    heat = [0] * len(pixels)

    for i in range(len(pixels)):
        cooldownTmp = random.randint(0, int(((cooling * 10) / len(pixels)) + 2))
        if cooldownTmp > heat[i]:
            heat[i] = 0
        else:
            heat[i] = heat[i] - cooldownTmp

    for k in reversed(range(2, len(pixels) - 1)):   # TODO: Unexpected type
        heat[k] = (heat[k - 1] + heat[k - 2] + heat[k - 2]) / 3

    if random.randint(0, 255) < sparking:
        y = random.randint(0, 7)
        heat[y] = heat[y] + random.randint(160, 255)

    for j in range(len(pixels)):
        t = int(round((heat[j] / 255.0) * 191))
        heatramp = t & 0x3F
        heatramp <<= 2

        if t > 0x80:
            pixels[j] = (255, 255, heatramp)
        elif t > 0x40:
            pixels[j] = (255, heatramp, 0)
        else:
            pixels[j] = (heatramp, 0, 0)
    pixels.show()
    time.sleep(timespan)


# TODO: doesnt work
def meteor(color: tuple, number: int, timespan: float):
    meteorTrailDecay = 64
    pixels.set_pixels(0)
    for i in range(len(pixels) * 2):
        for j in range(len(pixels)):
            if random.randint(0, 10) > 5:
                r, g, b = pixels[j]
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
                pixels[j] = (r, g, b)
        for j in range(number):
            if (i - j < len(pixels)) and (i - j >= 0):
                pixels[i - j] = color
    pixels.show()
    time.sleep(timespan)
