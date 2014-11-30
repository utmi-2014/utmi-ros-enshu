#!/usr/bin/env roseus
;; 15班 (Tennin Yan, Tomoya Yoshizawa, Kentaro Wada)

(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "kobuki_msgs")

(ros::roseus "make_sound")

	(ros::advertise "/mobile_base/commands/sound" kobuki_msgs::Sound 1)
	(ros::rate 100)
	(while (ros::ok)
	 (setq msg (instance kobuki_msgs::Sound :init))
	 (send msg :value 1)
	 ;;  (ros::ros-info "[~A]" (send msg :value))
	 (ros::publish "/mobile_base/commands/sound" msg)
	 (ros::sleep)
	)
	(ros::roseus "shutdown")

(exit)
