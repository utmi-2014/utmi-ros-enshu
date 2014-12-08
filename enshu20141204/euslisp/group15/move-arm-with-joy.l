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
  (send *dxl-armed-turtlebot* :reset-pose)
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 3000)
  (send *ri* :wait-interpolation))
(defun reset-robot ()
  ;; reset pose
  (send *dxl-armed-turtlebot* :reset-pose)
  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 3000)
  (send *ri* :wait-interpolation))

;; initialize step_x, y, z
(setq step 1)
(setq x 0)
(setq y 0)
(setq z 0)
(setq grasp-mode nil)
;; callback function
(defun joy-cb (msg)
    ;; joy stick input
    ; (format t "axis: ~a~%" (send msg :axes))
    ; (format t "button: ~a~%" (send msg :buttons))
    (if (= (elt (send msg :buttons) 11) 1)
      (cond ((<  0.8 (elt (send msg :axes) 0)) (setq y 1))
            ((> -0.8 (elt (send msg :axes) 0)) (setq y -1))
            ((<  0.8 (elt (send msg :axes) 1)) (setq x 1))
            ((> -0.8 (elt (send msg :axes) 1)) (setq x -1))
            ((<  0.8 (elt (send msg :axes) 3)) (setq z 1))
            ((> -0.8 (elt (send msg :axes) 3)) (setq z -1))
            (t (progn (setq x 0) (setq y 0) (setq z 0)))))
    ; grasp
    (print (send msg :buttons))
    (cond ((= (elt (send msg :buttons) 13) 1) (send *ri* :start-grasp))
          ((= (elt (send msg :buttons) 14) 1) (send *ri* :stop-grasp))
          ((= (elt (send msg :buttons) 15) 1) (reset-robot))
          (t nil))
    (format t "m:x,y,z: ~a~a~a~%" x y z))

(init-robot)
(ros::subscribe "/joy" sensor_msgs::joy #'joy-cb)

(do-until-key
  ;; initialize goal-endcoords
  (setq goal-endcoords
        (make-cascoords :pos (send (send *dxl-armed-turtlebot* :arm :end-coords :copy-worldcoords) :worldpos)))
  (ros::spin-once)
  ;; update goal-endcoords
  (format t "d:x,y,z: ~a~a~a~%" x y z)
  ; (print (send goal-endcoords :worldpos))
  ;; move arm
  (if (not (and (= x 0) (= y 0) (= z 0)))
    (progn
      (send goal-endcoords
            :locate (float-vector (* step x) (* step y) (* step z)))
      ;; move robot
      (send *dxl-armed-turtlebot*
            :inverse-kinematics goal-endcoords
            :rotation-axis nil
            :debug-view nil
            :link-list nil)
      (send *irtviewer* :objects (list *dxl-armed-turtlebot* goal-endcoords))
      ; (send *ri* :wait-interpolation)
      (send *irtviewer* :draw-objects)
      (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 2000))
      (unix::sleep 1)
    nil))
