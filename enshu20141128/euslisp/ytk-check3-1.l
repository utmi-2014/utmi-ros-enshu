#!/usr/bin/env roseus

(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "kobuki_msgs")

(ros::roseus "check31")

;; callback function
(defun bumper-event-cb (bumper-event)
  (print (list 'cb (sys::thread-self)
               (send bumper-event :bumper)
               (send bumper-event :state))))
(ros::subscribe "/mobile_base/events/bumper" kobuki_msgs::BumperEvent #'bumper-event-cb)


(do-until-key
 (ros::spin-once)
)
