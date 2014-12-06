#!/usr/bin/env python
# -*- coding: utf-8 -*-
# detect_face.py
import rospy

from std_msgs.msg import Bool
from sensor_msgs.msg import CompressedImage
import sys

import cv2
import numpy as np


class DetectFace:
    def __init__(self):
        rospy.init_node('detect_face')
        self.pub = rospy.Publisher('/enshu/detect_face', Bool)
        rospy.Subscriber('/camera/rgb/image_raw/compressed', CompressedImage, self.callback)
        # rospy.Subscriber('/image_raw/compressed', CompressedImage, self.callback)
        self.detected = False

    def callback(self, data):
        jpeg = data.data
        byte_array = bytearray(jpeg)
        file_bytes = np.array(byte_array)
        image = cv2.imdecode(file_bytes, cv2.CV_LOAD_IMAGE_UNCHANGED)
        # print image

        # cascade_path = "/usr/share/opencv/haarcascades/haarcascade_frontalface_default.xml"
        cascade_path = "/usr/share/opencv/haarcascades/haarcascade_frontalface_alt.xml"
        # cascade_path = "/usr/share/opencv/haarcascades/haarcascade_frontalface_alt2.xml"
        # cascade_path = "/usr/share/opencv/haarcascades/haarcascade_frontalface_alt_tree.xml"

        # color = (255, 255, 255) #白

        #グレースケール変換
        #image_gray = cv2.cvtColor(image, cv2.cv.CV_BGR2GRAY)

        #カスケード分類器の特徴量を取得する
        cascade = cv2.CascadeClassifier(cascade_path)

        #facerect = cascade.detectMultiScale(image, scaleFactor=1.1, minNeighbors=1, minSize=(1, 1))
        facerect = cascade.detectMultiScale(image, scaleFactor=1.1, minNeighbors=3, minSize=(10, 10), flags = cv2.cv.CV_HAAR_SCALE_IMAGE)

        print facerect

        if len(facerect) <= 0:
            self.detected = False
            return

        # 検出した顔を囲む矩形の作成
        # for rect in facerect:
        #     cv2.rectangle(image, tuple(rect[0:2]),tuple(rect[0:2]+rect[2:4]), color, thickness=2)

        # 認識結果の保存
        cv2.imwrite("/tmp/test_detect_face.jpeg", image)
        print "face detected!"
        self.detected = True


def main():
    detect_face = DetectFace()

    while not rospy.is_shutdown():
        detect_face.pub.publish(Bool(detect_face.detected))
        rospy.sleep(1.)


if __name__ == '__main__':
    main()
