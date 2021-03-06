#!/bin/bash

NAME="server-$RANDOM"
DOMAIN="example.com"

apt-get -y remove nano vim-tiny systemd

apt-get -y install git vim-nox

echo "${NAME}.${DOMAIN}" > /etc/hostname
sed -i "s/^127\.0\.1\.1.*/127.0.1.1 $NAME $NAME.$DOMAIN/" /etc/hosts

sed -i "s/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/" /etc/sudoers

>/etc/motd

update-rc.d -f motd remove

# add stuff to be run once on first boot

cat << END > /etc/rc.local.my
#!/bin/sh -e
# local startup script
exit 0
END

cat << END > /etc/rc.local
#!/bin/sh -e
#
# rc.local
mkdir /home/petr/.ssh

wget -O /home/petr/.ssh/authorized_keys http://petr.kle.cz/debian/authorized_keys

chown -R petr:users /home/petr/.ssh
chmod -R og-rwx /home/petr/.ssh

echo 'deb http://debian.saltstack.com/debian jessie-saltstack main' > /etc/apt/sources.list.d/saltstack.list

wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -

apt-get update

apt-get install -y salt-minion

/etc/init.d/salt-minion stop

update-rc.d -f salt-minion remove

echo 'file_client: local' > /etc/salt/minion

echo 'testmachine: OK' > /etc/salt/grains

mkdir /srv/salt /srv/pillar

chown petr:users /srv/salt /srv/pillar

chmod og-rwx /srv/salt /srv/pillar

cat /etc/rc.local.my > /etc/rc.local
rm /etc/rc.local.my
shutdown -r -t 0
exit 0
END
