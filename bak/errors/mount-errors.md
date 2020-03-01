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

