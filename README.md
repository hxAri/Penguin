
# Penguin

![Penguin · Logo](https://raw.githubusercontent.com/hxAri/hxAri/main/public/images/1701208743;6cxkEyg82i.png)

## Table of Contents
- [Penguin](#penguin)
	- [Table of Contents](#table-of-contents)
	- [Abouts](#abouts)
	- [Features](#features)
		- [Binary Execution](#binary-execution)
		- [Command Line Interface](#command-line-interface)
		- [Linux Distros](#linux-distros)
		- [Desktop Environment](#desktop-environment)
		- [Window manager](#window-manager)
	- [Dependency](#dependency)
	- [Environment](#environment)
	- [Installation](#installation)
	- [Sources](#sources)
	- [Support](#support)
	- [Licence](#licence)

## Abouts
**[Penguin](https://github.com/hxAri/Penguin)** is a Command Line Tool to simplify the installation of Linux Distros to the Android Operating System using Termux as a Shell environment. **[Penguin](https://github.com/hxAri/Penguin)** also supports more than 6 Linux Distros [see](#linux-distros), as well as several Desktop Environments [see](#desktop-environment) and also Window Manager [view](#window-manager).

For problems with graphics rendering you need to know that Termux does not support it however, don't worry about that you can still achieve it with the help of VNC Viewer you can download it via Play Store for free.

## Features
The **[Penguin](https://github.com/hxAri/Penguin)** features

### Binary Execution
Makes it easier for you to run your Linux Distro.

### Command Line Interface
The Command Line is very interesting and also easy to understand (this is just my opinion :D)

### Linux Distros
List of currently available or supported Linux Distros on **[Penguin](https://github.com/hxAri/Penguin)**
* **Alpine**
  * Command Line Interface (CLI)
  * Desktop Environment
    * XFCE
  * Versions
    * 3.10.3
* **Arch Linux**
  * Command Line Interface (CLI)
  * Desktop Environment
    * LXDE
    * XFCE
  * Window Manager
    * Awesome
    * I3
    * Openbox
  * Versions
    * 2021.07.01
* **Debian**
  * Command Line Interface (CLI)
  * Desktop Environment
    * LXDE
    * LXQT
    * XFCE
  * Window Manager
    * Awesome
    * I3
    * Openbox
  * Versions
    * 10.00
* **Fedora**
  * Command Line Interface (CLI)
  * Desktop Environment
    * LXDE
    * LXQT
    * XFCE
  * Window Manager
    * Awesome
    * I3
    * Openbox
  * Versions
    * 33
* **Kali Linux**
  * Command Line Interface (CLI)
  * Desktop Environment
    * LXDE
    * LXQT
    * XFCE
  * Window Manager
    * Awesome
    * I3
    * Openbox
  * Versions
    * 21.2
* **Kali Nethunter**</br>
  Working</br>
* **Manjaro**
  * Command Line Interface (CLI)
  * Desktop Environment
    * LXDE
    * LXQT
    * MATE
    * XFCE
  * Window Manager
    * Awesome
    * I3
    * Openbox
  * Versions
* **Parrot Security OS**</br>
  Working</br>
* **Ubuntu**
  * Command Line Interface (CLI)
  * Desktop Environment
    * LXDE
    * LXQT
    * XFCE
  * Window Manager
    * Awesome
    * I3
    * Openbox
  * Versions
    * 22.04
    * 20.03
    * 18.04
* **Void** </br>
  Working

### Desktop Environment
List of currently available or supported Desktop Environment on **[Penguin](https://github.com/hxAri/Penguin)**
* LXDE
* LXQT
* MATE
* XFCE

### Window manager
List of currently available or supported Linux Window Manager **[Penguin](https://github.com/hxAri/Penguin)**
* Awesome
* I3
* Openbox

## Dependency
Does Penguin require additional dependencies? Yeah, but not much. All the required dependencies are all in a file called dependencies, you can read them with your favorite `cat` in the Terminal Emulator.

## Environment
If Penguin uses the Shell as a programming language, does it require virtualization such as a Virtual Environment in the Python language? It can be yes or no, the environment here is intended to be a different situation because Penguin is typed on a Laptop/PC so the **development** environment means that you will never install it, just create a system file folder like `{distro}-fs`

Meanwhile, the **production** environment is where you actually run it on your Termux and, you will actually install it.

## Installation
How to install Penguin? You don't need to bother with that problem, just clone or download the source code from this repository.
```sh
git clone https://github.com/hxAri/Penguin
```
Let's change give the penguin executable permission
```sh
chmod +x Penguin/penguin
```
Now you can run the Penguin like this
```sh
bash Penguin/penguin
```
Or like this
```sh
. Penguin/penguin
```
Or this
```sh
Penguin/penguin
```
Next, please choose the distro you want to install yourself, and follow the instructions given, Have Nice Live!

## Sources
To source the Root File System for the Penguin Linux Distro, it uses sources from various GitHub repositories, including:
* **[Andronix](https://github.com/AndronixApp/AndronixOrigin)**

## Support
Give spirit to the developer, no matter how many donations given will still be accepted<br/>
[paypal.me/hxAri](https://paypal.me/hxAri)

## Licence
All **[Penguin](https://github.com/hxAri/Penguin)** source code is licensed under the GNU General Public License v3. Please [see](https://www.gnu.org/licenses) the original document for more details.
