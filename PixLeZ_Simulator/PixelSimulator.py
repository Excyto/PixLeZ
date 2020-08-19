from tkinter import *
import threading
from multiprocessing import Process
from multiprocessing import Queue

from PixelSimulatorConfig import *

'''
    PixLeZ - Simulator
    
'''

class PixelSimulator(object):
    def __init__(self):
        self.__ledMax = 160
        self.__xMax = 40
        self.__yMax = int(self.__ledMax / self.__xMax)
        self.__count = 0

        self.__arr = []
        self.__arrCol = []
        self.__root = Tk()
        self.__root.title("PixLeZ-Simulator")

        self.__runAuto = False
        self.__step = False
        self.__step_show = False
        self.__step_show_activ = IntVar()
        self.__running = False

        self.__frameMenu = Frame(borderwidth=20)
        self.__frameMenu.pack(anchor=NW)

        self.__buttonRun = Button(text="Run Program", master=self.__frameMenu)
        self.__buttonRun.bind("<Button-1>", self.__do_run)
        self.__buttonRun.pack(side=LEFT, padx=2)
        self.__buttonStop = Button(text="Stop Program", master=self.__frameMenu)
        self.__buttonStop.bind("<Button-1>", self.__do_stop)
        self.__buttonStop.pack(side=LEFT, padx=2)
        self.__buttonStep = Button(text="Step forward", master=self.__frameMenu)
        self.__buttonStep.bind("<Button-1>", self.__do_step)
        self.__buttonStep.pack(side=LEFT, padx=2)
        self.__buttonStepShow = Button(text="Step show", master=self.__frameMenu)
        self.__buttonStepShow.bind("<Button-1>", self.__do_show)
        self.__buttonStepShow.pack(side=LEFT, padx=2)
        self.__checkboxShow = Checkbutton(text="Step show", variable = self.__step_show_activ, master=self.__frameMenu)
        self.__checkboxShow.pack(side=LEFT, padx=2)

        self.__labelLedMax = Label(text="MAXLed:", master=self.__frameMenu)
        self.__labelLedMax.pack(side=LEFT, padx=10)

        self.__entryLedMax = Entry(master=self.__frameMenu, width=5)
        self.__entryLedMax.pack(side=LEFT, padx=2)
        self.__entryLedMax.delete(0, END)
        self.__entryLedMax.insert(0, 160)

        self.__buttonUpdate = Button(text="Select", master=self.__frameMenu)
        self.__buttonUpdate.pack(side=LEFT, padx=2)
        self.__buttonUpdate.bind("<Button-1>", self.__draw_led_spots)

        self.__frame01 = Frame(borderwidth=20)
        self.__frame01.pack()

        self.__running = True

        self.__file = PixelSimulatorConfig(simulator=self)
        self.__t1 = threading.Thread(target=self.__file.run)
        self.__t1.setDaemon(True)

    def is_running(self):
        return self.__running

    def __on_closing(self):
        self.__running = False
        # self.t1.join(2)
        self.__root.destroy()
        print(str("PixLeZ-Simulator closed"))

    # for starting the simulation, will be executed automatically after the start
    def run(self):
        # ! Run on top of the windows
        self.__root.attributes("-topmost", True)
        self.__root.protocol("WM_DELETE_WINDOW", self.__on_closing)
        self.__root.mainloop()

    def __draw_led_spots(self, event):
        self.__ledMax = int(self.__entryLedMax.get())
        for j in range(self.__yMax + 1):
            framePixels = Frame(master=self.__frame01)
            color = "FFFFFF"
            for i in range(self.__xMax):
                if self.__count < self.__ledMax:
                    label01 = Label(text=self.__count, foreground="black", background=str("#" + color), height=2, width=3,
                                    master=framePixels)
                    label01.pack(fill=BOTH, side=LEFT, expand=True, padx=2, pady=5)
                    self.__arr.append(label01)
                    self.__arrCol.append(color)
                    framePixels.pack()
                else:
                    label01 = Label(text="", height=1, width=2, master=framePixels)
                    label01.pack(fill=BOTH, side=LEFT, expand=True, padx=2, pady=5)
                    framePixels.pack()
                self.__count = self.__count + 1
        self.__labelLedMax.pack_forget()
        self.__entryLedMax.pack_forget()
        self.__buttonUpdate.pack_forget()
        self.__t1.start()

    def __do_run(self, event):
        self.__runAuto = True

    def __do_stop(self, event):
        self.__runAuto = False

    def __do_step(self, event):
        self.__step = True

    def __do_show(self, event):
        self.__step_show = True
        # print(self.__step_show_activ.get())

    def __wait_step(self):
        while self.__running:
            if self.__runAuto:
                return
            if self.__step_show_activ.get() == 1:
                return
            if self.__step:
                self.__step = False
                self.__step_show = False
                return

    def __wait_show(self):
        while self.__running:
            if self.__runAuto:
                return
            if self.__step_show_activ.get() == 0:
                return
            if self.__step_show:
                self.__step = False
                self.__step_show = False
                return

    # Set all pixels to 24-bit RGB color value
    def set_pixels(self, color):
        r, g, b = self.color_to_RGB(color)
        st = self.RGB_to_hex(r, g, b)
        for i in range(len(self.__arr)):
            self.__arr[i].config(bg=str("#" + st))
            self.__arrCol[i] = st
        self.__wait_step()

    # Set all pixels to 8-bit red, blue, green component
    def set_pixels_rgb(self, r, g, b):
        st = self.RGB_to_hex(r, g, b)
        for i in range(len(self.__arr)):
            self.__arr[i].config(bg=str("#" + st))
            self.__arrCol[i] = st
        self.__wait_step()

    # Set the pixel pos to 24-bit RGB color value
    def set_pixel(self, pos, color):
        r, g, b = self.color_to_RGB(color)
        st = self.RGB_to_hex(r, g, b)
        self.__arr[pos].config(bg=str("#" + st))
        self.__arrCol[pos] = st
        self.__wait_step()

    # Set the pixel pos to 8-bit red, blue, green component
    def set_pixel_rgb(self, pos, r, g, b):
        st = self.RGB_to_hex(r, g, b)
        self.__arr[pos].config(bg=str("#" + st))
        self.__arrCol[pos] = st
        self.__wait_step()

    # returns the 24-bit RGB color of the pixel pos
    def get_pixel(self, pos):
        r, g, b = self.hex_to_RGB(self.__arrCol[pos])
        return self.RGB_to_color(r, g, b)

    # returns a tupel of 3 with the red, blue, green component of pixel pos
    def get_pixel_rgb(self, pos):
        r, g, b = self.hex_to_RGB(self.__arrCol[pos])
        return (r, g, b)

    # in some libs it's necessary to call show after set_pixel -> Here only for compatibility
    def show(self):
        self.__wait_show()

    # returns the value of used LEDs
    def count(self):
        return self.__ledMax

    # set all of the pixels to black
    def clear(self):
        self.set_pixels_rgb(255, 255, 255)
        self.__wait_step()

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


if __name__ == '__main__':
    s = PixelSimulator()
    # s.run()
    s.run()
