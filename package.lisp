;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minkie Yume <minkieyume@yumieko.com>
(defpackage #:org.minkieyume.trial-demo
  (:use #:cl+trial)
  (:shadow #:main #:launch #:launch-bt)
  (:local-nicknames
   (#:v #:org.shirakumo.verbose)
   (#:sequences #:org.shirakumo.trivial-extensible-sequences))
  (:export #:main #:launch #:launch-bt))
