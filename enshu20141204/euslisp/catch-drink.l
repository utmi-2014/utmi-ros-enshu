#!/usr/bin/env roseus
;; 15班 (Tennin Yan, Tomoya Yoshizawa, Kentaro Wada)

(load "package://dxl_armed_turtlebot/euslisp/dxl-armed-turtlebot-interface.l")

(ros::load-ros-manifest "roseus")
;;(ros::load-ros-manifest "sensor_msgs")

(ros::roseus "check3")
(ros::rate 100)

(defun init-robot ()
  ;; init robot
  (dxl-armed-turtlebot-init)

      (send *irtviewer* :objects (list *dxl-armed-turtlebot*))
      (send *irtviewer* :draw-objects)
      (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 2000)
      (unix::sleep 1)
    nil)

(defun catch-drink ()
  ;; catch drink
  ;; open arm
  (send *dxl-armed-turtlebot* :gripper :arm :angle-vector #f(50))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 1000 :gripper-controller)
  (send *ri* :wait-interpolation :gripper-controller)
  (unix::sleep 1)
  ;; move arm
  (send *dxl-armed-turtlebot* :angle-vector #f(0 150 -45 -160 90 -20 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  ;; move arm near
  (send *dxl-armed-turtlebot* :angle-vector #f(0 150 -90 -180 90 -30 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  ;; start grasp
  (send *ri* :start-grasp)
  ;;(send *ri* :stop-grasp)
  ;; return init pos
  (send *dxl-armed-turtlebot* :angle-vector #f(0 150 -90 -160 90 -20 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  (send *dxl-armed-turtlebot* :angle-vector #f(0 130 -10 -180 90 -90 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  (send *dxl-armed-turtlebot* :angle-vector #f(0 0 0 0 0 -180 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  ;; pour drink
  (send *dxl-armed-turtlebot* :angle-vector #f(0 0 0 0 0 -120 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  ;; return init pos
  (send *dxl-armed-turtlebot* :angle-vector #f(0 0 0 0 0 -180 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  (send *dxl-armed-turtlebot* :angle-vector #f(0 130 -10 -180 90 -90 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  (send *dxl-armed-turtlebot* :angle-vector #f(0 150 -90 -160 90 -30 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  (send *dxl-armed-turtlebot* :angle-vector #f(0 150 -90 -180 90 -30 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  (send *ri* :stop-grasp)
  (unix::sleep 1)
  (send *dxl-armed-turtlebot* :angle-vector #f(0 150 -45 -160 90 -20 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  (unix::sleep 1)
  (send *dxl-armed-turtlebot* :angle-vector #f(0 0 0 0 0 0 0))
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector))
  )

(warn "
(init-robot)
(catch-drink)
")