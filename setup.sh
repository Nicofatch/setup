sudo apt-get update

#Serveur ssh
sudo apt-get install openssh-server

# XRDP permet de faire du mstsc
sudo apt-get install xrdp
# environnement pour XRDP
sudo apt-get install xfce4
echo xfce4-session >~/.xsession
#sudo service xrdp restart
#replace port=-1 with port=ask-1
#sudo leafpad /etc/xrdp/xrdp.ini
#sudo service xrdp restart.
sudo apt-get install -y git
sudo apt-get install -y curl

#install nvm
curl https://raw.githubusercontent.com/creationix/nvm/v0.13.1/install.sh | bash
nvm install v0.11
nvm use v0.11

#jshint
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get -qq update
sudo apt-get install -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# Install other important files
sudo apt-get install make
sudo apt-get install g++
sudo apt-get install mongodb
sudo apt-get install fontforge

npm install -g grunt-cli
npm install -g grunt
npm install -g mongo

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
git clone https://github.com/Nicofatch/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sf dotfiles/.emacs.d .

#generate ssh key
ssh-keygen -t rsa -C "dev-1@nico.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

#copy and paste to github
less ~/.ssh/id_rsa.pub
#test connection
ssh -T git@github.com

#download spotly
mkdir dev
cd dev/
git clone git@github.com:Nicofatch/Spotly.git
cd Spotly/server
npm install
#seed database
grunt dbseed

cd ../client
npm install
#build client side
grunt build --force

#commande "prod" pour lancer le server en arrière plan
echo "alias prod='nohup node ~/dev/Spotly/server/web.js >> ~/dev/prod.log 2>&1 &'" >> dotfiles/.bashrc
#lancer automatiquement nvm au démarrage
echo "nvm use v0.11" >> dotfiles/.bashrc
