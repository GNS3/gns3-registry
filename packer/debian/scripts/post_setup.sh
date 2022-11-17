sudo -- sh -c "
# clear repository
apt-get clean

# clear unused space
echo 'Clearing unused space...'
dd if=/dev/zero bs=1M of=/zero >/dev/null 2>&1; rm -f /zero
sync
"
