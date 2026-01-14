;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minknie Yume <minkieyume@yumieko.com>
(in-package #:org.minkieyume.trial-demo)

(define-action-set in-game)
(define-action move (directional-action in-game))
(define-action hide (in-game))

(setf +app-system+ "trial-demo")

(defclass <main> (trial:main)
  ()
  (:default-initargs :context '(:vsync T)))

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

;; 渲染线程注入：能安全地将命令塞入下一线程。
(defmacro ! (&body body)
  `(when (and +main+ (scene +main+))
     (with-eval-in-render-loop ()
       ,@body)))

;; 快速定位：node会遍历场景树，并在continer中找到具体的实体。
(defun n (object &optional (container T))
  (node object container))

(define-pool local-asset
  :base #.(asdf:system-relative-pathname :trial-demo "assets/"))

(define-pool character
  :base #.(asdf:system-relative-pathname :trial-demo "assets/external_packs/character-pack-free_version/sprite/"))

(define-asset (character cha1) sprite-data
    #p"free_character_1.json")

;; (defvar cha1-sprite)

;; (define-shader-entity <character1> (sprite-entity listener)
;;   (vertex-array :initform))

;; 根据后缀自动匹配图片导入为assets。
;; (define-assets-from-path (my-pool image "*.png")
;;   (T :min-filter :nearest :mag-filter :nearest)
;;   (logo :min-filter :linear :mag-filter :linear))

;; 加maybe-reload-scene，确保改动后自动热重载
(progn
  (defmethod setup-scene ((main <main>) scene)
    (enter (make-instance 'animated-sprite :sprite-data (asset 'character 'cha1)) scene)
    (let ((cam (make-instance '2d-camera :location (vec 0 0 100))))
      (setf (zoom cam) 0.01)
      (enter cam scene))
    (enter (make-instance 'render-pass) scene))
  (maybe-reload-scene))
