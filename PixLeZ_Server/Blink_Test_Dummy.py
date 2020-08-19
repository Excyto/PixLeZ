#!/usr/bin/env python

import sys
import random
import math

import time

from multiprocessing import Process
from multiprocessing import Queue
from threading import Thread

'''
    PixLeZ - Server
    
'''

# ! Select your pixel count
# 5 * 32 = 160 LEDs
PIXEL_COUNT = 160


class Blink(object):

    def __init__(self):
        self.value = 0
        self.color = 0
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
        self.process = Process(target=self.run, args=(self.queueColor, self.queueColorList, self.queueTime, self.queueNumber,))

    # * -----------
    # * Basic control and status methods
    # * -----------

    def start(self):
        if not self.process.is_alive():
            self.process.start()

    def stop(self):
        if self.process.is_alive():
            self.process.terminate()
            self.process = self.process = Process(target=self.run, args=(self.queueColor, self.queueColorList, self.queueTime, self.queueNumber, ))

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
        while True:
            
            # check Queue -> oefters abfragen!
            t = Thread(target=self.checkQueue)
            t.setDaemon(True)
            t.start()

            time.sleep(0.001)

            print('colorList' + ': ' + str(self.colorList))
            print('value' + ': ' + str(self.value))
            print('color' + ': ' + str(self.color))
            print('time' + ': ' + str(self.time))
            print('timer' + ': ' + str(self.timer))
            print('number' + ': ' + str(self.number))
            print('mode' + ': ' + str(self.mode))
            print('effect' + ': ' + str(self.effect))

            time.sleep(5)

            # self.value = self.value + 1
            # print(self.value)
            # time.sleep(self.time)

