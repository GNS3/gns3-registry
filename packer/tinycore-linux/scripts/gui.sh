# Install the GUI
tce-load -wi fltk-1.3
tce-load -wi flwm

# Install gui
tce-load -wi Xorg-7.7
# set X resolution to 800x600
cat > 99-resolution.conf <<'EOF'
Section "Screen"
    Identifier "Screen0"
    DefaultDepth 24
    SubSection "Display"
        Modes "800x600"
    EndSubSection
EndSection
EOF
sudo mv 99-resolution.conf /usr/local/share/X11/xorg.conf.d/

tce-load -wi wbar
tce-load -wi Xprogs
tce-load -wi Xlibs
tce-load -wi aterm
