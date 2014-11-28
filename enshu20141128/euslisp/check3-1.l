#!/usr/bin/env roseus

(ros::load-ros-manifest "roseus")
(ros::load-ros-manifest "kobuki_msgs")

(ros::roseus "check3-1")
;;(setq sys::*gc-hook* #'(lambda (a b) (format t ";; gc ~A ~A~%" a b)))

;; callback function
; (defun string-cb (msg) (print (list 'cb (sys::thread-self) (send msg :data))))
(defun bumper-event-cb (bumper-event) (print (list 'cb (sys::thread-self) (send bumper-event :state))))
(ros::subscribe "chatter" kobuki_msgs::BumperEvent #'bumper-event-cb)

; lambda function
;(ros::subscribe "chatter" std_msgs::string
;                #'(lambda (msg) (ros::rosinfo 
;                                 (format nil "I heard ~A" (send msg :data)))))

;; method call
; (defclass string-cb-class
;   :super propertied-object
;   :slots ())
; (defmethod string-cb-class
;   (:init () (ros::subscribe "chatter" std_msgs::string #'send self :string-cb))
;   (:string-cb (msg) (print (list 'cb self (send msg :data)))))
; (setq m (instance string-cb-class :init))

(do-until-key
 (ros::spin-once)
 ;;(sys::gc)
)
;(ros::spin)
