# Tips

## Change the Username

> Test on Ubuntu 16.04

```bash
# sudo passwd root # if any
usermod -l <newname> -d /home/<newname> -m <oldname>
groupmod -n <newgroup> <oldgroup> 
# passwd -l root   # lock root account
```

* example

```bash
# newname, newgroup=jgseong
# oldname, oldgroup=ubuntu
usermod -l jgseong -d /home/jgseong -m ubuntu
groupmod -n jgseong ubuntu
```

## Install system tray icon on elementary OS Juno

**Juno**는 **elementary OS 5.0** 의 GUI. 

기본적으로 system tray icon을 지원하지 않음

> About system tray icons. In [release-juno](https://elementaryos.stackexchange.com/questions/tagged/release-juno), elementaryOS dropped the support of the old Ayatana Indicators   \(refer to [StackExchange](https://elementaryos.stackexchange.com/questions/17452/how-to-display-system-tray-icons-in-elementary-os-juno?rq=1)\)

* Ayanata Indicators 설치 및 설정

```bash
sudo add-apt-repository -y ppa:yunnxx/elementary
sudo apt update
sudo apt install -y indicator-application wingpanel-indicator-ayatana

sudo sed -i 's/OnlyShowIn=.*;/OnlyShowIn=Pantheon;/' /etc/xdg/autostart/indicator-application.desktop
# Alternatively, run 'sudo vim /etc/xdg/autostart/indicator-application.desktop' to edit file

sudo systemctl restart lightdm.service  # Or restart system.
```

## visudo

`sudo` 권한 및 동작 설정

```bash
sudo visudo
```

* `/etc/sudoer` 파일 편집\(문법 검사, 저장 가능\)
  * vim으로 편집 시 sudo EDITOR=vim visudo  \(default: nano\)
  * `/etc/sudoers.d` 에 설정 파일 생성 후,  `includedir /etc/sudoers.d` 사용 가능 

#### Default settings \(on Ubuntu 16.04\)

{% code-tabs %}
{% code-tabs-item title="/etc/sudoer" %}
```bash
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
```
{% endcode-tabs-item %}
{% endcode-tabs %}

#### no-password for user

```text
jgseong   ALL=(ALL:ALL) NOPASSWD:ALL
```

#### no-password for group

```text
%wheel ALL=(ALL) NOPASSWD:ALL
```

* On terminal

```bash
sudo addgroup wheel
sudo addgroup ${USER} wheel
```

## Fix perl warning about the locale failed

간혹 우분투 설치 후 발생하는 에러

```bash
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LC_PAPER = "ko_KR.UTF-8",
	LC_ADDRESS = "ko_KR.UTF-8",
	LC_MONETARY = "ko_KR.UTF-8",
	LC_NUMERIC = "ko_KR.UTF-8",
	LC_TELEPHONE = "ko_KR.UTF-8",
	LC_IDENTIFICATION = "ko_KR.UTF-8",
	LC_MEASUREMENT = "ko_KR.UTF-8",
	LC_TIME = "ko_KR.UTF-8",
	LC_NAME = "ko_KR.UTF-8",
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to a fallback locale ("en_US.UTF-8").
```

```bash
sudo locale-gen
sudo dpkg-reconfigure locales # locale 설정 후 OK, e.g) en_US.UTF-8
Generating locales (this might take a while)...
  en_AG.UTF-8... done
  en_AU.UTF-8... done
  en_BW.UTF-8... done
  en_CA.UTF-8... done
  en_DK.UTF-8... done
  en_GB.UTF-8... done
  en_HK.UTF-8... done
  en_IE.UTF-8... done
  en_IN.UTF-8... done
  en_NG.UTF-8... done
  en_NZ.UTF-8... done
  en_PH.UTF-8... done
  en_SG.UTF-8... done
  en_US.UTF-8... done
  en_ZA.UTF-8... done
  en_ZM.UTF-8... done
  en_ZW.UTF-8... done
  ko_KR.EUC-KR... done
  ko_KR.UTF-8... done
Generation complete.
```

## SSH login with public key

공개키를 이용한 로그인 \(at client side\)

1. SSH 키쌍 생성

   ```bash
   ssh-keygen -c ed25519 -N '' -C '' -f ~/.ssh/id_ed25519 

   # -N : New passphrase, no encryption if empty.
   # -C : Comment, in public key file(.pub)
   # -f : specify a file(output)
   # -c : cipher type, ' rsa | dsa | ecdsa | ed25519 '
   ```

2. SSH 공개 키 복사

   ```bash
   SSH_USER=jgseong
   SSH_REMOTE=192.168.0.2
   cat ~/.ssh/id_ed25519.pub | ssh -t ${SSH_USER}@${SSH_REMOTE} 'tee -a ~/.ssh/authorized_keys'
   ```

3. SSH 접속
   1. `-i` 옵션으로 키 지정

      ```bash
      SSH_USER=jgseong
      SSH_REMOTE=192.168.0.2
      ssh -i ~/.ssh/id_ed25519 ${SSH_USER}@${SSH_REMOTE}
      ```

   2. config 파일 설정 
      1. ~/.ssh/config

         ```bash
         Host 192.168.0.2
         # 2 options to ignore host key check
         #    UserKnownHostsFile /dev/null
         #    StrictHostKeyChecking no
             SendEnv LANG LC_*
             HashKnownHosts yes
             GSSAPIAuthentication yes
             # Append to specify identity file
             IdentityFile ~/.ssh/id_ed25519
         ```

      2. '192.168.0.2' 접속 시,  `-i` 없이 접속

         ```bash
         SSH_USER=jgseong
         SSH_REMOTE=192.168.0.2
         ssh ${SSH_USER}@${SSH_REMOTE}
         ```





