import time
import random

'''
    PixLeZ - Simulator - Code Zone

'''

class PixelSimulatorConfig(object):
    def __init__(self, simulator):
        self.simulator = simulator
        self.ledMax = self.simulator.count()
        print(str("PixLeZ-Simulator init"))

    def run(self):
        print(str("PixLeZ-Simulator started"))
        while self.simulator.is_running:
            self.coding()

    def wheel(self, pos):
        if pos < 85:
            return self.simulator.RGB_to_color(pos * 3, 255 - pos * 3, 0)
        elif pos < 170:
            pos -= 85
            return self.simulator.RGB_to_color(255 - pos * 3, 0, pos * 3)
        else:
            pos -= 170
            return self.simulator.RGB_to_color(0, pos * 3, 255 - pos * 3)

    def road_map(self, *col):
        # col [0, 1, 2] -> len()=3
        part = int(self.ledMax / (len(col) - 1))
        for i in range(0, len(col) - 1):
            difR = col[i + 1][0] - col[i][0]
            difG = col[i + 1][1] - col[i][1]
            difB = col[i + 1][2] - col[i][2]
            difR = int(difR / part)
            difG = int(difG / part)
            difB = int(difB / part)
            # r, g, b = pixels.get_pixel_rgb(i)
            for j in range(part * i, part * (i + 1)):
                self.simulator.set_pixel(j, self.simulator.RGB_to_color(
                    col[i][0] + (j * difR), col[i][1] + (j * difG), col[i][2] + (j * difB)))
            self.simulator.show()

    # col als (r, g, b)
    def dim_up_range(self, anf, end, r, g, b):
        pixels = self.simulator
        # colBefore = (r, g, b)
        if end == anf:
            return
        step = 1 + (255 - max(r, g, b)) / (end - anf)
        for i in range(anf, end):
            r = int(min(255, r + step))
            g = int(min(255, g + (step + 1)))
            b = int(min(255, b + step))
            # print(str(r) + str(g) + str(b))
            pixels.set_pixel(i, pixels.RGB_to_color(r, g, b))
        pixels.show()

    # dir = 0 -> To 0, dir = 1 -> To 255
    def wave_it(self, col, direction):
        if direction == 0:
            colV = (0, 0, 0)
        else:
            colV = (255, 255, 255)
        steps = 100
        mult = 1

        difR = round(int((colV[0] - col[0]) / steps))
        difG = round(int((colV[1] - col[1]) / steps))
        difB = round(int((colV[2] - col[2]) / steps))
        col = (col[0] + (mult * difR), col[1] + (mult * difG), col[2] + (mult * difB))
        return col


    def coding(self):
        pixels = self.simulator
        # ! Run your code here:
        # self.road_map((178, 15, 174), (23, 197, 210), (37, 41, 88)) 
        # self.road_map((0, 0, 0), (160, 30, 30), (200, 30, 30))


        c1 = (10, 11, 200)
        c2 = (22, 26, 120)
        c3 = (36, 42, 224)
        c4 = (185, 53, 222)
        c5 = (187, 16, 235)
        c6 = (255, 0, 234)

        # self.road_map(c1, c2, c3, c4, c5, c6)
        self.road_map(c3, c4, c4, c5, c6)
        dimdown = True
        count = 0
        while(True):        
            if dimdown:
                for i in range(pixels.count()):
                    col = pixels.get_pixel_rgb(i)
                    if(col[0] < 15 or col[1] < 15 or col[2] < 15 or count > 10):
                        dimdown = False
                        count = 0
                        break
                    col = self.wave_it(col, 0)
                    pixels.set_pixel_rgb(i, col[0], col[1], col[2])
                pixels.show()
            else:
                for i in range(pixels.count()):
                    col = pixels.get_pixel_rgb(i)
                    if(col[0] > 245 or col[1] > 245 or col[2] > 245 or count > 10):
                        dimdown = True
                        count = 0
                        break
                    col = self.wave_it(col, 1)
                    pixels.set_pixel_rgb(i, col[0], col[1], col[2])
                pixels.show()
            count = count + 1

        # exit()



        '''
        # camp fire
        # * Color of the flame
        col = (200, 30, 30)     # red fire
        # col = (25, 25, 180)     # blue fire

        # * length/color of the base
        baseLength = 20
        step = 150

        # pixels.set_pixel_rgb(baseLength, col[0], col[1], col[2])
        # * color all to col
        for i in range(baseLength):
            # * Probability of base effect 0 = 100%; 4 = 25%
            r = random.randint(0, 8)
            rPos = random.randint(0, baseLength - 1)
            if r == 0:
                pixels.set_pixel_rgb(rPos, 0, 0, 0)
            pixels.set_pixel_rgb(i, col[0], col[1], col[2])
        # pixels.show()

        # * dim the pixels
        for i in range(baseLength):
            step = step - 6
            r, g, b = pixels.get_pixel_rgb(i)
            r = int(max(0, r - step))
            g = int(max(0, g - step))
            b = int(max(0, b - step))
            pixels.set_pixel(i, pixels.RGB_to_color(r, g, b))
        pixels.show()
        '''

        '''
        pixels.clear()
        time.sleep(0)
        for i in range(self.ledMax):
            pixels.set_pixel_rgb(i, 0, 0, 255)
            time.sleep(0.01)
           
        for j in range(256):  # one cycle of all 256 colors in the wheel
            for i in range(pixels.count()):
                pixels.set_pixel(i, self.wheel(((256 // pixels.count() + j)) % 256))
            pixels.show()
        time.sleep(0.1)
        '''