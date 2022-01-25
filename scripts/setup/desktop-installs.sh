echo -e "\nInstall desktop packages ..."
sudo aptitude -q=2 update && sudo aptitude -q=2 install \
    openjdk-11-jdk openjdk-11-source openjdk-11-doc visualvm \
    gnome-system-tools gnome-system-monitor gnome-disk-utility \
    grub-customizer glances hfsprogs gvfs-backends gvfs-fuse \
    gufw gparted baobab chromium enpass geany vlc gimp clipit \
      | grep -v 'is already installed at the requested version'

exit 0
