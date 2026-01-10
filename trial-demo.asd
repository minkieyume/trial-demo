(asdf:defsystem trial-demo
  :components ((:file "package")
               (:file "main"))
  :depends-on (:trial
               :trial-glfw
               :trial-png))
