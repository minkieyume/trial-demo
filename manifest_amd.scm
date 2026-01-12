;; SPDX-License-Identifier: Zlib
;; Copyright © 2026 Minkie Yume <minkieyume@yumieko.com>
(use-modules (guix build utils)
	     (guix packages))

(packages->manifest
 (append (specifications->packages
	  '(
	    "coreutils"
	    "gcc-toolchain"
	    "binutils"
	    "pkg-config"
	    "wayland"
	    "wayland-protocols"
	    "egl-wayland"
	    "libxkbcommon"
	    "alsa-lib"
	    "libgudev"
	    "vulkan-loader"
	    "mesa"
	    ))))
