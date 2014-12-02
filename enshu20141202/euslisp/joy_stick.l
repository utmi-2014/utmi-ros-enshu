#!/usr/bin/env roseus
;; 15班 (Tennin Yan, Tomoya Yoshizawa, Kentaro Wada)

(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "sensor_msgs")

(ros::roseus "check3")

	(setq step_x 0)
	(setq step_y 0)
	(setq step_z 0)

; (setq grasp 0)

;; callback function
; (defun bumper-event-cb (bumper-event)
;   (print (list 'cb (sys::thread-self)
;                (send bumper-event :bumper)
;                (send bumper-event :state))))
; (ros::subscribe "/mobile_base/events/bumper" kobuki_msgs::BumperEvent #'bumper-event-cb)

(defun stick-event-cb (stick-event)
	(setq step_x 0)
	(setq step_y 0)
	(setq step_z 0)
  ; (print (list 'cb (sys::thread-self)
  ;              (send stick-event :axes)
  ;              (send stick-event :buttons)))
  ; (format t "joy_left = ~A~%" (elt (send stick-event :axes) 2)))
       (cond ((<  0.8 (elt (send stick-event :axes) 0)) (setq step_x 1))
             ((> -0.8 (elt (send stick-event :axes) 0)) (setq step_x -1))
             ((<  0.8 (elt (send stick-event :axes) 1)) (setq step_y 1))
             ((> -0.8 (elt (send stick-event :axes) 1)) (setq step_y -1))
             ((<  0.8 (elt (send stick-event :axes) 3)) (setq step_z 1))
    	     ((> -0.8 (elt (send stick-event :axes) 3)) (setq step_z -1))
             (t nil)
       )

    	(format t "step_x = ~A~%" step_x)
    	(format t "step_y = ~A~%" step_y)
    	(format t "step_z = ~A~%" step_z)
)

(ros::subscribe "/joy" sensor_msgs::Joy #'stick-event-cb)


(do-until-key
 (ros::spin-once)
)
