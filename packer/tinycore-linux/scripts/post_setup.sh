# post-installation script
set -x

# base system modifications
sudo sed -i -e '/^\/opt\/bootlocal/ i' /opt/bootsync.sh
echo -e "\nusername 'gns3', password 'gns3'\nRun filetool.sh -b if you want to save your changes" >> /etc/issue
echo 'etc/issue' >> /opt/.filetool.lst
echo 'etc/shadow' >> /opt/.filetool.lst

# save changes
rm -f .ash_history
filetool.sh -b sda1

# write 0, not really necessary
#sudo dd if=/dev/zero of=/mnt/sda1/zero ; sudo rm -f /mnt/sda1/zero

exit 0
