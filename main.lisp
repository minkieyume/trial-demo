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
  (apply #'trial:launch '<main> args))

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

;; 加maybe-reload-scene，确保改动后自动热重载
(progn
  (defmethod setup-scene ((main <main>) scene)
    (enter (make-instance 'render-pass) scene))
  (maybe-reload-scene))

(defun launch-bt (&rest args)
  (bt:make-thread 
   (lambda ()
     (apply #'launch args))
   :name "game-thread"))
