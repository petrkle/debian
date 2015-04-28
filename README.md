Debian preseed
==============

1. boot [Debian iso](https://www.debian.org/CD/netinst/)

2. Press ESC and type: auto url=http://petr.kle.cz/debian/jessie

3. Wait for installation end

4. Log-in to new machine

5. Copy your config to /srv/salt and /srv/pillar

6. Run salt-call state.highstate
