#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'

LAST_UPDATED='4/8/18'
AUTHOR='powerslacker'
SOURCE='www.github.com/powerslacker/'

CLOUD_SDK_VERSION='196.0.0'
CLOUD_SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz"
GOPATH='gocode'
BASH_PROFILE='~/.profile'


# checks install for success / failure -- first param is program label (i.e. git) second param is cmd to check
# for working install (i.e. git --version)
function checkInstall() {
    if $2 &> /dev/null; then
        echo -e ${GREEN}[$1 succesfully installed]${NC}
    else
        echo -e ${RED}[$1 failed to install]${NC}
        exit 1
    fi
}

# intro and user confirmation
echo "
 ██████╗  ██████╗      ██████╗ ██╗██████╗ ███████╗
██╔════╝ ██╔═══██╗    ██╔════╝ ██║██╔══██╗██╔════╝
██║  ███╗██║   ██║    ██║  ███╗██║██████╔╝███████╗
██║   ██║██║   ██║    ██║   ██║██║██╔══██╗╚════██║
╚██████╔╝╚██████╔╝    ╚██████╔╝██║██████╔╝███████║
 ╚═════╝  ╚═════╝      ╚═════╝ ╚═╝╚═════╝ ╚══════╝
---------------------------------------------------------------------------
Author: ${AUTHOR}
Source: ${SOURCE}
Last Updated: ${LAST_UPDATED}"                                  

sleep 1s
echo -e "
A shell script for quick installation of git, Golang, and Google Cloud SDK
on fresh installs of Ubuntu and Mint GNU/Linux distributions. 

This script will:
    1) install git from git-core ppa
    2) install golang from the default repositories
    3) add a folder '${GOPATH}' to the home directory
    4) add '${GOPATH}' to the bash profile via ${BASH_PROFILE} 
    5) download and install google cloud sdk 
       v${CLOUD_SDK_VERSION} for 64-bit architecture

The settings for the google cloud sdk download url, GOPATH, and bash profile path 
can be modified by editing the variables set at the top of this script. Install
prompts run normally and may require user input.

If these settings are correct and you wish to continue, type ${GREEN}'GIBS'${NC} then
press ${GREEN}[ENTER]${NC}"

read input

if [[ $input = "GIBS" ]]; then
    echo -e ${GREEN}[starting install]${NC}
    sleep 1
else
    echo -e ${RED}[exiting script]${NC}
    exit 1
fi
# install git
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git
# check git install succeeded
checkInstall git 'git --version'
# install go
sudo apt install golang-go
# check if go install succeeded
checkInstall golang 'go version'
# make gopath
mkdir ~/gocode
# add gopath to bash profile
echo 'export GOPATH=~/gocode' >>${BASH_PROFILE}
# reload bash profile
source ${BASH_PROFILE}
# download and extract google cloud sdk -- be sure to check  https://cloud.google.com/sdk/docs/ for updated versions!
curl -L ${CLOUDSDK} | tar xz
# run the gcloud installer
cd google-cloud-sdk 
./install.sh
# reload bash profile
source ${BASH_PROFILE}
# check if gcloud succesfully installed
checkInstall gcloud 'gcloud version'