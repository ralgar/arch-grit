# Arch-GRIT

[![Latest Tag](https://img.shields.io/github/v/tag/ralgar/arch-grit?style=for-the-badge&logo=semver&logoColor=white)](https://github.com/ralgar/arch-grit/tags)
[![Pipeline Status](https://img.shields.io/github/workflow/status/ralgar/arch-grit/Build%20Arch-GRIT?label=Pipeline&logo=github&style=for-the-badge)](https://github.com/ralgar/arch-grit/actions)
[![Software License](https://img.shields.io/badge/License-GPL--2.0-orange?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-2.0.html)
[![GitHub Stars](https://img.shields.io/github/stars/ralgar/arch-grit?color=gold&label=Stars&logo=github&style=for-the-badge)](https://github.com/ralgar/arch-grit)

## Overview
Arch Graphical Recovery and Installation Tool (Arch-GRIT) - a live, graphical
 Arch Linux ISO, with my custom installer written in Bash.

This is a project with only one goal - easy redeployment of my personal Arch
 installation. The system is highly opinionated, and primarily designed for
 power users such as sysadmins and developers.

![Project Screenshot](images/screenshot.png)

### Features

- [x] **Live system**
  - [x] Full graphical environment
  - [x] High compatibility
  - [x] Wide variety of useful tools
- [x] **TUI installer**
  - [x] Takes user input
  - [x] Handles a variety of hardware configurations
  - [x] Delivers a fully functional system
- [x] **Installed system**
  - [x] Uses ZFS for data integrity
  - [x] Dataset encryption by default
  - [x] Uses smartd for disk health monitoring
  - [x] Firewalld enabled by default
  - [x] Follows principle of least privilege

## Getting Started

There are two ways to use this project:
1. Build it from source with the [instructions below](#prerequisites), before
   continuing on to [Usage](#usage)
2. Download the [latest pre-built ISO](https://github.com/ralgar/arch-grit/releases)
   and write it to a USB drive, following the instructions in [Usage](#usage)

### Building

#### Prerequisites

To build the ISO, you will need an existing Arch Linux system with the
 `archiso` package installed. A containerized build system is also being
 developed for a future release.

1. Clone the repo:
   ```sh
   git clone https://github.com/ralgar/arch-grit.git
   ```
2. Navigate into the repo:
   ```sh
   cd arch-grit
   ```
3. Start the build using the included `Makefile`.
   ```sh
   sudo make
   ```

## Usage

To write the ISO to a USB drive, follow the instructions provided by the [Arch Linux Project](https://wiki.archlinux.org/title/USB_flash_installation_medium).

Boot from the live USB. The bootloader will present you with two options. If your system has sufficient RAM (at least 4GB), then I recommend choosing the `Copy to RAM` option for best performance. Otherwise, choose the default option.

When the live system has finished booting, it will automatically log in and launch a terminal window. The live environment is nearly identical to the final product, so this is a good opportunity to test it out before committing to a permanent installation.<br>

You can use the `arch-grit` command to accomplish several tasks, most notably installing a new system. It also provides some helper functions for system recovery purposes, such as decrypting and mounting an existing Arch-GRIT system.<br>
To learn more about the command run `arch-grit --help`.<br>
Note: Root privileges are required to run `arch-grit`, you can elevate the default user's privilege using `sudo` and the password `archlinux`

## License

Distributed under the GNU GPLv2 License. See `LICENSE` for more info.

## Acknowledgements

Some of the following software is showcased in this project:
* [AwesomeWM](https://github.com/awesomeWM/awesome)
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
