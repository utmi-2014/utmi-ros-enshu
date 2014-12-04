#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: Kentaro Wada <www.kentaro.wada@gmail.com>

import rospy
from sensor_msgs.msg import CompressedImage
from std_msgs.msg import Empty

import cv2
import numpy as np


class TakePhoto(object):
    def __init__(self):
        self.frame = None
        rospy.init_node('take_photo')
        rospy.Subscriber('/image_color/compressed', CompressedImage, self.get_frame)
        rospy.Subscriber('/enshu/take_photo', Empty, self.save_frame)

    def get_frame(self, data):
        jpeg = data.data
        byte_array = bytearray(jpeg)
        file_bytes = np.array(byte_array)
        self.frame = cv2.imdecode(file_bytes, cv2.CV_LOAD_IMAGE_UNCHANGED)

    def save_frame(self, data):
        print "... saving photo"
        cv2.imwrite('/tmp/ytk_take_photo.jpeg', self.frame)


def main():
    take_photo = TakePhoto()
    rospy.spin()


if __name__ == '__main__':
    main()
