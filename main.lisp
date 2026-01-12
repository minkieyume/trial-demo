;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minkie Yume <minkieyume@yumieko.com>
(in-package #:org.minkieyume.trial-demo)

(defclass main (trial:main)
  ())

(defmethod setup-scene ((main main) scene)
  (enter (make-instance 'vertex-entity :vertex-array (// 'trial 'unit-cube)) scene)
  (enter (make-instance '3d-camera :location (vec 0 0 -3)) scene)
  (enter (make-instance 'render-pass) scene))

(defun launch (&rest args)
  (apply #'trial:launch 'main args))
