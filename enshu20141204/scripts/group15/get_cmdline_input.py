#!/usr/bin/env python
# -*- coding: utf-8 -*-
# get_cmdline_input.py
# author: Kentaro Wada <www.kentaro.wada@gmail.com>
import rospy
from std_msgs.msg import String


def get_cmdline_input():
    pub = rospy.Publisher('/enshu/get_cmdline_input', String)
    rospy.init_node('get_cmdline_input')

    data = raw_input("email: ")
    # rospy.loginfo(data)
    pub.publish(String(data))


if __name__ == '__main__':
    try:
        get_cmdline_input()
    except rospy.ROSInterruptException:
        pass
