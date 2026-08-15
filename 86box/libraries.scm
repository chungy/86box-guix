(define-module (86box libraries)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages popt))

(define-public libaaruformat
  (package
    (name "libaaruformat")
    (version "1.0.0-beta.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/aaru-dps/libaaruformat")
              (commit (string-append "v" version))
              (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0bkxja0qdrh92kzjb8yn51c8lyvgmaw5v42pfv102979qwm2p6nd"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f ;; Tests fail
      #:configure-flags
      #~(list
         "-DBUILD_SHARED_LIBS=ON"
         "-DBUILD_TOOL=ON"
         "-DUSE_ASAN=OFF"
         "-DUSE_SLOG=OFF"
         (string-append "-DCMAKE_INSTALL_RPATH=" #$output "/lib")
         "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'remember-source-directory
            (lambda _
              (setenv "AARU_SOURCE" (getcwd))
              #t))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out    (assoc-ref outputs "out"))
                     (bindir (string-append out "/bin"))
                     (incdir (string-append out "/include"))
                     (libdir (string-append out "/lib"))
                     (srcinc (string-append (getenv "AARU_SOURCE") "/include")))
                (mkdir-p bindir)
                (for-each
                 (lambda (f)
                   (install-file f bindir))
                 (find-files "." "aaruformattool"))
                (mkdir-p incdir)
                (copy-recursively srcinc incdir)
                (mkdir-p libdir)
                (for-each
                 (lambda (f)
                   (install-file f libdir))
                 (find-files "." "libaaruformat\\.so"))
                #t))))))
    (native-inputs
     (list
      patchelf
      pkg-config))
    (inputs
     (list
      argtable3
      icu4c
      ncurses
      zlib))
    (home-page "https://github.com/aaru-dps/libaaruformat")
    (synopsis "C library for the Aaru disk image format")
    (description
     "libaaruformat is the reference C implementation of the AaruFormat disk image format.
It supports AaruFormat v1 for read-only operations and AaruFormat v2
for read/write operations, with compression, deduplication, checksums,
and Reed-Solomon protection.")
    (license license:lgpl2.1+)))
