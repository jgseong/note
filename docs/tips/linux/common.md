# Change the Username

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

# visudo

`sudo` 권한 및 동작 설정

```bash
sudo visudo
```

* `/etc/sudoer` 파일 편집\(문법 검사, 저장 가능\)
  * vim으로 편집 시 sudo EDITOR=vim visudo  \(default: nano\)
  * `/etc/sudoers.d` 에 설정 파일 생성 후,  `includedir /etc/sudoers.d` 사용 가능 

* Default settings \(on Ubuntu 16.04\)
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
**no-password for user**
```
jgseong   ALL=(ALL:ALL) NOPASSWD:ALL
```
**no-password for group**
```
%wheel ALL=(ALL) NOPASSWD:ALL
```
* create wheel group / join user to wheel group
```bash
sudo addgroup wheel
sudo addgroup ${USER} wheel
```


# Fix perl warning about the locale failed

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


# grub-customizer
* GUI tools for GRUB bootloader
```bash
sudo add-apt-repository ppa:danielrichter2007/grub-customizer 
sudo apt-get update 
sudo apt-get install grub-customizer
```


# Remove MBR area
* *fdisk* 또는 disk 관련 유틸(lsblk, sfdisk, parted, ...)을 통해 해당 디스크의 장치 파일을 파악
```bash
# assume disk is /dev/sda
sudo dd if=/dev/zero of=/dev/sda bs=446 count=1
```
* MBR 영역을 0으로 채움
* bs(block size), count : bs 크기를 count 만큼 수행


# NTFS mount error

* `the disk contains an unclean file system (0 0) ...` 하면서, 어쩌고 저쩌고 에러 날때
* 듀얼 부팅 또는 MBR을 잘못 건들였을 때, 나타나는 증상 
* 내 환경 : Grub2(sdb1) - Windows10(sdb2), Linux Mint 18.3(sdc*), NTFS-HDD(sda1)
* 보통 ntfsfix로 해결 가능
    * ntfs HDD dev 파일이 /dev/sda1인 경우
```bash
sudo ntfsfix /dev/sda1
```
* output example
```bash
$ sudo ntfsfix /dev/sda1 
Mounting volume... The disk contains an unclean file system (0, 0).
Metadata kept in Windows cache, refused to mount.
FAILED
Attempting to correct errors... 
Processing $MFT and $MFTMirr...
Reading $MFT... OK
Reading $MFTMirr... OK
Comparing $MFTMirr to $MFT... OK
Processing of $MFT and $MFTMirr completed successfully.
Setting required flags on partition... OK
Going to empty the journal ($LogFile)... OK
Checking the alternate boot sector... OK
NTFS volume version is 3.1.
NTFS partition /dev/sda1 was processed successfully.

```


# SSH connection by public key authentication
공개키를 이용한 로그인 

* ssh 서버 설정 확인
```sh
# '/etc/ssh/sshd_config' in default on ubuntu 16.04 LTS
cat /etc/ssh/sshd_config | grep -E 'PubkeyAuthentication`|RSAAuthentication'
# check PubkeyAuthentication yes
# check RSAAuthentication yes  # for RSA public key

cat /etc/ssh/sshd_config | grep -E 'AuthorizedKeysFile'
# check 'AuthorizedKeysFile	%h/.ssh/authorized_keys' or '#AuthorizedKeysFile	%h/.ssh/authorized_keys'
# default authorizedKyesFile path is '%h/.ssh/authorized_keys'
# %h is user's home directory

# Restart ssh daemons
sudo systemctl restart sshd
```
* SSH 키쌍 생성
```sh
ssh-keygen -c ed25519 -N '' -C '' -f ~/.ssh/id_ed25519 

# -N : New passphrase, no encryption if empty.
# -C : Comment, in public key file(.pub)
# -f : specify a file(output)
# -c : cipher type, ' rsa | dsa | ecdsa | ed25519 '
```
* SSH 공개 키 복사
```
SSH_USER=jgseong
SSH_REMOTE=192.168.0.2
cat ~/.ssh/id_ed25519.pub | ssh -t ${SSH_USER}@${SSH_REMOTE} 'tee -a ~/.ssh/authorized_keys'
```
* SSH 접속 with `-i` option
```
# use with -i option to specify key file.
SSH_USER=jgseong
SSH_REMOTE=192.168.0.2
ssh -i ~/.ssh/id_ed25519 ${SSH_USER}@${SSH_REMOTE}
```
* SSH 접속 with `~/.ssh/config`
```
# use without -i option to specify key file.
# edit ~/.ssh/config

Host 192.168.0.2
# two options to ignore host key check
#    UserKnownHostsFile /dev/null
#    StrictHostKeyChecking no
   SendEnv LANG LC_*
   HashKnownHosts yes
   GSSAPIAuthentication yes
   # Append to specify identity file
   IdentityFile ~/.ssh/id_ed25519
```
```sh
SSH_USER=jgseong
SSH_REMOTE=192.168.0.2
ssh ${SSH_USER}@${SSH_REMOTE}
```

# 사용자 계정으로 wireshark 실행
1. `dumpcap` 파일의 소유 그룹과 그룹 실행 권한 확인
  * `which dumpcap`으로 경로 확인 가능
2. 'wireshark' 그룹에 현재 사용자 추가
```bash
sudo usermod -a -G wireshark $USER
```
  * output example
```bash
# dumpcap 파일의 소유 그룹과 그룹 실행 권한 확인
ls /usr/bin/dumpcap  -l   # or 'ls -l $(which dumpcap)'
-rwxr-xr-- 1 root wireshark 96464 Jun  1  2017 /usr/bin/dumpcap* 
sudo usermod -a -G wireshark $USER 
reboot # or logout/re-login
```

