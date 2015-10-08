# Install firefox and openit at startup
tce-load -wi firefox-official
mkdir -p /home/gns3/.X.d
echo 'firefox -setDefaultBrowser -private  &' > /home/gns3/.X.d/firefox
