# Penguin
## Abouts
Penguin is a Command Line Utility Tool to install various Linux distros on Termux, it also provides Desktop Environment installation, Window Manager as well as Command Line.

## Warning
If there is an outdated distro installation, or an outdated gpg key it is purely not this script's fault because, this tool is not completely self-contained, it fetches various Linux Root File System (rootfs) resources from various sources, and be thankful they ever existed.

## Features
* Easy Binary Execution
* Command Line Interactive
* Distro Backup Import
* Easily Install Distro
* Uninstalling The Distro

## Distros
List of supported linux distros.
* Alpine (**Andronix**)
  * CLI Only
  * Desktop Environment
    * XFCE
* Arch Linux (**Andronix**)
  * CLI Only
  * Window Manager
    * i3
    * Openbox
    * Awesome
  * Desktop Environment
    * XFCE
    * LXDE
* Fedora (**Andronix**)
  * CLI Only
  * Window Manager
    * i3
    * Openbox
    * Awesome
  * Desktop Environment
    * XFCE
    * LXQT
    * LXDE
* Kali Linux (**Andronix**)
  * CLI Only
  * Window Manager
    * i3
    * Openbox
    * Awesome
  * Desktop Environment
    * XFCE
    * LXQT
    * LXDE
* Manjaro (**Andronix**)
  * CLI Only
  * Window Manager
    * i3
    * Openbox
    * Awesome
  * Desktop Environment
    * XFCE
    * LXQT
    * LXDE
* Ubuntu (**Andronix**)
  * Versions
    * 22.04
    * 20.04
    * 18.04
  * CLI Only
  * Window Manager
    * i3
    * Openbox
    * Awesome
  * Desktop Environment
    * XFCE
    * LXQT
    * LXDE

## Sources
* **Andronix**<br/>
  [https://github.com/AndronixApp/AndronixOrigin](https://github.com/AndronixApp/AndronixOrigin)
* **AnLinux**<br/>
  [https://github.com/EXALAB/AnLinux-App](https://github.com/EXALAB/AnLinux-App)

## Requires
Before you run this program it would be a good idea if you install the following packages on your Termux, or run `setup.sh`
* curl
* proot
* tar
* wget

## Install
To install Penguin is very easy.
```sh
#!/usr/bin/env bash

# Clone this repository.
git clone https://github.com/hxAri/Penguin

# Change current working directory.
cd Penguin

# Allow executables.
chmod +x *.sh

# Setup penguin.
./setup.sh

# Run the penguin.
./penguin.sh
```

## Example
To run the distro that has been installed is also quite easy.
```sh
#!/usr/bin/env bash

# Fedora CLI Only
fedora cli

# Fedora Window Manager
fedora window
fedora window (i3|openbox|awesome)

# Fedora Desktop Environment
fedora desktop
fedora desktop (xfce|lxqt|lxde)
```

Especially for distributions that have more than one supported version, such as Ubuntu.
```sh
#!/usr/bin/env bash

# Ubuntu CLI Only
ubuntu (22|20|18) cli

# Ubuntu Window Manager
ubuntu (22|20|18) window
ubuntu (22|20|18) window (i3|openbox|awesome)

# Ubuntu Desktop Environment
ubuntu (22|20|18) desktop
ubuntu (22|20|18) desktop (xfce|lxqt|lxde)
```

## Donate
Give spirit to the developer, no matter how many donations given will still be accepted<br/>
[paypal.me/hxAri](https://paypal.me/hxAri)

## Licence
All Penguin source code is licensed under the GNU General Public License v3. Please [see](https://www.gnu.org/licenses) the original document for more details.