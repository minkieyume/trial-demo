;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minkie Yume <minkieyume@yumieko.com>
(in-package #:org.chiko.trialdemo)

(defclass main (trial:main)
  ())

(defun launch (&rest args)
  (apply #'trial:launch 'main args))
