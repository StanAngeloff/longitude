# Manual installations

This document contains most all software and tools which I’ve manually installed, but haven't had the time to automate or document yet.

## Brave Browser

```bash
$ sudo apt install apt-transport-https curl
$ mkdir -p /usr/local/share/keyrings/
$ curl -fsSLo /usr/local/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
$ echo "deb [signed-by=/usr/local/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
$ sudo apt update
$ sudo apt install brave-browser
```

## Evince – document viewer for multiple document formats

```bash
$ sudo apt remove 'evince*'
$ flatpak install --user flathub org.gnome.Evince
```

## Perl – `unifont` command

```bash
$ cpan Unicode::Tussle
```

## S.M.A.R.T. (Self-Monitoring, Analysis and Reporting Technology)

`+smartmontools`

This will install Postfix, need to set the Postfix option to 'local' only so it doesn't install it as an "Internet site"

```bash
$ sudo debconf-show postfix
  postfix/not_configured:
  postfix/newaliases: false
  postfix/relayhost:
  postfix/rfc1035_violation: false
  postfix/sqlite_warning:
  postfix/kernel_version_warning:
  postfix/mynetworks: 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
  postfix/compat_conversion_warning: true
  postfix/chattr: false
  postfix/recipient_delim: +
  postfix/bad_recipient_delimiter:
  postfix/destinations: stan-latitude, stan-latitude, localhost.localdomain, localhost
  postfix/mydomain_warning:
  postfix/retry_upgrade_warning:
  postfix/mailbox_limit: 0
  postfix/relay_restrictions_warning:
  postfix/dynamicmaps_conversion_warning:
  postfix/root_address:
  postfix/lmtp_retired_warning: true
  postfix/tlsmgr_upgrade_warning:
* postfix/main_mailer_type: Local only
* postfix/mailname: stan-latitude
  postfix/protocols: all
  postfix/main_cf_conversion_warning: true
  postfix/procmail: false
```

## Viber

```bash
$ sudo apt install libxcb-xinput0
$ wget https://download.cdn.viber.com/desktop/Linux/viber.AppImage
$ sha256sum viber.AppImage
276a8ec3fee332b3f9480c6a2a53828b2518bc5fa54b7c3face8758c43d06327  viber.AppImage
$ chmod +x viber.AppImage
$ mv viber.AppImage /usr/local/bin/viber
$ pushd ~/.local/share/icons && /usr/local/bin/viber --appimage-extract '*.png' && mv squashfs-root/viber.png ./ && rmdir squashfs-root && popd
$ cat <<-EOF > ~/.local/share/applications/viber.desktop
[Desktop Entry]
Name=Viber
Comment=Viber VoIP and messenger
Exec=env QT_SCALE_FACTOR=1.5 /usr/local/bin/viber %u
Icon=viber.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;P2P;
MimeType=x-scheme-handler/viber;
EOF
```

## Language packs for Flatpak

```bash
$ flatpak config --set languages 'en;bg'
$ flatpak config --set --user languages 'en;bg'
```

## Emojis

Download https://github.com/eosrei/twemoji-color-font/releases/download/v13.0.1/TwitterColorEmoji-SVGinOT-Linux-13.0.1.tar.gz

```bash
$ mkdir -p ~/.local/share/fonts
$ cp TwitterColorEmoji-SVGinOT.ttf ~/.local/share/fonts
$ cp fontconfig/46-system-ui.conf ~/.config/fontconfig/conf.d/
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!--
  <match target="font">
    <test name="family" compare="eq"><string>Berkeley Mono</string></test>
    <edit name="family" mode="assign_replace"><string>Berkeley Mono</string></edit>
    <edit name="family" mode="append_last"><string>monospace</string></edit>
  </match>
  -->
  <!--
  <match target="pattern">
    <test qual="any" name="family"><string>monospace</string></test>
    <edit name="family" mode="prepend_first"><string>Berkeley Mono</string></edit>
    <edit name="family" mode="prepend_first"><string>Twitter Color Emoji</string></edit>
  </match>
  -->

  <alias>
    <family>monospace</family>
    <prefer>
      <family>Berkeley Mono</family>
      <family>Twitter Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>ui-monospace</family>
    <prefer>
      <family>Berkeley Mono</family>
      <family>Twitter Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>system-ui</family>
    <prefer>
      <family>Cantarell</family>
      <family>Ubuntu</family>
      <family>Twitter Color Emoji</family>
    </prefer>
  </alias>

  <alias>
    <family>Menlo</family>
    <prefer>
      <family>Berkeley Mono</family>
      <family>Twitter Color Emoji</family>
    </prefer>
  </alias>

  <alias>
    <family>emoji</family>
    <default><family>Twitter Color Emoji</family></default>
  </alias>
  <alias>
    <family>Apple Color Emoji</family>
    <prefer><family>Twitter Color Emoji</family></prefer>
    <default><family>sans-serif</family></default>
  </alias>
  <alias>
    <family>Segoe UI Emoji</family>
    <prefer><family>Twitter Color Emoji</family></prefer>
    <default><family>sans-serif</family></default>
  </alias>
  <alias>
    <family>Noto Color Emoji</family>
    <prefer><family>Twitter Color Emoji</family></prefer>
    <default><family>sans-serif</family></default>
  </alias>
</fontconfig>
```

```bash
$ fc-cache -v
```

Firefox `about:config` (use `fontconfig` emoji)

```yaml
font.name-list.emoji: "emoji"
```
