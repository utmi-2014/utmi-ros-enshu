;; robotの初期化
(load "package://dxl_armed_turtlebot/euslisp/dxl-armed-turtlebot-interface.l")
(dxl-armed-turtlebot-init)
(setq *robot* *dxl-armed-turtlebot*)

;;(send *robot* :reset-pose)
(send *robot* :tuckarm-pose) ;tucks the arm away from the line of sight
(send *ri* :angle-vector (send *robot* :angle-vector) 4000)
(send *ri* :wait-interpolation) 

;; jsk_pcl_rosのmsgを使うため、loadする
(ros::load-ros-manifest "jsk_pcl_ros")

;; クラスタリング結果であるBoundingBoxのtopic名
(defvar *topic-name* "/camera/depth_registered/boxes_red")
(defvar *topic-name1* "/camera/depth_registered/boxes_blue")
(defvar *bounding-box-list* nil)

;; ros::initする
(ros::roseus "boundingboxarray_subscriber")

;; コールバック関数
(defun bounding-box-array-cb (msg)
  (setq *bounding-box-list* (send msg :boxes)) ;; boxesは、BoundingBoxのArray(Euslispではlist)
  ;; BoundingBoxがあれば表示する
  (when *bounding-box-list*
    (send *irtviewer* :draw-objects :flush nil)
    ;(mapcar #'(lambda (b)
    (funcall #'(lambda (b)
                ;; BoundingBoxは、dimsntion(直方体の幅・奥行き・高さ)をもつ
                (let* ((dims (ros::tf-point->pos (send b :dimensions)))
                       (bx (make-cube (elt dims 0) (elt dims 1) (elt dims 2)))
                       ;; BoundingBoxのカメラ相対の座標系は、geometry_msgs/Poseという型で得られるので、Euslispのcoordsに変換する
                       (cam->obj-coords (ros::tf-pose->coords (send b :pose)))
                       ;; *dxl-armed-turtlebot*モデルがカメラの座標系をもってるので、取得する
                       (cam-coords (send (send *robot* :camera_depth_optical_frame_lk) :copy-worldcoords)))
                  ;; Euslisp内部でのworld座標系の値にして、そこにmake-cubeの箱を設置する
                  (send bx :newcoords (send cam-coords :transform cam->obj-coords))
                  (send bx :worldcoords)
                  (send bx :draw-on :flush nil :color #f(1 0 0)) ;; 描画

		  ;jsk_pcl_ros/msg/BoundingBoxArray.msg      Header and box
		  ;box    jsk_pcl_ros/msg/BoundingBox.msg   pose and dimension
		  ;pose   geometry_msgs/msg/Pose.msg   point and orientation
		  ;point     x y z
		  ;orientation   x y z w

		  ;Display the position of the box
		 ; (setq *pos* (send cam->obj-coords :worldpos))
				  (setq *pos* (send bx :worldpos))
				  
		  ;; :worldpos
		  (setq *x* (elt *pos* 0))
		  (setq *y* (elt *pos* 1))
		  ;(setq *z* (elt *pos* 2))
		  ;; (elt *pos* 0) ;; *pos*[0]

		  ;(print *x*)
		  ;(print *y*)
		  ;(print *z*)
		  (print *pos*)

		  ;Display the x and y dimensions of the box
            	  ;(print (elt dims 0))
  		  ;(print (elt dims 1))	;(print (elt dims 2)) ;z-dimension is 0
		  ;(print "this is driving me nuts")

		  (send *ri* :publish-led 1 :green)
		  
		  ;(send *ri* :go-pos 1 0 0)
		  ;(send *ri* :go-velocity 0 1 0) ;-10)
		  ;(send *ri* :go-velocity -1 0 0)

		  (if (> *x* 100)    ;if phase 1
		      (send *ri* :publish-led 1 :red)
		  
					;if red box is right in front, then move straight while rotating the body to the right ;;
					;(if (> (elt dims 0) 10)	  
	       	      (send *ri* :go-pos (-  *x* 50) (+ *y* 100) 0)
		  )
		   
		  (if (> *y* -100)    ;if phase 1
	       	      (send *ri* :go-velocity 0.0 0 15)
	       	      (send *ri* :go-velocity 0.2 0 0)

		   )

					;if it is to the left, move straight while slightly 


					;if phase 2
					;(send *ri* :publish-led 1 :yellow)
					;if phase 3
					;(send *ri* :publish-led 1 :green)

                  bx))
            ;*bounding-box-list*)
            (car *bounding-box-list*))
    (send *irtviewer* :viewer :viewsurface :flush)
  )
)

(defun bounding-box-array-cb1 (msg)
  (setq *bounding-box-list* (send msg :boxes)) ;; boxesは、BoundingBoxのArray(Euslispではlist)
  ;; BoundingBoxがあれば表示する
  (when *bounding-box-list*
    (send *irtviewer* :draw-objects :flush nil)
    ;(mapcar #'(lambda (b)
    (funcall #'(lambda (b)
                ;; BoundingBoxは、dimsntion(直方体の幅・奥行き・高さ)をもつ
                (let* ((dims (ros::tf-point->pos (send b :dimensions)))
                       (bx (make-cube (elt dims 0) (elt dims 1) (elt dims 2)))
                       ;; BoundingBoxのカメラ相対の座標系は、geometry_msgs/Poseという型で得られるので、Euslispのcoordsに変換する
                       (cam->obj-coords (ros::tf-pose->coords (send b :pose)))
                       ;; *dxl-armed-turtlebot*モデルがカメラの座標系をもってるので、取得する
                       (cam-coords (send (send *robot* :camera_depth_optical_frame_lk) :copy-worldcoords)))
                  ;; Euslisp内部でのworld座標系の値にして、そこにmake-cubeの箱を設置する
                  (send bx :newcoords (send cam-coords :transform cam->obj-coords))
                  (send bx :worldcoords)
                  (send bx :draw-on :flush nil :color #f(1 0 0)) ;; 描画

		  ;jsk_pcl_ros/msg/BoundingBoxArray.msg      Header and box
		  ;box    jsk_pcl_ros/msg/BoundingBox.msg   pose and dimension
		  ;pose   geometry_msgs/msg/Pose.msg   point and orientation
		  ;point     x y z
		  ;orientation   x y z w

		  ;Display the position of the box
		 ; (setq *pos* (send cam->obj-coords :worldpos))
				  (setq *pos* (send bx :worldpos))
				  
		  ;; :worldpos
		  (setq *x* (elt *pos* 0))
		  (setq *y* (elt *pos* 1))
		  ;(setq *z* (elt *pos* 2))
		  ;; (elt *pos* 0) ;; *pos*[0]

		  ;(print *x*)
		  ;(print *y*)
		  ;(print *z*)
		  (print *pos*)

		  ;Display the x and y dimensions of the box
            	  ;(print (elt dims 0))
  		  ;(print (elt dims 1))	;(print (elt dims 2)) ;z-dimension is 0
		  ;(print "this is driving me nuts")

		  (send *ri* :publish-led 1 :green)
		  
		  ;(send *ri* :go-pos 1 0 0)
		  ;(send *ri* :go-velocity 0 1 0) ;-10)
		  ;(send *ri* :go-velocity -1 0 0)

		  (if (> *x* 100)    ;if phase 1
		      (send *ri* :publish-led 1 :red)
		  
					;if red box is right in front, then move straight while rotating the body to the right ;;
					;(if (> (elt dims 0) 10)	  
	       	      (send *ri* :go-pos (-  *x* 50) (- *y* 100) 0)
		  )
		   
		  (if (< *y* 100)    ;if phase 1
	       	      (send *ri* :go-velocity 0.0 0 -15)
	       	      (send *ri* :go-velocity 0.2 0 0)

		   )

					;if it is to the left, move straight while slightly 


					;if phase 2
					;(send *ri* :publish-led 1 :yellow)
					;if phase 3
					;(send *ri* :publish-led 1 :green)

                  bx))
            ;*bounding-box-list*)
            (car *bounding-box-list*))
    (send *irtviewer* :viewer :viewsurface :flush)
  )
)


(defun string-cb (msg) 
  (print (send msg :bumper))
  (if (= (send msg :bumper) 0)
      (send *ri* :go-velocity 0.0 0 -10)
    (if (= (send msg :bumper) 2)
	(send *ri* :go-velocity 0.0 0 10)
      (if (= (send msg :bumper) 1)
	  (send *ri* :go-velocity -0.1 0 0))))

)
  
(ros::subscribe "/mobile_base/events/bumper" kobuki_msgs::BumperEvent #'string-cb)

(ros::subscribe *topic-name* jsk_pcl_ros::BoundingBoxArray #'bounding-box-array-cb 1)
(ros::subscribe *topic-name1* jsk_pcl_ros::BoundingBoxArray #'bounding-box-array-cb1 1)

(do-until-key
 (x::window-main-one) ;; IRT viewerの視点を変えられる。見にくければ変えよう
 (ros::spin-once)
 (ros::sleep)
 )
