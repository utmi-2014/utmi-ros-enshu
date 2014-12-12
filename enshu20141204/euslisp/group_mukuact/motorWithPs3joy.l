(progn
(ros::rate 10)
(do-until-key
(ros::spin-once)
(ros::sleep)
(setq a (* 30 (send *joy* :ljoy-lr)))

(print a)
(send (send *dxl-armed-turtlebot* :arm_joint1) :joint-angle a)
(send *irtviewer* :draw-objects)
))
