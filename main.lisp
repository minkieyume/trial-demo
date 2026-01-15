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

(define-shader-entity <player> (animated-sprite transformed-entity)
  ((playback-speed :initform 0.0)))

(defmethod idle ((player <player>) &optional (dir nil))
  (print "stop_walk")
  (format t "WalkSpeed: ~a~%" (playback-speed player))
  (when (or (and dir (typep dir 'symbol))
	    (typep dir 'string)
	    (typep dir 'character))
    (setf (animation player) (symbolicate '-walk- dir)))
  (setf (playback-speed player) 0.0)
  (setf (frame player) 1))

(defmethod walk ((player <player>) &optional (dir nil))
  (print "start_walk")
  (format t "IdleSpeed: ~a~%" (playback-speed player))
  (when (or (and dir (typep dir 'symbol))
	    (typep dir 'string)
	    (typep dir 'character))
    (setf (animation player) (symbolicate '-walk- dir)))
  (setf (playback-speed player) 1.0)
  (setf (playback-direction player) +1))

(defparameter *movingp* nil
  "判断玩家是否正在移动。")

;; (define-handler (<player> tick) (dt)
;;  (let ((movement (directional 'move))
;; 	(dzerop (v= (directional 'move) (vzero (vec4))))
;;        (speed 100.0))
;;    ;; (format t "directional: ~a~%" (directional 'move))
;;    ;; (format t "dzerop: ~a~%" dzerop)
;;    ;; (format t "*movingp*: ~a~%" *movingp*)
;;    (cond ((and *movingp* dzerop) (setf *movingp* nil) (idle <player>))
;; 	 ((and (not *movingp*) (not dzerop)) (setf *movingp* t) (walk <player>)))
;;    (incf (vx (location <player>)) (* dt speed (vx movement)))
;;    (incf (vy (location <player>)) (* dt speed (vy movement))))
;;   (call-next-method tick <player>))

(defmethod handle :after ((ev tick) (player <player>))
  (let ((dt (dt ev))
	(movement (directional 'move))
	(dzerop (v= (directional 'move) (vzero (vec4))))
        (speed 100.0))
    ;; (format t "dzerop: ~a~%" dzerop)
    ;; (format t "*movingp*: ~a~%" *movingp*)
    (cond ((and *movingp* dzerop) (setf *movingp* nil) (idle player))
	  ((and (not *movingp*) (not dzerop)) (setf *movingp* t) (walk player)))
    (incf (vx (location player)) (* dt speed (vx movement)))
    (incf (vy (location player)) (* dt speed (vy movement)))))

;; 加maybe-reload-scene，确保改动后自动热重载
(progn
  (defmethod setup-scene ((main <main>) scene)
    (let ((cam (make-instance 'sidescroll-camera :location (vec -450 -500 0)
						 :zoom 6.0))
	  (cha1 (make-instance '<player> :name :cha1
					 :sprite-data (asset 'character 'cha1))))
      (enter cha1 scene)
      (idle cha1)
      ;; (walk cha1)
      (enter cam scene))
    (enter (make-instance 'render-pass) scene))
  (maybe-reload-scene))
