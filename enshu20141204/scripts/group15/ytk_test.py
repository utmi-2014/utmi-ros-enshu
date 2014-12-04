#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ytk_demo.py
# author: Kentaro Wada <www.kentaro.wada@gmail.com>

import rospy
import os
import sys

from std_msgs.msg import (
        String,
        Empty,
        Bool,
        )


class YtkDemo(object):
    def __init__(self):
        rospy.init_node('ytk_demo')
        # publishers
        self.pub_speak_robot = rospy.Publisher('/enshu/speak_robot', String)
        self.pub_take_photo = rospy.Publisher('/enshu/take_photo', Empty)
        # subscribers
        rospy.Subscriber('/enshu/detect_face', Bool, self.cb_detect_face)
        rospy.Subscriber('/enshu/get_cmdline_input', String, self.cb_get_cmdline_input)

        self.start_demo = False
        self.email = ''
        self.exist_man_5frame = [False] * 5

    def cb_detect_face(self, data):
        """update exist_man_5frame"""
        self.exist_man_5frame.pop(0)
        self.exist_man_5frame.append(data.data)

    def cb_get_cmdline_input(self, data):
        self.email = data.data

    def test(self):
        rospy.sleep(2)
        self.pub_speak_robot.publish(String('こんにちは。'))
        rospy.sleep(4)
        self.pub_speak_robot.publish(String('写真を撮りませんか？'))
        rospy.sleep(4)
        self.pub_speak_robot.publish(String('三・・二・・一'))
        rospy.sleep(4)
        self.pub_speak_robot.publish(String('カシャッ！'))
        rospy.sleep(1)
        self.pub_take_photo.publish()
        rospy.sleep(2)
        self.pub_speak_robot.publish(String('写真を撮りました。・・'
                                            'メールで送ることができますので、・・'
                                            'メールアドレスを打ち込んでください。'))
        rospy.sleep(11)

        # input email
        cmd = ('gnome-terminal -e "python /home/wken/catkin_ws/enshu/src/'
               'utmech-ros-enshu/enshu20141204/scripts/group15/get_cmdline_input.py"')
        os.system(cmd)

        # send mail
        body = ('上手く撮れていますか？\nまた, 私のプログラムはここにありますので、見てみてください。\n'
                'https://github.com/wkentaro/utmech-ros-enshu/enshu20141204/scripts/group15/ytk_demo.py\n')
        subject = 'ytk_demo.py: Take Photo'
        attachment = '/tmp/ytk_take_photo.jpeg'
        cmd = 'echo "{0}" | mutt -s "{1}" -a {2} -- {3}'
        cmd = cmd.format(body, subject, attachment, self.email)
        os.system(cmd)
        # say user to check the inbox
        self.pub_speak_robot.publish(String('メールを送りました。・・受信箱を確認してください。'))
        rospy.sleep(7)


if __name__ == '__main__':
    ytk_demo = YtkDemo()
    ytk_demo.test()