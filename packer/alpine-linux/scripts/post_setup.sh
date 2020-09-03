# restore default sshd configuration
mv /etc/ssh/sshd_config.orig /etc/ssh/sshd_config

# clear cache
rm -rf /var/cache/apk/*

# clear uploads
rm -rf /tmp/uploads

# Write 0
dd if=/dev/zero bs=1M of=/zero ; rm -f /zero
