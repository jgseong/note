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