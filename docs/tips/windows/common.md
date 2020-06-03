# MBR 제거

1. HxD 실행 - [HxD 다운로드](https://mh-nexus.de/en/downloads.php?product=HxD)
    - 관리자 권한으로 실행
2. 디스크 열기 (기타설정 - 디스크 열기)
    1. 읽기 전용으로 읽기 체크박스 해제 - 물리디스크 - 해당 디스크 선택
    2. 디스크 수정에 대한 경고 팝업 - '수락'
3. 블록 선택 (편집 - 블록 선택, Ctrl+E)
    1. '10진수' 선택
    2. 오프셋 시작 0, 길이 446
        * 0x00000000 ~ 0x000001BD (446 Bytes) : MBR 영역
    3. '수락'
4. 선택 채우기 (편집 - 선택 채우기)
    1. 프리셋 삭제 방법 - 제로바이트
    2. '수락'
5. 저장 (파일 - 저장, Ctrl+S)
6. 파티션의 부팅 가능 속성 제거
    1. '명령 프롬프트' 실행(관리자 권한)
    2. diskpart 실행
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

# Windows 10 Portable program, 검색 바에 나오게 하기
`C:\ProgramData\Microsoft\Windows\Start Menu\Programs` 에 portable 프로그램의 바로가기 복사.

* 시작 메뉴-프로그램 폴더
  * <kbd>![WinKey][winlogo]</kbd> 키 로 검색 가능

[winlogo]: https://www.tenforums.com/images/smilies/start.png


