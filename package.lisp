;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minkie Yume <minkieyume@yumieko.com>
(defpackage #:org.minkieyume.trial-demo
  (:use #:cl+trial)
  (:shadow #:main #:launch)
  (:local-nicknames
   (#:assets #:org.shirakumo.fraf.trial.assets)
   (#:v #:org.shirakumo.verbose)
   (#:sequences #:org.shirakumo.trivial-extensible-sequences))
  (:export #:<main> #:launch #:launch-bt))
