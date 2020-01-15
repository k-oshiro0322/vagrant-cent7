yum -y install wget

# 日本語のロケールを設定
localectl set-locale LANG=ja_JP.UTF-8

# GUI インストールに必要なパッケージをインストール
yum update grub2-common -y
yum install fwupdate-efi -y

# GUIに関連するパッケージをインストール
sudo yum -y groupinstall "Server with GUI"
# 不要なダイアログを表示されないようにする
sudo sh -c "echo 'X-GNOME-Autostart-enabled=false' >> /etc/xdg/autostart/gnome-welcome-tour.desktop"
sudo sh -c "echo 'X-GNOME-Autostart-enabled=false' >> /etc/xdg/autostart/gnome-software-service.desktop"
sudo sh -c "echo 'X-GNOME-Autostart-enabled=false' >> /etc/xdg/autostart/gnome-settings-daemon.desktop"
sudo systemctl disable initial-setup-graphical.service
sudo systemctl disable initial-setup-text.service

sudo systemctl set-default graphical.target

# いったんAutomatic Loginモードに変更
cp /etc/gdm/custom.conf /etc/gdm/custom.conf.org
cat << EOF > /etc/gdm/custom.conf
# GDM configuration storage

[daemon]
AutomaticLogin=vagrant
AutomaticLoginEnable=True
[security]

[xdmcp]

[chooser]

[debug]
# Uncomment the line below to turn on debugging
#Enable=true
EOF
cat << EOF >> /home/vagrant/.bashrc
if [[ -v DISPLAY ]]; then
   setxkbmap jp -model jp106
fi
EOF
service gdm restart
sleep 10
#sudo -u vagrant sh -c "export DISPLAY=:0 && gsettings set org.gnome.desktop.input-sources sources \\"[('ibus', 'kkc'), ('xkb', 'us')]\\""
#sudo -u vagrant sh -c "export DISPLAY=:0 && gsettings set org.gnome.desktop.wm.keybindings switch-input-source \\"['space']\\""
#sudo -u vagrant sh -c "export DISPLAY=:0 && gsettings set org.gnome.settings-daemon.plugins.keyboard active false"

# Automatic Loginモード終了
cp -f /etc/gdm/custom.conf.org /etc/gdm/custom.conf
service gdm restart


# XRDPをインストールして、リモートデスクトップでログインできるようにする。
yum -y install epel-release
rpm -ivh https://archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/x/xorgxrdp-0.2.9-1.el7.x86_64.rpm
yum -y install xrdp tigervnc-server

chcon -t bin_t /usr/sbin/xrdp
chcon -t bin_t /usr/sbin/xrdp-sesman
sed -i "s/max_bpp=32/max_bpp=24/" /etc/xrdp/xrdp.ini
systemctl start xrdp.service
systemctl enable xrdp.service

#VSCodeのインストール
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
yum -y install code

#VSCodeの拡張機能をインストール
code --user-data-dir='/root/.vscode/ext-work' --install-extension MS-vsliveshare.vsliveshare
code --user-data-dir='/root/.vscode/ext-work' --install-extension felixfbecker.php-intellisense
code --user-data-dir='/root/.vscode/ext-work' --install-extension kakumei.php-xdebug

#Dockerのインストール
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
yum -y install python-pip
pip install pip --upgrade
pip install docker-compose

systemctl start docker
systemctl enable docker

#git
yum -y install git

#smartgit
wget https://www.syntevo.com/downloads/smartgit/smartgit-linux-19_1_1.tar.gz
sudo tar -xvf smartgit-linux-19_1_1.tar.gz -C /opt/
/opt/smartgit/bin/add-menuitem.sh


