# enc
* 대칭 암호 기능 (Symmetric cipher routines)
* 파일 암호화/복호화
* 기본적으로 stdin/stdout 사용
* `man enc` 참고
```
openssl enc [-e|d] [-p] 'cipher type' -in 'infile' -out 'outfile'
openssl enc [-e|d] [-p] 'cipher type' -in 'infile' -out 'outfile' -k 'passphrase'
openssl enc [-e|d] [-p] 'cipher type' -in 'infile' -out 'outfile' -K 'key(in hex)' -iv 'IV(in hex)' -S 'salt(in hex)'
...
```
**Options**
```bash
-in 'file'     input file
-out <file>    output file
-pass <arg>    pass phrase source
-e             encrypt
-d             decrypt
-a/-base64     base64 encode/decode, depending on encryption flag
-k             passphrase is the next argument
-kfile         passphrase is the first line of the file argument
-md            the next argument is the md to use to create a key
                 from a passphrase.  One of md2, md5, sha or sha1
-S             salt in hex is the next argument
-K/-iv         key/iv in hex is the next argument
-[pP]          print the iv/key (then exit if -P)
-bufsize <n>   buffer size
-nopad         disable standard block padding
-engine e      use engine e, possibly a hardware device.
```

# Encryption
* `-e` 옵션이 기본값, `-e`이 없으면 기본적으로 암호화
* `'cipher type'` 목록은 `man enc` 또는 `openssl enc -help`로 확인 가능
  * `-help`는 잘못된 옵션으로 `openssl` 에서 잘못된 옵션을 실행하면 'usage'가 출력
```
openssl enc [-e] 'cipher type' -in 'infile' -out 'outfile'
openssl enc [-e] 'cipher type' -in 'infile' -out 'outfile' -k 'passphrase'
openssl enc [-e] 'cipher type' -in 'infile' -out 'outfile' -K 'key(in hex)' -iv 'IV(in hex)' -S 'salt(in hex)'
...
```
**exampls**
```bash
# (1) text.txt를 AES-128-CBC 알고리즘으로 암호화한 결과를 text.bin 파일로 출력, key는 NULL 값
openssl enc -e -aes-128-cbc -in text.txt -out text.bin

# (2) key="password1234"로 지정하여 파일 암호화
openssl enc -e -aes-128-cbc -in text.txt -out text.bin -k "password1234"

# (3) key(in hex)='83A0423EB66693020B7A78AA0F08DE6C', IV(in hex)='EBA02B3EF93F14FDEB64E09A815DE8E8',
#       salt(in hex)='07C95502C4D5F3D5' 로 지정하여 파일 암호화
openssl enc -e -aes-128-cbc -in text.txt -out text.bin \ 
-K 83A0423EB66693020B7A78AA0F08DE6C -iv EBA02B3EF93F14FDEB64E09A815DE8E8 -S 07C95502C4D5F3D5
```

# Decryption
* `-d` 옵션을 사용해야 복호화
* 복호화 시에는 암호화에 사용된 알고리즘과 키 값이 동일해야 정상적으로 복호화가 이루어짐
  * IV와 salt 지정해서 암호화한 경우, IV와 salt값도 동일해야 함
  * key 값만 입력한 경우, key값을 기준으로 IV와 salt가 생성되어 암호화되므로, 복호화 시에도 key값만 입력해야 정상적인 복호화 가능
```
openssl enc -d 'cipher type' -in 'infile' -out 'outfile'
openssl enc -d 'cipher type' -in 'infile' -out 'outfile' -k 'passphrase'
openssl enc -d 'cipher type' -in 'infile' -out 'outfile' -K 'key(in hex)' -iv 'IV(in hex)' -S 'salt(in hex)'
...
```
**examples**
```bash
# (1) 암호화된 파일 text.bin을 AES-128-CBC 알고리즘을 이용하여 복호화한 결과를 text.txt 파일로 출력, key는 NULL 값
openssl enc -d -aes-128-cbc -in text.bin -out text.txt

# (2) key="password1234"로 암호화된 파일 복호화
openssl enc -d -aes-128-cbc -in text.bin -out text.txt -k "password1234"

# (3) key(in hex)='83A0423EB66693020B7A78AA0F08DE6C', IV(in hex)='EBA02B3EF93F14FDEB64E09A815DE8E8',
#       salt(in hex)='07C95502C4D5F3D5' 로 지정하여 파일 복호화
openssl enc -d -aes-128-cbc -in text.bin -out text.txt -K 83A0423EB66693020B7A78AA0F08DE6C -iv EBA02B3EF93F14FDEB64E09A815DE8E8 -S 07C95502C4D5F3D5
```
