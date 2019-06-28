Longitude
=========

A collection of Ansible playbooks to provision a (mostly) bootstrapped Ubuntu development desktop.

Usage
-----

**This repository is tailor-made for my needs, be warned:**

```shell
make playbook
```

Goals
-----

- The playbooks **MUST** be idempotent.
- A reasonable attempt to secure most installations **SHOULD** be made (using checksums, signed packages, trusted sources, etc.)
- No operations **SHOULD** be carried by hand on the target system, any changes SHOULD be captured in this repository/playbooks.

Non-goals
---------

- There shall only be one operating system supported. I have zero interest in running anything but Ubuntu at this time.
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
- Install YubiKey software (this may eventually be rolled into the playbooks).

### Things to do later…

- **Parcellite**:
  * To hide the annoying bottom-left corner icon, change the startup script to include `--no-icon`
- **Keybase**:
  * Complete the installation by running `run_keybase` and import public/private keys:
    ```shell
    $ keybase pgp export | gpg --import
    $ keybase pgp export -s | gpg --allow-secret-key-import --import
    ```
- **Firefox**:
  * Run [Cloudflare ESNI Checker][esni] and make sure all checks get a pass ✅

Development
-----------

As the playbooks grows, the system will inevitably accumulate cruft; as a result, installing/compiling a package may succeed with all dependencies having been met. This shall not necessarily be true when starting from scratch. To verify the playbooks' correctness on a vanilla Ubuntu system, use the provided Docker task:

```shell
make docker-playbook
```

This will start a new ephemeral container from a base Ubuntu image and run the playbooks from start to finish. [^3]


  [^1]: My Input font preferences are: `Input-BoldItalic_(InputMonoNarrow-BoldItalic).ttf`, `Input-Bold_(InputMonoNarrow-Bold).ttf`, `Input-Italic_(InputMonoNarrow-Italic).ttf` & `Input-Regular_(InputMonoNarrow-Regular).ttf`. These are [freely available][Input Font].
  [^2]: Noto is only needed for extended character sets, `NotoMono-Regular.ttf` should suffice.
  [^3]: […] with the notable exception of Flakpaks which require a reboot.


  [dotfiles]: https://github.com/StanAngeloff/dotfiles
  [Input Font]: http://input.fontbureau.com/download/?customize&fontSelection=fourStyleFamily&regular=InputMonoNarrow-Regular&italic=InputMonoNarrow-Italic&bold=InputMonoNarrow-Bold&boldItalic=InputMonoNarrow-BoldItalic&a=0&g=0&i=serif&l=serifs_round&zero=0&asterisk=0&braces=straight&preset=fira&line-height=1.2&email=
  [1.1.1.1]: https://www.cloudflare.com/learning/dns/what-is-1.1.1.1/
  [VPNUK]: https://www.vpnuk.net/
  [esni]: https://www.cloudflare.com/ssl/encrypted-sni/

