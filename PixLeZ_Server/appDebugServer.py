#!C:/Users/Tobi/AppData/Local/Programs/Python/Python36/python
#!/usr/bin/env python

from flask import Flask, request
import os
import subprocess
import sys
import time
from multiprocessing import Process

'''
    PixLeZ - Debug Server
    -> Without connection to Blink.py
    
'''

app = Flask(__name__)

# starts the process
@app.route('/start')
def start():
    return 'Process Started'

# stops the process
@app.route('/stop')
def stop():
    return 'Process Stopped'

# String color in HEX - Example /set/color/FF00FF
@app.route("/set/color/<string:color>")
def flask_set_color(color):
    return str("Color set to: " + str(color))

# time as floating number
@app.route('/set/time/<float:post_id>')
def flask_set_time(post_id):
    return 'Time set to %f' % post_id

# timer as floating number
@app.route('/set/timer/<float:post_id>')
def flask_set_timer(post_id):
    return 'Timer set to %f' % post_id

# number as integer
@app.route('/set/number/<int:post_id>')
def flask_set_number(post_id):
    return 'Number set to %d' % post_id

# mode as integer
@app.route('/select/mode/<int:post_id>')
def flask_select_mode(post_id):
    return 'Mode %d selected' % post_id

# effect as integer
@app.route('/select/effect/<int:post_id>')
def flask_select_effect(post_id):
    return 'Effect %d selected' % post_id

# returns the status of the attributes
@app.route('/status')
def flask_status():
    status = "color=" + str("0033AA") + ";\ntime=" + str(0.03) + ";\ntimer=" + str(20.2) \
                    + ";\nnumber=" + str(10) + ";\nmode=" + str(0) + ";\neffect=" + str(7) \
                    + ";\nprocess=" + str(True)
    return status

@app.route('/set/pixels', methods=['POST'])
def flask_set_pixels():
    req_data = request.get_json()
    example = req_data['pixels']
    s = ''
    for item in example:
        if item != '"' and item != '[' and item != ']':
            s = s + item
    colS = s.split(',')
    for item in colS:
        print(item)
    return ''

# Starts the application.
# ! Define the port and host
# ! Select your flask server settings
# ! doc: https://flask.palletsprojects.com/en/1.1.x/api/?highlight=run#flask.Flask.run
if __name__ == '__main__':
    # app.run(debug=True, port=8080, host="0.0.0.0")
    app.run(debug=True, port=5500)
