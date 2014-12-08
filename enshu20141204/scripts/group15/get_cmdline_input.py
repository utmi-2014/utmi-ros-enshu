#!/usr/bin/env python
# -*- coding: utf-8 -*-
# get_cmdline_input.py
# author: Kentaro Wada <www.kentaro.wada@gmail.com>
import rospy
from std_msgs.msg import String

import sys

def get_cmdline_input():
    pub = rospy.Publisher('/enshu/get_cmdline_input', String)
    rospy.init_node('get_cmdline_input')

    if sys.argv[1] == 'email':
        data = raw_input("email: ")
    elif sys.argv[1] == 'select':
        print "何をしてほしいですか？"
        print "1: 写真を撮らせる"
        print "2: お酌させる"
        data = raw_input("select: ")
    # rospy.loginfo(data)
    pub.publish(String(data))


if __name__ == '__main__':
    try:
        get_cmdline_input()
    except rospy.ROSInterruptException:
        pass
