(in-package #:org.chiko.trialdemo)

(defclass main (trial:main)
  ())

(defun launch (&rest args)
  (apply #'trial:launch 'main args))
