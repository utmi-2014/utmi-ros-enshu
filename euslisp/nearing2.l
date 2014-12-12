;; robotの初期化
(load "package://dxl_armed_turtlebot/euslisp/dxl-armed-turtlebot-interface.l")
(dxl-armed-turtlebot-init)

(send *dxl-armed-turtlebot* :tuckarm-pose) ;tucks the arm away from the line of sight
(send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 4000)


;; jsk_pcl_rosのmsgを使うため、loadする
(ros::load-ros-manifest "jsk_pcl_ros")

;; クラスタリング結果であるBoundingBoxのtopic名
(defvar *topic-name* "/camera/depth_registered/boxesred")
(defvar *topic-name1* "/camera/depth_registered/boxesblue")
(defvar *bounding-box-list* nil)

;; ros::initする
(ros::roseus "boundingboxarray_subscriber")

(setq count 0)
;; コールバック関数
(defun bounding-box-array-cb (msg)

  (setq *bounding-box-list* (send msg :boxes)) ;; boxes_redは、BoundingBoxのArray(Euslispではlist)
  ;; BoundingBoxがあれば表示する
  (when *bounding-box-list*
    (send *irtviewer* :draw-objects :flush nil)
    (funcall #'(lambda (b)
                ;; BoundingBoxは、dimsntion(直方体の幅・奥行き・高さ)をもつ
                (let* ((dims (ros::tf-point->pos (send b :dimensions)))
					   
                       (bx (make-cube (elt dims 0) (elt dims 1) (elt dims 2)))
                       ;; BoundingBoxのカメラ相対の座標系は、geometry_msgs/Poseという型で得られるので、Euslispのcoordsに変換する
                       (cam->obj-coords (ros::tf-pose->coords (send b :pose)))
                       ;; *dxl-armed-turtlebot*モデルがカメラの座標系をもってるので、取得する
                       (cam-coords (send (send *dxl-armed-turtlebot* :camera_depth_optical_frame_lk) :copy-worldcoords)))
                  ;; Euslisp内部でのworld座標系の値にして、そこにmake-cubeの箱を設置する
                  (send bx :newcoords (send cam-coords :transform cam->obj-coords))
                  (send bx :worldcoords)

			; 
			; 	(send *dxl-armed-turtlebot* :reset-pose)
			; 	  (if 
			; 		  (send *dxl-armed-turtlebot* :inverse-kinematics
			; 				(make-coords :pos (v+ (float-vector -10 0 0) (send bx :worldpos))) :rotation-axis :z :thre 25)
			; 		  nil
			; 		(+ count 1))
			; 	  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 4000)
			; 	  (send *dxl-armed-turtlebot* :inverse-kinematics
			; 			(make-coords :pos (send bx :worldpos)))
			; 	  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 4000)
			; 	  (send *ri* :start-grasp)
			; 	  
			; 	  (print	(send bx :worldpos))
			; 	  (send bx :draw-on :flush nil :color #f(1 0 0))

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
				 ; (send *ri* :go-pos *x* *y* 0)

		  ;Display the x and y dimensions of the box
            	  ;(print (elt dims 0))
  		  ;(print (elt dims 1))	;(print (elt dims 2)) ;z-dimension is 0
		  ;(print "this is driving me nuts")

				  (send *ri* :publish-led 1 :green)
		  
		  ;(send *ri* :go-pos 1 0 0)
		  ;(send *ri* :go-velocity 0 1 0) ;-10)
		  ;(send *ri* :go-velocity -1 0 0)

				  (if (> *x* 100)
					  (progn									   ;if phase 1
					   (send *ri* :publish-led 1 :red)
					   (send *ri* :go-pos (/ (- *x* 400) 1000) 0 0)
					   
					   (send *ri* :go-pos 0 0 45)
					   (send *ri* :go-pos 0.4 0 0)
					   (send *ri* :go-pos 0 0 -45)
					   ;;(send *ri* :go-velocity 0.2 0 0)
					   ))
				  
				  ;(if (> *y* -100)
					  ;(progn;if phase 1
					   ;(send *ri* :go-velocity 0.0 0 15)
					   ;(send *ri* :go-velocity 0.2 0 0)))
					
													  ;; 描画
				  bx))
            (car *bounding-box-list*))
    (send *irtviewer* :viewer :viewsurface :flush)
    ))

(defun bounding-box-array-cb1 (msg)

  (setq *bounding-box-list* (send msg :boxes)) ;; boxes_redは、BoundingBoxのArray(Euslispではlist)
  ;; BoundingBoxがあれば表示する
  (when *bounding-box-list*
    (send *irtviewer* :draw-objects :flush nil)
    (funcall #'(lambda (b)
                ;; BoundingBoxは、dimsntion(直方体の幅・奥行き・高さ)をもつ
                (let* ((dims (ros::tf-point->pos (send b :dimensions)))
					   
                       (bx (make-cube (elt dims 0) (elt dims 1) (elt dims 2)))
                       ;; BoundingBoxのカメラ相対の座標系は、geometry_msgs/Poseという型で得られるので、Euslispのcoordsに変換する
                       (cam->obj-coords (ros::tf-pose->coords (send b :pose)))
                       ;; *dxl-armed-turtlebot*モデルがカメラの座標系をもってるので、取得する
                       (cam-coords (send (send *dxl-armed-turtlebot* :camera_depth_optical_frame_lk) :copy-worldcoords)))
                  ;; Euslisp内部でのworld座標系の値にして、そこにmake-cubeの箱を設置する
                  (send bx :newcoords (send cam-coords :transform cam->obj-coords))
                  (send bx :worldcoords)

			; 
			; 	(send *dxl-armed-turtlebot* :reset-pose)
			; 	  (if 
			; 		  (send *dxl-armed-turtlebot* :inverse-kinematics
			; 				(make-coords :pos (v+ (float-vector -10 0 0) (send bx :worldpos))) :rotation-axis :z :thre 25)
			; 		  nil
			; 		(+ count 1))
			; 	  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 4000)
			; 	  (send *dxl-armed-turtlebot* :inverse-kinematics
			; 			(make-coords :pos (send bx :worldpos)))
			; 	  (send *ri* :angle-vector (send *dxl-armed-turtlebot* :angle-vector) 4000)
			; 	  (send *ri* :start-grasp)
			; 	  
			; 	  (print	(send bx :worldpos))
			; 	  (send bx :draw-on :flush nil :color #f(1 0 0))

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
				 ; (send *ri* :go-pos *x* *y* 0)

		  ;Display the x and y dimensions of the box
            	  ;(print (elt dims 0))
  		  ;(print (elt dims 1))	;(print (elt dims 2)) ;z-dimension is 0
		  ;(print "this is driving me nuts")

				  (send *ri* :publish-led 1 :green)
		  
		  ;(send *ri* :go-pos 1 0 0)
		  ;(send *ri* :go-velocity 0 1 0) ;-10)
		  ;(send *ri* :go-velocity -1 0 0)

				  (if (> *x* 100)
					  (progn									   ;if phase 1
					   (send *ri* :publish-led 1 :green)
					   (send *ri* :go-pos (/ (- *x* 400) 1000) 0 0)
					   
					   (send *ri* :go-pos 0 0 -45)
					   (send *ri* :go-pos 0.4 0 0)
					   (send *ri* :go-pos 0 0 45)
					   ;;(send *ri* :go-velocity 0.2 0 0)
					   ))
				  
				  ;(if (> *y* -100)
					  ;(progn;if phase 1
					   ;(send *ri* :go-velocity 0.0 0 15)
					   ;(send *ri* :go-velocity 0.2 0 0)))
					
													  ;; 描画
				  bx))
            (car *bounding-box-list*))
    (send *irtviewer* :viewer :viewsurface :flush)
    ))

(ros::subscribe *topic-name* jsk_pcl_ros::BoundingBoxArray #'bounding-box-array-cb 1)
(ros::subscribe *topic-name1* jsk_pcl_ros::BoundingBoxArray #'bounding-box-array-cb1 1)

(do-until-key
 (x::window-main-one) ;; IRT viewerの視点を変えられる。見にくければ変えよう
 (ros::spin-once)
 (ros::sleep)
 )
