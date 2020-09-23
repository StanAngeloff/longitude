```sh
sudo apt update
sudo apt upgrade
reboot
```

---

```sh
sudo apt install rpi-update
sudo rpi-update
# (answer Y to all)
reboot
```

---

```sh
sudo apt update
sudo apt install vim
```

---

```sh
vim /etc/dhcpcd.conf
```

```conf
# ANGELOFF network configuration
interface eth0
static ip_address=192.168.1.141/24
static routers=192.168.1.1
static domain_name_servers=87.117.235.130 1.1.1.1 1.0.0.1
```

```sh
reboot
```

---

```sh
vim /etc/fstab
```

```fstab
# <file system>	<mount point>		<type>	<options>															<dump>	<pass>
LABEL=CARPACCIO	/media/carpaccio	ext4	defaults,noatime,nofail,x-systemd.before=nfs-kernel-server.service	0		2

# vim: ts=4 :
```

```sh
reboot
```

---

```sh
cd /tmp
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker `whoami`
reboot
```

---

```sh
sudo chown `whoami`: /media/carpaccio
mkdir -p /media/carpaccio/attic /media/carpaccio/downloads /media/carpaccio/tvshows /media/carpaccio/movies /media/carpaccio/kodi

sudo apt install nfs-kernel-server

vim /etc/exports
```

```exports
"/media/carpaccio/attic" 192.168.1.0/24(ro,insecure,no_subtree_check,nohide,all_squash,anonuid=1000,anongid=1000)
"/media/carpaccio/downloads" 192.168.1.0/24(ro,insecure,no_subtree_check,nohide,all_squash,anonuid=1000,anongid=1000)
"/media/carpaccio/tvshows" 192.168.1.0/24(ro,insecure,no_subtree_check,nohide,all_squash,anonuid=1000,anongid=1000)
"/media/carpaccio/movies" 192.168.1.0/24(ro,insecure,no_subtree_check,nohide,all_squash,anonuid=1000,anongid=1000)
"/media/carpaccio/kodi" 192.168.1.0/24(rw,insecure,sync,no_subtree_check,nohide,all_squash,anonuid=1000,anongid=1000)
```

```sh
reboot
```

---

```sh
sudo apt install -y libffi-dev libssl-dev python3 python3-pip
pip3 install --user docker-compose
exit
```

---

```sh
cd ~/Downloads
git clone https://github.com/Marginal/docker-get_iplayer.git
cd docker-get_iplayer/
vim Dockerfile
```

```diff
-RUN wget -qnd "https://bitbucket.org/shield007/atomicparsley/raw/68337c0c05ec4ba2ad47012303121aaede25e6df/downloads/build_linux_x86_64/AtomicParsley" && \
-    install -m 755 -t /usr/local/bin ./AtomicParsley && \
-    rm ./AtomicParsley
+RUN apk add --update --no-cache wget build-base autoconf automake gcc zlib-dev linux-headers && \
+    cd /tmp && wget https://github.com/wez/atomicparsley/archive/0.9.6.tar.gz && tar xzf 0.9.6.tar.gz && cd atomicparsley-0.9.6 && \
+    wget https://git.alpinelinux.org/aports/plain/testing/atomicparsley/musl-fpos_t.patch && patch -p1 < musl-fpos_t.patch && \
+    ./autogen.sh && ./configure --prefix=/usr/local && make && make install && \
+    apk del build-base autoconf automake gcc zlib-dev linux-headers && apk add --update --no-cache libstdc++
```

```sh
docker build -t marginal/get_iplayer:arm64 .
```