#!/usr/bin/env roseus

(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "kobuki_msgs")


(ros::roseus "listener")

(defclass bumper-event-class
  :super propertied-object
  :slots ())
(defmethod bumper-event-class
  (:init () (ros::subscribe "/mobile_base/events/bumper" kobuki_msgs::BumperEvent #'send self :string-cb))
  (:string-cb (msg)
			 (print (list 'cb (sys::thread-self)
						  (send msg :bumper)
						  (send msg :state)))))

(setq m (instance bumper-event-class :init))

(ros::spin)


