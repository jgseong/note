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





<!-- TITLE: MBR 관련 Tips -->
<!-- SUBTITLE: Bootloader,MBR,Disk 관련 설정 -->

# MBR 제거
## Windows
0. HxD 실행 - [HxD 다운로드](https://mh-nexus.de/en/downloads.php?product=HxD)
 0. 관리자 권한으로 실행
0. 디스크 열기 (기타설정 - 디스크 열기)
 0. 읽기 전용으로 읽기 체크박스 해제 - 물리디스크 - 해당 디스크 선택
 0. 디스크 수정에 대한 경고 팝업 - '수락'
0. 블록 선택 (편집 - 블록 선택, Ctrl+E)
 0. '10진수' 선택
 0. 오프셋 시작 0, 길이 446
  * 0x00000000 ~ 0x000001BD (446 Bytes) : MBR 영역
 0. '수락'
0. 선택 채우기 (편집 - 선택 채우기)
 0. 프리셋 삭제 방법 - 제로바이트
 0. '수락'
0. 저장 (파일 - 저장, Ctrl+S)

* 파티션의 부팅 가능 속성 제거
0. '명령 프롬프트' 실행(관리자 권한)
0. diskpart 실행
 * 예시) 디스크 3 의 1번 파티션이 부팅 가능 속성을 제거할 경우.
```powershell
C:\Windows\system32> diskpart

Microsoft DiskPart 버전 10.0.17134.1

Copyright (C) Microsoft Corporation.
컴퓨터:  

DISKPART> list disk

  디스크 ###  상태           크기     사용 가능     Dyn  Gpt
  ----------  -------------  -------  ------------  ---  ---
  디스크 0    온라인        465 GB           0 B
  디스크 1    온라인        119 GB       1024 KB
  디스크 2    온라인         59 GB       2048 KB
  디스크 3    온라인         14 GB           0 B

DISKPART> select disk 3

3 디스크가 선택한 디스크입니다.

DISKPART> list partition

  파티션 ###  종류              크기     오프셋
  ----------  ----------------  -------  -------
  파티션 1    주                   14 GB  1024 KB

DISKPART> select partition 1

1 파티션이 선택한 파티션입니다.

DISKPART> inactive

DiskPart에서 현재 파티션을 비활성을 표시했습니다.

DISKPART> exit

DiskPart 마치는 중...

```

## Linux
* *fdisk* 또는 disk 관련 유틸을 통해 해당 디스크의 장치 파일을 파악
 * Example) /dev/sda
```bash
sudo dd if=/dev/zero of=/dev/sda bs=446 count=1
```

 * MBR 영역을 0으로 채움
 * bs(block size), count : bs 크기를 count 만큼 수행
<!-- TITLE: Mount Errors -->
<!-- SUBTITLE: mount 관련 에러 해결 방법 정리 (For Linux) -->

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
$
```

<!-- TITLE: PPAs -->
<!-- SUBTITLE: Useful PPAs(Personal Package Archives) for APT tools -->

# grub-customizer
* GUI tools for GRUB bootloader
```bash
sudo add-apt-repository ppa:danielrichter2007/grub-customizer 
sudo apt-get update 
sudo apt-get install grub-customizer
```# SSH connection by public key authentication

## Generate key pair by `ssh-keygen` at the client machine
```bash
# refer to `man ssh-keygen`, `ssh-keygen --help`
ssh-keygen -t ed25519 -b 512 -f ~/.ssh/jgseong7@naver.com -C "jgseong7@naver.com"
# -t : public key cipher type
# -b : key length in bit
# -f : output file
# -C : comment for key
#@note: to encrypt key file, input a passphrase. if empty passphrase, then the private key file would be written as cleartext.
#@note: the file names and private key comments can be arbitrary.
```
## Check key pair
```bash
$ ls ~/.ssh/
authorized_keys    jgseong7@naver.com    jgseong7@naver.com.pub

# authorized_keys : a file for public key authentication (may be not existed)
# jgseong7@naver.com : private key generated by previous step.
# jgseong7@naver.com.pub : public key generated by previous step. typically, the file name is followed by the suffix '.pub'.
```
## Copy the public key to server
* do follows at client side.
```bash
# copy a file contents in 'jgseong7@naver.com.pub' and write it to 'authorized_keys' file by ssh and tee
cat ~/.ssh/jgseong7@naver.com.pub | ssh -t ubuntu@172.16.99.17 'tee -a ~/.ssh/authorized_keys'

# in alternative way, copy the public key file and write it to 'authorized_keys' file by scp and ssh
scp ~/.ssh/jgseong7@naver.com.pub ubuntu@172.16.99.17:
ssh ubuntu@172.16.99.17 'cat jgseong7@naver.com.pub >> ~/.ssh/authorized_keys'
ssh ubuntu@172.16.99.17 'rm jgseong7@naver.com.pub'
```
## Check `sshd_config` and restart `sshd`
```bash
# '/etc/ssh/sshd_config' in default on ubuntu 16.04 LTS
cat /etc/ssh/sshd_config | grep -E 'PubkeyAuthentication`|RSAAuthentication'
# check PubkeyAuthentication yes
# check RSAAuthentication yes  # for RSA public key

cat /etc/ssh/sshd_config | grep -E 'AuthorizedKeysFile'
# check 'AuthorizedKeysFile	%h/.ssh/authorized_keys' or '#AuthorizedKeysFile	%h/.ssh/authorized_keys'
# default authorizedKyesFile path is '%h/.ssh/authorized_keys'

# Restart ssh daemons
sudo systemctl restart sshd
```
## Connect SSH by pubkey
```bash
# -i : specify a identity file. (a.k.a. private key)
ssh -i ~/.ssh/jgseong7@naver.com ubuntu@172.16.99.17

# identity file could be specifable in `ssh_config`
# check 'IdentityFile'
cat .ssh/config # refter to `man ssh`
<!-- TITLE: Vim-->
<!-- SUBTITLE: Editor Vim 의 활용/설정 -->

# 자동개행문자 삽입 disable
* 명령 모드에서 
```vim
:set binary
:set noeol
```

* \"는 .vimrc 파일에서 해당 줄(line)이 주석.
* vimrc 설정(`~/.vimrc`)
```vim
" ~/.vimrc
set binary
set noeol
```
<!-- TITLE: Windows -->
<!-- SUBTITLE: Windows 7/10 팁 정리 -->

# Windows 10
## Portable program, 검색 바에 나오게 하기
`C:\ProgramData\Microsoft\Windows\Start Menu\Programs` 에 portable 프로그램의 바로가기 복사.

* 시작 메뉴-프로그램 폴더
  * <kbd>![WinKey][winlogo]</kbd> 키 로 검색 가능

[winlogo]: https://www.tenforums.com/images/smilies/start.png
<!-- TITLE: Wireshark -->
<!-- SUBTITLE: Wireshark 설치/설정/사용 관련 팁 -->

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