#!/bin/sh

V=0.30.0
FN=frp_${V}_linux_amd64.tar.gz
if [ ! -e $FN ]; then
wget https://github.com/fatedier/frp/releases/download/v$V/$FN
tar -xzf $FN
fi
FN_=${FN%.*}
cd ${FN_%.*}
PWD=$(pwd)

if [ "$1" = "" ]; then
echo 'args not provided!'
exit 1
fi

if [ "$1" = 'client' ];
then

cat > frpc.ini <<EOF
[common]
server_port = 7000
server_addr = SERVER_ADDR

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = REMOTE_PORT
EOF
cmd="${PWD}/frpc -c ${PWD}/frpc.ini \&"
fi

if [ "$1" = 'server' ];
then
cat > frps.ini <<EOF
[common]
bind_port = 7000
EOF
cmd="${PWD}/frps -c ${PWD}/frps.ini \&"
# ./frps -c ./frps.ini
fi
sudo sed -i "s#exit 0\$#${cmd} \nexit 0#" /etc/rc.local
echo 'auto-run on boot!'