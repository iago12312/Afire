#! /bin/bash

# Make Instance Ready for Remote Desktop or RDP

b='\033[1m'
r='\E[31m'
g='\E[32m'
c='\E[36m'
endc='\E[0m'
enda='\033[0m'

clear

# Branding

printf """$c$b   
      ██╗     ██╗███╗  ██╗██╗   ██╗██╗  ██╗    ██████╗ ███████╗ ██████╗██╗  ██╗████████╗ █████╗ ██████╗ 
      ██║░░░░░██║████╗░██║██║░░░██║╚██╗██╔╝    ██╔══██╗██╔════╝██╔════╝██║░██╔╝╚══██╔══╝██╔══██╗██╔══██╗
      ██║░░░░░██║██╔██╗██║██║░░░██║░╚███╔╝░    ██║░░██║█████╗░░╚█████╗░█████═╝░░░░██║░░░██║░░██║██████╔╝
      ██║░░░░░██║██║╚████║██║░░░██║░██╔██╗░    ██║░░██║██╔══╝░░░╚═══██╗██╔═██╗░░░░██║░░░██║░░██║██╔═══╝░
      ███████╗██║██║░╚███║╚██████╔╝██╔╝╚██╗    ██████╔╝███████╗██████╔╝██║░╚██╗░░░██║░░░╚█████╔╝██║░░░░
      ╚══════╝╚═╝╚═╝░░╚══╝░╚═════╝░╚═╝░░╚═╝    ╚═════╝░╚══════╝╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═╝░░░
    $r  𝐁𝐲 𝐀𝐩𝐢𝐱 𝐋𝐨𝐢
      © 2021 $c For Accessing Remote Desktop
      Github : https://github.com/apix-loi/          
$endc$enda""";



# Used Two if else type statements, one is simple second is complex. So, don't get confused or fear by seeing complex if else statement '^^.

# Creation of user
printf "\n\nCreating user " >&2
if sudo useradd -m america &> /dev/null
then
  printf "\ruser created $endc$enda\n" >&2
else
  printf "\r$r$b Error Occured $endc$enda\n" >&2
  exit
fi

# Add user to sudo group
sudo adduser america sudo

# Set password of user to 'root'
echo 'america:root' | sudo chpasswd

# Change default shell from sh to bash
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd

# Initialisation of Installer
printf "\n\n$c$b    Loading Installer $endc$enda" >&2
if sudo apt-get update &> /dev/null
then
    printf "\r$g$b    Installer Loaded $endc$enda\n" >&2
else
    printf "\r$r$b    Error Occured $endc$enda\n" >&2
    exit
fi

# Installing Chrome Remote Desktop
printf "\n$g$b    Installing Chrome Remote Desktop $endc$enda" >&2
{
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    chmod +x ./chrome-remote-desktop_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
} &> /dev/null &&
printf "\r$c$b    Chrome Remote Desktop Installed $endc$enda\n" >&2 ||
{ printf "\r$r$b    Error Occured $endc$enda\n" >&2; exit; }



# Install Desktop Environment (XFCE4)
printf "$g$b    Installing Desktop Environment $endc$enda" >&2
{
    sudo DEBIAN_FRONTEND=noninteractive \
        apt install --assume-yes xfce4 desktop-base xfce4-terminal
    sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
    sudo apt remove --assume-yes gnome-terminal  
    sudo apt install --assume-yes xscreensaver
    sudo systemctl disable lightdm.service
} &> /dev/null &&
printf "\r$c$b    Desktop Environment Installed $endc$enda\n" >&2 ||
{ printf "\r$r$b    Error Occured $endc$enda\n" >&2; exit; }

# Adding user to CRP group
sudo adduser america chrome-remote-desktop

# Finishing Work
printf '\nvisit http://remotedesktop.google.com/headless and copy the debian linux command after authentication\n'
read -p "paste command here: " CRP
su - linux -c """$CRP"""

printf "\n$c$b I Hope this code helped you ' $endc$enda\n" >&2
printf "\n$c$b https://remotedesktop.google.com/access/ to access this virtual machine, do not close browser tab to keep colab running ' $endc$enda\n" >&2
printf "\n$g$b Finished Succesfully$endc$enda"
