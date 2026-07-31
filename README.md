# 86box-guix

This is a
[channel](https://www.gnu.org/software/guix/manual/en/html_node/Channels.html)
for the [Guix](https://guix.gnu.org/) package manager, which might run
as its own operating system or be installed on top of any pre-existing
Linux distribution.

It provides the [86Box](https://86box.net/) emulator in four major
packages available to install and run:

| Package         | Description                                   |
|-----------------|-----------------------------------------------|
| `86box`         | Stable release (v6.0), old dynamic recompiler |
| `86box-ndr`     | Stable release (v6.0), new dynamic recompiler |
| `86box-git`     | Unstable Git revision, old dynamic recompiler |
| `86box-git-ndr` | Unstable Git revision, new dynamic recompiler |

## Installation

This channel can be installed by adding it to your
`$HOME/.config/guix/channels.scm` file:

```scheme
(cons* (channel
        (name '86box)
        (url "https://github.com/chungy/86box-guix")
        (introduction
         (make-channel-introduction
          "4e8c1b4095f3fae1eecdc0fe83aca6575827335f"
          (opengpg-fingerprint
           "6F31 4AF0 EB0B 4F00 129D  FF47 190A 647D 1A0D 738A"))))
       %default-channels)
```

Following this, run `guix pull` and the packages described in the
introduction should be available for installation.
