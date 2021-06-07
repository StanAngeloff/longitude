Longitude
=========

A collection of Ansible playbooks to provision a (mostly) bootstrapped Ubuntu development desktop.

Usage
-----

**This repository is tailor-made for my needs, be warned:**

```bash
make playbook
```

Goals
-----

- The playbooks **MUST** be idempotent.
- A reasonable attempt to secure most installations **SHOULD** be made (using checksums, signed packages, trusted sources, etc.)
- No important actions **SHOULD** be carried by hand on the target system, any changes SHOULD be captured in this repository/playbooks.

Non-goals
---------

- There shall only be one operating system and version supported. I have zero interest in running anything but Ubuntu LTS at this time.
- Configuring GNOME Shell is done manually (mostly `dconf` settings, e.g., extensions, tweaks, key maps, etc.)
- Dotfiles are managed separately in a [different repository][dotfiles].

### Things to do first…

1. Install Ubuntu Additional Drivers manually and reboot.<br>These will provide a better hardware stack, e.g., graphics, web cam, etc.
2. Install `ubuntu-gnome-desktop` (with `gdm3`) and reboot, switch the default session before logging in.<br>Ubuntu comes with Unity out of the box which is… 💩
3. Remove `unity*` using `apt`.<br>Burn it with 🔥
4. Install security updates `apt update && apt upgrade` (and perhaps `apt dist-upgrade`) followed by a reboot.<br>Be warned, the latter may bump the kernel version and OEM drivers could break as a result, proceed with caution.
5. Mess with `~/.fonts`, Gnome Shell extensions, Gnome Tweak Tool, settings, personalisations, etc.
   * For `rxvt-unicode` to start, the following fonts are required: `Input` [^1], `Noto Mono` [^2], `Symbola`.

#### Further notes

- Install `ubuntu-restricted-extras` to play DRM content on Netflix or watch YouTube/H.264 videos.
- Consider using [Cloudflare's public DNS][1.1.1.1] `1.1.1.1` & `1.0.0.1` on all networks.
- Set up a VPN with a dedicated IP (my preferred supplied is, and has always been, [VPNUK]). The dedicated IP will come in handy when setting up firewalls.
- [Oracle Java] may still be needed to use government e-services. See [Kamenitza Notepad’s blog post](https://web.archive.org/web/20200514123820/https://kamenitza.org/%D0%BD%D0%B0%D0%BF-vs-%D0%BA%D0%B5%D0%BF-%D0%B2-%D0%BB%D0%B8%D0%BD%D1%83%D0%BA%D1%81/) for more details.
   * Don't run `update-alternatives --set`, instead when prompted to run a `.jnlp` file in a browser, copy the URL to the file and use `javaws` from the Oracle package to launch it instead:

      ```bash
      /opt/java/64/jre*/bin/javaws 'https://inetdec.nra.bg/ls/java/stampitls.jnlp'
      ```

### Things to do later…

- **SSH**:
  * Complete the installation by running `google-authenticator` and following the prompts.
- **Parcellite**:
  * To hide the annoying bottom-left corner icon, change the startup script to include `--no-icon`
- **Keybase**:
  * Complete the installation by running `run_keybase` and import public/private keys:
    ```bash
    $ keybase pgp export | gpg --import
    $ keybase pgp export -s | gpg --allow-secret-key-import --import
    ```
- **Firefox**:
  * Run [Cloudflare ESNI Checker][esni] and make sure all checks get a pass ✅
- **Android Studio**:
  * Run Android Studio and complete the installation so the Android SDK is installed & available.
    * When prompted, specify the install path as `/opt/android/sdk` (the directory will be missing, you need to create it first).
- **Indexing Preferences** _(this applies to Ubuntu 16.04 and has since been removed in 18.04)_:
  * See [Disable Tracker](https://web.archive.org/web/20190426161518/https://www.putorius.net/disable-tracker-on-fedora-21-fedora-20.html) for detailed steps. Turning indexing & location options off stops the deamon from consuming too much CPU & memory.

#### Getting Java to work under Pale Moon

You'll need to download and unpack [Oracle Java], then:

```bash
sudo ln -s /opt/java/64/jre1.8.0_251/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins/libnpjp2.so
mkdir -p /usr/local/lib64 && ln -s /usr/lib/x86_64-linux-gnu/libpcsclite.so.1.0.0 /usr/local/lib64/libpcsclite.so
```

You may now make use of **severely** outdated government websites.

#### tessdata_best – Best (most accurate) trained models for Tesseract

```bash
mkdir -p ~/.local/share/tesseract-ocr/4.00/tessdata
cd ~/.local/share/tesseract-ocr/4.00/tessdata
wget https://github.com/tesseract-ocr/tessdata_best/raw/master/bul.traineddata
wget https://github.com/tesseract-ocr/tessdata_best/raw/master/eng.traineddata
wget https://github.com/tesseract-ocr/tessdata_best/raw/master/osd.traineddata
cp -R /usr/share/tesseract-ocr/4.00/tessdata/{configs,tessconfigs,pdf.ttf} /home/stan/.local/share/tesseract-ocr/4.00/tessdata
sudo chown -R stan: /home/stan/.local/share/tesseract-ocr/4.00/tessdata/{configs,tessconfigs,pdf.ttf}
echo 'export TESSDATA_PREFIX="${HOME}/.local/share/tesseract-ocr/4.00/tessdata"' >> ~/.localrc_stan-latitude_gnu_linux
```

##### `ocrmypdf`

```bash
sudo apt install unpaper
pip3.8 install --user ocrmypdf
```

Development
-----------

As the playbooks grows, the system will inevitably accumulate cruft; as a result, installing/compiling a package may succeed with all dependencies having been met. This shall not necessarily be true when starting from scratch. To verify the playbooks' correctness on a vanilla Ubuntu system, use the provided Docker task:

```bash
make docker-playbook
```

This will start a new ephemeral container from a base Ubuntu image and run the playbooks from start to finish. [^3]

Readiness for 20.04
-------------------

As of April 28, 2020 the following is broken:

- No Ansible for `focal`, the PPA has not been updated
- No Git LFS for `focal`, the PPA has not been updated. See https://github.com/git-lfs/git-lfs/pull/4080
- Python2 support has been completely removed (other than compiling from source)
- Docker is not yet available for `focal`, see https://docs.docker.com/engine/install/ubuntu/
- No i3 for `focal`, the PPA has not been updated
- The following packages are no longer available in official repositories: `v4l2ucp` (consider `cheese` instead)
- No PHP packages for `focal`, the PPA has not been updated. See https://github.com/oerdnj/deb.sury.org/issues/1385#issuecomment-618789612
- No PlayOnLinux for `focal`, the PPA has not been updated
- No Tesseract for `focal`, the PPA has not been updated


  [^1]: My Input font preferences are: `Input-BoldItalic_(InputMonoNarrow-BoldItalic).ttf`, `Input-Bold_(InputMonoNarrow-Bold).ttf`, `Input-Italic_(InputMonoNarrow-Italic).ttf` & `Input-Regular_(InputMonoNarrow-Regular).ttf`. These are [freely available][Input Font].
  [^2]: Noto is only needed for extended character sets, `NotoMono-Regular.ttf` should suffice.
  [^3]: […] with the notable exception of Flakpaks which require a reboot.


  [dotfiles]: https://github.com/StanAngeloff/dotfiles
  [Input Font]: http://input.fontbureau.com/download/?customize&fontSelection=fourStyleFamily&regular=InputMonoNarrow-Regular&italic=InputMonoNarrow-Italic&bold=InputMonoNarrow-Bold&boldItalic=InputMonoNarrow-BoldItalic&a=0&g=0&i=serif&l=serifs_round&zero=0&asterisk=0&braces=straight&preset=fira&line-height=1.2&email=
  [1.1.1.1]: https://www.cloudflare.com/learning/dns/what-is-1.1.1.1/
  [VPNUK]: https://www.vpnuk.net/
  [esni]: https://www.cloudflare.com/ssl/encrypted-sni/
  [Oracle Java]: https://www.java.com/en/download/linux_manual.jsp

