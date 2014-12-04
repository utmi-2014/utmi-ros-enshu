#!/usr/bin/env python
#-*- coding: utf-8 -*-
# ytk_demo.py

import rospy

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
        rospy.Subscriber('/enshu/detect_face', String, self.cb_detect_face)

        self.start_demo = False
        self.exist_man_5frame = [False] * 5

    def cb_detect_face(self, data):
        """update exist_man_5frame"""
        self.exist_man_5frame.pop(0)
        self.exist_man_5frame.append(data.data)

    def main(self):
        while True:
            # check if man exists
            if all(self.exist_man_5frame) is True:
                self.start_demo = True
            if self.start_demo is True:
                rospy.sleep(2)
                # firstly after found man 5 times say hello
                self.pub_speak_robot.publish(String('こんにちは。'))
                rospy.sleep(4)
                # invite the man to be taken photo
                self.pub_speak_robot.publish(String('写真を撮りませんか？'))

    def test(self):
        rospy.sleep(4)
        self.pub_speak_robot.publish(String('こんにちは。'))
        rospy.sleep(4)
        self.pub_speak_robot.publish(String('写真を撮りませんか？'))


if __name__ == '__main__':
    rospy.sleep(15)
    ytk_demo = YtkDemo()
    # ytk_demo.main()
    ytk_demo.test()