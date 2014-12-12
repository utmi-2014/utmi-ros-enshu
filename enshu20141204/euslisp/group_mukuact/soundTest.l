#!/usr/bin/env roseus
(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "kobuki_msgs")

(ros::roseus "sound")

(ros::advertise "/mobile_base/commands/sound" kobuki_msgs::Sound 1)
(ros::rate 1)
(while (ros::ok)
  (setq msg (instance kobuki_msgs::Sound :init))
  (send msg :value 6)
  (ros::publish "/mobile_base/commands/sound" msg)
  (ros::sleep))

(ros::roseus "shutdown")
(exit)