# post-installation script
set -x

# save changes
rm -f .ash_history
filetool.sh -b sda1

# write 0, not really necessary
#sudo dd if=/dev/zero of=/mnt/sda1/zero ; sudo rm -f /mnt/sda1/zero
