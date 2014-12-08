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
        self.pub_catch_drink = rospy.Publisher('/enshu/catch_drink', Empty)
        # subscribers
        rospy.Subscriber('/enshu/detect_face', Bool, self.cb_detect_face)
        rospy.Subscriber('/enshu/get_cmdline_input', String, self.cb_get_cmdline_input)

        self.start_demo = False
        self.is_test = False
        self.cmdline_input = ''
        self.exist_man_5frame = [False] * 5

    def cb_detect_face(self, data):
        """update exist_man_5frame"""
        self.exist_man_5frame.pop(0)
        self.exist_man_5frame.append(data.data)

    def cb_get_cmdline_input(self, data):
        self.cmdline_input = data.data

    def main(self):
        # check if man exists
        if all(self.exist_man_5frame) is True:
            self.start_demo = True
        if self.start_demo is True or self.is_test is True:
            rospy.sleep(2)
            # firstly after found man 5 times say hello
            self.pub_speak_robot.publish(String('こんにちは。'))
            rospy.sleep(4)
            # select
            self.pub_speak_robot.publish(String('何をしますか？'))
            rospy.sleep(4)
            cmd = ('gnome-terminal -e "python /home/wken/catkin_ws/enshu/src/'
                'utmech-ros-enshu/enshu20141204/scripts/group15/get_cmdline_input.py select"')
            os.system(cmd)

            if self.cmdline_input == '1':
                # invite the man to be taken photo
                self.pub_speak_robot.publish(String('写真を撮りましょう！'))
                rospy.sleep(4)
                while all(self.exist_man_5frame) is not True:
                    # wait for the man faces to the camera
                    self.pub_speak_robot.publish(String('カメラに顔を向けてください'))
                    rospy.sleep(10)
                self.pub_speak_robot.publish(String('三・・二・・一'))
                rospy.sleep(4)
                self.pub_speak_robot.publish(String('カシャッ！'))
                rospy.sleep(1)
                self.pub_take_photo.publish()
                rospy.sleep(2)
                self.pub_speak_robot.publish(String('写真を撮りました。・・'
                                                    'メールで送ることができますので、・・'
                                                    'メールアドレスを打ち込んでください。・・'
                                                    'できればGmailでお願いします。'))
                rospy.sleep(13)
                # input email
                cmd = ('gnome-terminal -e "python /home/wken/catkin_ws/enshu/src/'
                    'utmech-ros-enshu/enshu20141204/scripts/group15/get_cmdline_input.py email"')
                os.system(cmd)
                # send mail
                body = ('上手く撮れていますか？\nまた, 私のプログラムはここにありますので、見てみてください。\n'
                        'https://github.com/wkentaro/utmech-ros-enshu/enshu20141204/scripts/group15/ytk_demo.py\n')
                subject = 'ytk_demo.py: Take Photo'
                attachment = '/tmp/ytk_take_photo.jpeg'
                cmd = 'echo "{0}" | mutt -s "{1}" -a {2} -- {3}'
                cmd = cmd.format(body, subject, attachment, self.cmdline_input)
                os.system(cmd)
                rospy.sleep(5)
                # say user to check the inbox
                self.pub_speak_robot.publish(String('メールを送りました。・・受信箱を確認してください。'))
                rospy.sleep(7)
            elif self.cmdline_input == '2':
                # pass drink
                self.pub_speak_robot.publish(String('お茶でもどうですか？'))
                rospy.sleep(7)
                self.pub_catch_drink.publish()
                rospy.sleep(25)

        self.start_demo = False


if __name__ == '__main__':
    ytk_demo = YtkDemo()
    ytk_demo.is_test = False

    rospy.sleep(10)
    while True:
        ytk_demo.main()