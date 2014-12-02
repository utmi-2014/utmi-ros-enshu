#!/usr/bin/env roseus
;; 15班 (Tennin Yan, Tomoya Yoshizawa, Kentaro Wada)

(load "package://dxl_armed_turtlebot/euslisp/dxl-armed-turtlebot-interface.l")
; (load "package://daisya_euslisp_tutorials/euslisp/daisya-ik.l")

(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "sensor_msgs")

(ros::roseus "check3")
(ros::rate 100)

(defun init-robot ()
  ;; init robot
  (dxl-armed-turtlebot-init)
  ;; reset pose
  (send *dxl-armed-turtlebot* :reset-pose)
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 5000)
  (send *ri* :wait-interpolation))

(setq step 10)
(setq x 0)
(setq y 0)
(setq z 0)
(defun joy-cb (msg)
  (let (ll)
    (setq goal-endcoords
          (make-cascoords :pos (send (send *dxl-armed-turtlebot* :arm :end-coords :copy-worldcoords) :worldpos)))

    ;; HERE >>
    ;; Update step_x, step_y, step_z
    (format t "axis: ~a~%" (send msg :axes))
    (format t "button: ~a~%" (send msg :buttons))
    ;; << HERE

    (send goal-endcoords
          :locate (float-vector step_x step_y step_z))
    ;; move robot
    (send *dxl-armed-turtlebot*
          :inverse-kinematics goal-endcoords
          :rotation-axis nil
          :debug-view nil
          :link-list ll)
    (send *ri* :wait-interpolation)))

(init-robot)
(ros::subscribe "/joy" sensor_msgs::Joy #'joy-cb)

(ros::spin)
