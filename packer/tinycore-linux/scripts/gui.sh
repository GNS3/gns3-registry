set -e
set -x

# Install the GUI
tce-load -wi fltk-1.3
tce-load -wi flwm

# Install X
tce-load -wi Xorg-7.7


# Create xorg-setup-tools
tce-load -wi Xdialog

. /etc/init.d/tc-functions
getMirror
wget -P /tmp $MIRROR/squashfs-tools.tcz
tce-load -i /tmp/squashfs-tools.tcz

sudo mkdir /tmp/xorg-setup-tools
sudo mkdir -p /tmp/xorg-setup-tools/usr/local/bin
sudo mkdir -p /tmp/xorg-setup-tools/usr/local/share/applications
sudo mkdir -p /tmp/xorg-setup-tools/usr/local/share/pixmaps
sudo mkdir -p /tmp/xorg-setup-tools/usr/local/tce.installed

cat > setup_keyboard <<'EOF'
#!/bin/sh
# setup_keyboard changes the keyboard layout

# available keyboards
keyboards='
af "Afghani"
al "Albanian"
et "Amharic"
ara "Arabic"
ma "Arabic (Morocco)"
sy "Arabic (Syria)"
am "Armenian"
az "Azerbaijani"
ml "Bambara"
bd "Bangla"
by "Belarusian"
be "Belgian"
ba "Bosnian"
brai "Braille"
bg "Bulgarian"
mm "Burmese"
cn "Chinese"
hr "Croatian"
cz "Czech"
dk "Danish"
mv "Dhivehi"
nl "Dutch"
bt "Dzongkha"
cm "English (Cameroon)"
gh "English (Ghana)"
ng "English (Nigeria)"
za "English (South Africa)"
gb "English (UK)"
us "English (US)"
epo "Esperanto"
ee "Estonian"
fo "Faroese"
ph "Filipino"
fi "Finnish"
fr "French"
ca "French (Canada)"
cd "French (Democratic Republic of the Congo)"
gn "French (Guinea)"
ge "Georgian"
de "German"
at "German (Austria)"
ch "German (Switzerland)"
gr "Greek"
il "Hebrew"
hu "Hungarian"
is "Icelandic"
in "Indian"
iq "Iraqi"
ie "Irish"
it "Italian"
jp "Japanese"
kz "Kazakh"
kh "Khmer (Cambodia)"
kr "Korean"
kg "Kyrgyz"
la "Lao"
lv "Latvian"
lt "Lithuanian"
mk "Macedonian"
mt "Maltese"
mao "Maori"
md "Moldavian"
mn "Mongolian"
me "Montenegrin"
np "Nepali"
no "Norwegian"
ir "Persian"
pl "Polish"
pt "Portuguese"
br "Portuguese (Brazil)"
ro "Romanian"
ru "Russian"
rs "Serbian"
lk "Sinhala (phonetic)"
sk "Slovak"
si "Slovenian"
es "Spanish"
latam "Spanish (Latin American)"
ke "Swahili (Kenya)"
tz "Swahili (Tanzania)"
se "Swedish"
tw "Taiwanese"
tj "Tajik"
th "Thai"
bw "Tswana"
tr "Turkish"
tm "Turkmen"
ua "Ukrainian"
pk "Urdu (Pakistan)"
uz "Uzbek"
vn "Vietnamese"
sn "Wolof"
'

# get keyboard layout
eval 'Xdialog --menu "Select Keyboard:" 0 0 0' $keyboards 2> /tmp/setup_keyboard_result
status=$?

# set new layout
if [ $status -eq 0 ]; then
	kbd=`cat /tmp/setup_keyboard_result`
	rm -f /tmp/setup_keyboard_result

	sudo sed -i 's/"xkb_layout".*/"xkb_layout" "'"$kbd"'"/' /usr/local/share/X11/xorg.conf.d/98-keyboard.conf
	filetool.sh -b

	Xdialog --yesno "Restart GUI to activate?" 0 0
	if [ $? -eq 0 ]; then
		sh -c 'killall Xorg; sleep 2; startx </dev/tty1 >/dev/tty1 2>&1' &
	fi
else
	cat /tmp/setup_keyboard_result >&2
	rm -f /tmp/setup_keyboard_result
fi

exit $status
EOF
chmod +x setup_keyboard
sudo mv setup_keyboard /tmp/xorg-setup-tools/usr/local/bin/

cat > _setup_keyboard.desktop <<'EOF'
[Desktop Entry]
Name=KeyboardLayout
Exec=setup_keyboard
Type=Application
X-FullPathIcon=/usr/local/share/pixmaps/gnome-accessories-character-map.png
Icon=gnome-accessories-character-map.png
Categories=System;
EOF
sudo mv _setup_keyboard.desktop /tmp/xorg-setup-tools/usr/local/share/applications/

http=http://`getbootparam http`
wget $http/gnome-accessories-character-map.png
sudo mv gnome-accessories-character-map.png /tmp/xorg-setup-tools/usr/local/share/pixmaps/

cat > xorg-setup-tools <<'END_TCE'
mkdir -p /usr/local/share/X11/xorg.conf.d
cat > /usr/local/share/X11/xorg.conf.d/98-keyboard.conf <<'EOF'
Section "InputClass"
    Identifier "keyboard"
    MatchIsKeyboard "on"
    Option "xkb_layout" "us"
    Option "xkb_variant" "nodeadkeys"
EndSection
EOF
cat > /usr/local/share/X11/xorg.conf.d/99-resolution.conf <<'EOF'
Section "Screen"
    Identifier "Screen0"
    DefaultDepth 24
    SubSection "Display"
        Modes "800x600"
    EndSubSection
EndSection
EOF
END_TCE
sudo mv xorg-setup-tools /tmp/xorg-setup-tools/usr/local/tce.installed/

sudo chown -R root:root /tmp/xorg-setup-tools
sudo chmod +x /tmp/xorg-setup-tools/usr/local/tce.installed/xorg-setup-tools
sudo chgrp -R staff /tmp/xorg-setup-tools/usr/local/tce.installed
sudo chmod 775 /tmp/xorg-setup-tools/usr/local/tce.installed

mksquashfs /tmp/xorg-setup-tools xorg-setup-tools.tcz
md5sum xorg-setup-tools.tcz > xorg-setup-tools.tcz.md5.txt
echo -e "Xorg-7.7.tcz\nXdialog.tcz" > xorg-setup-tools.tcz.dep
mv xorg-setup-tools* /mnt/sda1/tce/optional/
echo "xorg-setup-tools.tcz" >> /mnt/sda1/tce/onboot.lst

echo "usr/local/share/X11/xorg.conf.d" >> /opt/.filetool.lst

# Remaining packages
tce-load -wi wbar
tce-load -wi Xprogs
tce-load -wi Xlibs
tce-load -wi aterm
