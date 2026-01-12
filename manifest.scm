;; SPDX-License-Identifier: MIT OR Apache-2.0
;; SPDX-FileCopyrightText: 2024 MinkieYume <minkieyume@yumieko.com>
(use-modules (rustup build toolchain)
	     (guix build utils)
	     (guix packages))

(packages->manifest
 (append (specifications->packages
	  '("coreutils"
	    "gdb"
	    "gcc-toolchain"
	    "binutils"
	    "pkg-config"
	    "nvda"
	    "libglvnd"))))
