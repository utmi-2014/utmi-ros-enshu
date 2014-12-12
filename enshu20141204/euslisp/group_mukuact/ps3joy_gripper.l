
(load "package://test_keyop/euslisp/init.l")
(load "package://roseus/test/joy.l")
(init-ps3joy)
;(sample-ps3joy)
(progn
  (ros::rate 10)
  (do-until-key
   (ros::spin-once)
   (ros::sleep)
   ;(setq a (+ a (* 90 (send *joy* :ljoy-lr))))
   ;(setq b (+ b (* 90 (send *joy* :ljoy-fb))))
   ;(send (send *dxl-armed-turtlebot* :arm_joint1) :joint-angle a)
   ;(send (send *dxl-armed-turtlebot* :arm_joint3) :joint-angle b)
   (send *ri* :go-velocity (* 0.05 (send *joy* :ljoy-fb)) 0  (* 6  (send *joy* :ljoy-lr)))
   
   
   
   (if (= (send *joy* :circle-button) 1)
        ;;(print ";; circle button pressed"))
       (send *dxl-armed-turtlebot* :gripper :arm :angle-vector #f(50))
   )
   (if (= (send *joy* :square-button) 1)
        ;;(print ";; square button pressed"))
       (send *dxl-armed-turtlebot* :gripper :arm :angle-vector #f(0))
   )
   (send *irtviewer* :draw-objects)
   (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 1000 :gripper-controller)
  ;; (send *ri* :wait-interpolation :gripper-controller)
   (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 1000)
  ;; (send *ri* :wait-interpolation)
   
))