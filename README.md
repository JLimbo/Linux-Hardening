# Linux Build 2021
For Building Linux laptops (ubuntu) and hardening to CIS standards - Level 1 
### This is very much a work in progress and should be treated as such. 
## Purpose
The purpose of this project is to aid with the build of ubuntu based machines.
I have tried to make this as user friendly as possible, hence the menu options for example, if you needed to just join the machine to the domain, you have that option.
### Funtions
Join machine to domain) - This will allow a user to join a machine to a windows AD domain.\
Install apps) - This will install basic apps like slack,chrome,zoom.\
Harden Workstation) - This will set all Level 1 CIS standards to a machine and bring it up to 90% compliance.\
Add Sudoers) - Allows a user to add a Sudoer without having to use visudo etc.\
### Operating system support
Supported/Tested:
Ubuntu 20.04LTS
### Maintainers

## How to run
1) Clone this Git repo to a file on the local machine

2) Make shell scripts executable 

3) Launch the run.sh file to bring up the diaglog / option menu
```
option 1) Join machine to Domain
option 2) Install apps
option 3) Harden Workstation
option 4) Add Sudoers
option 5) Quit

```
