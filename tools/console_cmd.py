#!/usr/bin/evn python
# -*- encoding:utf-8 -*-
# function: 调试窗口样式
# date:2020-09-21
# Arthor:Timbaland
import ctypes
import sys

STD_INPUT_HANDLE = -10
STD_OUTPUT_HANDLE = -11
STD_ERROR_HANDLE = -12
FOREGROUND_RED = 0x0c  # red.
FOREGROUND_GREEN = 0x0a  # green.
FOREGROUND_BLUE = 0x09  # blue.
# get handle
std_out_handle = ctypes.windll.kernel32.GetStdHandle(STD_OUTPUT_HANDLE)


def set_cmd_text_color(color, handle=std_out_handle):
    Bool = ctypes.windll.kernel32.SetConsoleTextAttribute(handle, color)
    return Bool



def resetColor(color):
    set_cmd_text_color(color)



def printDarkBlue(mess, color):
    set_cmd_text_color(color)

    sys.stdout.write(mess)
    resetColor(color)