;;; GNU Guix channel module for 86Box
;;;
;;; This module provides 86Box together with its companion ROMs and
;;; assets sets.

(define-module (86box emulator)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages containers)
  #:use-module (gnu packages electronics)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages image)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mp3)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages xml))

(define (new-dynarec-flag)
  "Return the CMake flag that enables the new dynamic recompiler
on aarch64 and disables it on other architectures (principally x86_64)."
  (if (string-prefix? "aarch64" (or (%current-system) ""))
      "-DNEW_DYNAREC=ON"
      "-DNEW_DYNAREC=OFF"))

(define-public 86box-roms
  (package
   (name "86box-roms")
   (version "6.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/86Box/roms")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1ljri4fxlq8cvjsg582mp5lyl9mnrw2y9r3yxcq9wfms2p5p2c82"))))
   (build-system copy-build-system)
   (arguments
    (list
     #:install-plan
     #~'(("." "share/86Box/roms"
          #:exclude (".git" ".github" "README.md")))))
   (native-search-paths
    (list (search-path-specification
           (variable "XDG_DATA_DIRS")
           (files '("share")))))
   (home-page "https://github.com/86Box/roms")
   (synopsis "ROM set for the 86Box emulator")
   (description
    "Collection of BIOS and firmware dumps required by 86Box.
Install this package alongside @code{86box}; the emulator discovers
the ROMs automatically via the XDG data
directories (@file{$XDG_DATA_DIRS/86Box/roms}).

Note: these files are copyrighted and are provided only for use with
the emulator.  They are intentionally kept as a separate package so
that AppImage and other redistributable binaries of 86Box remain free
of them.")
   (license (license:non-copyleft "https://github.com/86Box/roms"))))

(define-public 86box-roms-git
  (let ((commit "4b9c3e4fed74c106577e9343df677661b955c250")
        (revision "0"))
    (package
     (inherit 86box-roms)
     (name "86box-roms-git")
     (version (git-version "6.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/86Box/roms")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12334pa9ij67vs66lmxhxd7gahrs2rx9svh9v3vjqa9kc2082vx3")))))))

(define-public 86box-assets
  (package
   (name "86box-assets")
   (version "6.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/86Box/assets")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "13qq3qcsw3p7xjkq4b27f6acjdp90rjv012lc70aakq7iyip8ngc"))))
   (build-system copy-build-system)
   (arguments
    (list
     #:install-plan
     #~'(("." "share/86Box/assets"
          #:exclude (".git" ".github" "README.md")))))
   (native-search-paths
    (list (search-path-specification
           (variable "XDG_DATA_DIRS")
           (files '("share")))))
   (home-page "https://github.com/86Box/assets")
   (synopsis "Disk sound assets for 86Box")
   (description
    "Optional disk sound assets used by 86Box.
Includes some floppy and hard disk recordings.  Install alongside
@code{86box}; the emulator looks for them under the XDG data
directories (@file{$XDG_DATA_DIRS/86Box/assets}).")
   (license (license:non-copyleft "https://github.com/86Box/assets"))))

(define-public 86box-assets-git
  (let ((commit "f06840ba5cb7cd3d42f1faa7fe418871a3b3be52")
        (revision "0"))
    (package
     (inherit 86box-assets)
     (name "86box-assets-git")
     (version (git-version "6.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/86Box/assets")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0q1vkr2pf7air5wqzasjkcz40hlj88rlafqr6wvs7662s9ajd3c7")))))))

(define* (make-86box #:key
                     (version "6.0")
                     (commit #f)
                     (revision "0")
                     (new-dynarec? #f)
                     (source-hash #f))
  "Return an 86Box package.  When COMMIT is provided a -git package is built.
NEW-DYNAREC? forces the new dynamic recompiler even on x86_64."
  (package
   (name (string-append "86box"
                        (if commit "-git" "")
                        (if new-dynarec? "-ndr" "")))
   (version (if commit
                (git-version version revision commit)
                version))
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/86Box/86Box")
           (commit (or commit (string-append "v" version)))))
     (file-name (git-file-name name version))
     (sha256
      (base32 (or source-hash
                  "036s6jzsy3xnwbzq65d3a5y920sfpnq8xgj2idnql1p9nbzz4vj2")))))
   (build-system cmake-build-system)
   (arguments
    (list
     #:tests? #f
     #:configure-flags
     #~(list "-DRELEASE=ON"
             "-DUSE_QT6=ON"
             "-DOPENAL=ON"
             "-DFLUIDSYNTH=ON"
             "-DRTMIDI=ON"
             "-DMUNT=ON"
             "-DMUNT_EXTERNAL=ON"
             "-DDISCORD=OFF"  ; disabled because a proprietary SDK is required
             "-DPREFER_STATIC=OFF"
             "-DVNC=OFF"
             (string-append "-DHAS_VDE=" #$vde2 "/lib/libvdeplug.so")
             #$(if new-dynarec?
                   "-DNEW_DYNAREC=ON"
                   (new-dynarec-flag)))
     #:phases
     #~(modify-phases %standard-phases
                      (add-after 'install 'install-desktop-and-icons
                                 (lambda* (#:key inputs outputs #:allow-other-keys)
                                          (let* ((out    (assoc-ref outputs "out"))
                                                 (source (assoc-ref inputs "source"))
                                                 (share  (string-append out "/share"))
                                                 (apps   (string-append share "/applications"))
                                                 (icons  (string-append share "/icons/hicolor"))
                                                 (assets (string-append source "/src/unix/assets")))
                                            (mkdir-p apps)
                                            (copy-file (string-append assets "/net.86box.86Box.desktop")
                                                       (string-append apps "/net.86box.86Box.desktop"))
                                            (for-each
                                             (lambda (size)
                                               (let ((dir (string-append icons "/" size "x" size "/apps")))
                                                 (mkdir-p dir)
                                                 (copy-file
                                                  (string-append assets "/" size "x" size "/net.86box.86Box.png")
                                                  (string-append dir "/net.86box.86Box.png"))))
                                             '("16" "20" "24" "32" "40" "48" "64" "72" "128" "256"))
                                            #t))))))
     (native-inputs
      (list extra-cmake-modules
			pkg-config
			qttools
			vulkan-headers))
     (inputs
      (list
            fluidsynth
            freetype
            gamemode
            libevdev
            libpcap
            libpng
            libserialport
            libslirp
            libsndfile
            libx11
            libxi
            libxkbcommon
            mt32emu
            openal
            qtbase
            qttranslations
            qtwayland
            rtmidi
            sdl2
            vde2
            wayland
            zlib
            `(,zstd "lib")))
     (home-page "https://86box.net/")
     (synopsis "Low level emulator of x86-based PCs.")
     (description
      "86Box is a low level emulator of the IBM PC and compatibles.
It predominantly focuses on hardware built and released in the 20th
century, ranging from the original IBM PC model 5150, to Pentium
II-era hardware.  This package is built with Qt 6 and almost all
optional features enabled.

Discord Rich Presence is excluded because the required library is
proprietary and not available via Guix (nor NonGuix) channels.

The companion packages @code{86box-assets} and @code{86box-roms} are
intentionally not made as dependencies, but installing them is
strongly recommended so that 86Box can function properly.")
     (license license:gpl2+)
     (supported-systems '("x86_64-linux" "aarch64-linux"))))

(define-public 86box
  (make-86box))

(define-public 86box-ndr
  (make-86box #:new-dynarec? #t))

(define-public 86box-git
  (make-86box #:commit "7da585199730e801fe73fae3c42622cbae4ffea3"
              #:revision "0"
              #:source-hash "1kwycfilxdrqmzxlqm8yn11li8ala4m3m2qb2hb91gv08lf87rfl"))

(define-public 86box-git-ndr
  (make-86box #:commit "7da585199730e801fe73fae3c42622cbae4ffea3"
              #:revision "0"
              #:new-dynarec? #t
              #:source-hash "1kwycfilxdrqmzxlqm8yn11li8ala4m3m2qb2hb91gv08lf87rfl"))
