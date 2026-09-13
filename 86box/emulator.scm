;;; GNU Guix channel module for 86Box
;;;
;;; This module provides 86Box together with its companion ROMs and
;;; assets sets.

(define-module (86box emulator)
  #:use-module (86box libraries)
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
  #:use-module (gnu packages ghostscript)
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

(define %86box-git-date          "20260913013651")
(define %86box-roms-git-date     "20260912175847")
(define %86box-assets-git-date   "20260904181348")
(define %86box-git-commit        "9445945f605ff18accc56f7204dea9ec79e15e65")
(define %86box-roms-git-commit   "db170528d7c1f62c9da326bec296ecc0e2b4705f")
(define %86box-assets-git-commit "6b23b7c03732049e5d979622b49b8d87061d3e32")
(define %86box-git-hash          "0sbwbkn2fva9w4p6pjr3m5g2ngzvha7k478x3b6sqlgqrz04gvcq")
(define %86box-roms-git-hash     "0fydfsb9w842vdjvc31prrax49a56fhygajxqps3z54f0kv8zv0x")
(define %86box-assets-git-hash   "01f1vl1vw8snpbqss6knc9kk4all1g93l86qzq7sh49rmaav8n31")

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
  (let ((commit %86box-roms-git-commit))
    (package
      (inherit 86box-roms)
      (name "86box-roms-git")
      (version (string-append "6.0-" %86box-roms-git-date))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/86Box/roms")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 %86box-roms-git-hash)))))))

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
  (let ((commit %86box-assets-git-commit))
    (package
      (inherit 86box-assets)
      (name "86box-assets-git")
      (version (string-append "6.0-" %86box-assets-git-date))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
                (url "https://github.com/86Box/assets")
                (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 %86box-assets-git-hash)))))))

(define-public 86box
  (package
    (name "86box")
    (version "6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/86Box/86Box")
              (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "036s6jzsy3xnwbzq65d3a5y920sfpnq8xgj2idnql1p9nbzz4vj2"))))
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
              "-DDISCORD=OFF" ; Disabled because a proprietary SDK is required
              "-DPREFER_STATIC=OFF"
              "-DVNC=OFF"
              (string-append "-DHAS_VDE=" #$vde2 "/lib/libvdeplug.so")
              #$@(if (target-x86-64?)
                     '("-DEMU_BUILD=ODR")
                     '()))
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
                           (string-append apps   "/net.86box.86Box.desktop"))
                (for-each
                 (lambda (size)
                   (let ((dir (string-append icons "/" size "x" size "/apps")))
                     (mkdir-p dir)
                     (copy-file
                      (string-append assets "/" size "x" size "/net.86box.86Box.png")
                      (string-append dir "/net.86box.86Box.png"))))
                 '("16" "20" "24" "32" "40" "48" "64" "72" "128" "256"))
                #t)))
          (add-after 'install 'wrap-86box
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (define (lib-dir name)
                (string-append (assoc-ref inputs name) "/lib"))
              (let* ((out (assoc-ref outputs "out"))
                     (paths
                      (filter identity
                              (list (and (assoc-ref inputs "gamemode")
                                         (lib-dir "gamemode"))
                                    (and (assoc-ref inputs "ghostscript")
                                         (lib-dir "ghostscript"))
                                    (and (assoc-ref inputs "libpcap")
                                         (lib-dir "libpcap"))
                                    (and (assoc-ref inputs "vde2")
                                         (lib-dir "vde2"))))))
                (when (pair? paths)
                  (wrap-program (string-append out "/bin/86Box")
                    `("LD_LIBRARY_PATH" ":" prefix ,paths)))
                #t))))))
    (native-inputs
     (list extra-cmake-modules
           pkg-config
           qttools
           vulkan-headers))
    (propagated-inputs
     (list 86box-assets
           86box-roms))
    (inputs
     (list fluidsynth
           freetype
           gamemode
           ghostscript
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
           zlib))
    (home-page "https://86box.net/")
    (synopsis "Low level emulator of x86-based PCs.")
    (description
     "86Box is a low level emulator of the IBM PC and compatibles.
It predominantly focuses on hardware built and released in the 20th century,
ranging from the original IBM PC model 5150, to Pentium II-era hardware.  This
package is built with Qt 6 and almost all optional features enabled.")
    (license license:gpl2+)
    (supported-systems '("x86_64-linux" "aarch64-linux"))))

(define-public 86box-ndr
  (package
    (inherit 86box)
    (name "86box-ndr")
    (arguments
     (substitute-keyword-arguments (package-arguments 86box)
       ((#:configure-flags flags #~'())
        #~(cons "-DNEW_DYNAREC=ON"
                (append
                 (filter (lambda (f)
                           (not (string-prefix? "-DEMU_BUILD=" f)))
                         #$flags)
                 '("-DEMU_BUILD=NDR"))))))
    (supported-systems '("x86_64-linux"))))

(define-public 86box-git
  (package
    (inherit 86box)
    (name "86box-git")
    (version (string-append "6.0-" %86box-git-date))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/86Box/86Box")
              (commit %86box-git-commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         %86box-git-hash))))
    (arguments
     (substitute-keyword-arguments (package-arguments 86box)
       ((#:configure-flags flags #~'())
        #~(append
           (filter (lambda (f)
                     (not (string-prefix? "-DEMU_BUILD=" f)))
                   #$flags)
           (list #$(string-append "-DEMU_BUILD="
                                  (if (target-x86-64?) "ODR " "")
                                  (string-take %86box-git-commit 10)))))
       ((#:phases phases #~%standard-phases)
        #~(modify-phases #$phases
            (add-after 'wrap-86box 'wrap-86box-extra
              (lambda* (#:key inputs outputs #:allow-other-keys)
                (let ((dir (assoc-ref inputs "libaaruformat")))
                  (when dir
                    (wrap-program (string-append (assoc-ref outputs "out")
                                                 "/bin/86Box")
                      `("LD_LIBRARY_PATH" ":" prefix
                        (,(string-append dir "/lib"))))))))))))
    (native-inputs
     (modify-inputs (package-native-inputs 86box)
       (delete "extra-cmake-modules")))
    (propagated-inputs
     (list 86box-assets-git
           86box-roms-git))
    (inputs
     (modify-inputs (package-inputs 86box)
       (delete "sdl2")
       (append libaaruformat
               sdl3
               `(,zstd "lib"))))))

(define-public 86box-git-ndr
  (package
    (inherit 86box-git)
    (name "86box-git-ndr")
    (arguments
     (substitute-keyword-arguments (package-arguments 86box-git)
       ((#:configure-flags flags #~'())
        #~(cons "-DNEW_DYNAREC=ON"
                (append
                 (filter (lambda (f)
                           (not (string-prefix? "-DEMU_BUILD=" f)))
                         #$flags)
                 (list #$(string-append "-DEMU_BUILD=NDR "
                                        (string-take %86box-git-commit 10))))))))
    (supported-systems '("x86_64-linux"))))
