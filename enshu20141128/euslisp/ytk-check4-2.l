#!/usr/bin/env roseus
;; 15班 (Tennin Yan, Tomoya Yoshizawa, Kentaro Wada)

(ros::load-ros-manifest "roseus")

(load "package://turtleboteus/euslisp/turtlebot-interface.l")

(ros::roseus "check42")

(turtlebot-init)

(ros::rate 100)

(setq lon 0)
(setq rvel 10)
(while (ros::ok)
       (send *ri* :go-velocity 0.0 0 rvel)
       (send *ri* :publish-led 1 lon)
       (setq bmpst (send *ri* :state :bumper-vector))
       (format t "bumper: ~A~%" bmpst)
       (setq btnst (send *ri* :state :button-vector))
       (format t "button: ~A~%" btnst)
       (cond ((= 1 (elt bmpst 0)) (setq rvel -10))
             ((= 1 (elt bmpst 2)) (setq rvel 10))
             ((= 1 (elt btnst 0)) (setq rvel 0))
             ((= 1 (elt btnst 1)) (setq lon 1))
             ((= 1 (elt btnst 2)) (setq lon 0))
             (t nil)
       )
       (ros::sleep))
(ros::roseus "shutdown")

(exit)

(do-until-key
  (ros::spin-once)
  )
