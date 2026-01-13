;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minkie Yume <minkieyume@yumieko.com>
(in-package #:org.minkieyume.trial-demo)

;; 定义main类型，继承自trial:main
(defclass <main> (trial:main)
  ())

;; 定义一个资源，在名为trial的资源池里面定义一个名为cat的材质。
;; 该资源的类型为image，路径为相对trial资源池路径里面的cat.png
(define-asset (trial cat) image
    #p"cat.png")

;; 定义名为<my-cube>的可渲染实体类型，继承vertex-entity transformed-entity listener这三个类型。
(define-shader-entity <my-cube> (vertex-entity textured-entity transformed-entity listener)
  ((vertex-array :initform (// 'trial 'unit-cube))
   (texture :initform (// 'trial 'cat))))

;; 定义事件处理器
;; <my-cube> 是类型，tick是事件名。
(define-handler (<my-cube> tick) (tt)
  (setf (orientation <my-cube>) (qfrom-angle +vy+ tt)))

;; 为main定义一个setup-scene方法，该方法会在场景加载时自动调用。
(defmethod setup-scene ((main <main>) scene)
  (enter (make-instance '<my-cube>) scene)
  (enter (make-instance '3d-camera :location (vec 0 0 -3)) scene)
  (enter (make-instance 'render-pass) scene))

(define-action-set in-game)
(define-action move (directional-action in-game))
(define-action hide (in-game))

(setf +app-system+ "trial-demo")

;; 定义一个启动的接口方法，rest代表可变参。
(defun launch (&rest args)
  (let ((*package* #.*package*))
    (load-keymap)
    (setf (active-p (action-set 'in-game)) T)
    (apply #'trial:launch '<main> args)))

(defun launch-bt (&rest args)
  (bt:make-thread 
   (lambda ()
     (apply #'launch args))
   :name "game-thread"))
