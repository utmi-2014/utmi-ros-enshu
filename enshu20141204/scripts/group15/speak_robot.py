#!/usr/bin/python
# -*- coding:utf-8 -*-
# speak_robot.py
# author: Kentaro Wada <www.kentaro.wada@gmail.com>

import os

import rospy
from std_msgs.msg import String


def callback(data):
    speech = data.data
    speech = speech.replace(' ', '+')

    url = "'http://translate.google.com/translate_tts?tl={0}&q={1}'"
    url = url.format('ja', speech)
    os.system('gnome-open {0}'.format(url))


def speak_robot():
    rospy.init_node('speak_robot')
    rospy.Subscriber('/enshu/speak_robot', String, callback)
    rospy.spin()


if __name__ == '__main__':
    speak_robot()