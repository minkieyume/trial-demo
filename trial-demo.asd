;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minkie Yume <minkieyume@yumieko.com>
(asdf:defsystem trial-demo
  :components ((:file "package")
               (:file "main"))
  :depends-on (:trial
               :trial-glfw
               :trial-png))
