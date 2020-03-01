<!-- TITLE: Digest -->
<!-- SUBTITLE: A quick summary of digest message by using openssl -->

# Message Digest

## dgst 명령
* 해시(Hash), 메시지 다이제스트(Message Digest)
* HMAC(Hashed MAC)
* 서명(Sign) 및 검증(Verify)
* Default 입/출력은 stdin/stdout (파일 미지정 시), hex 출력 : default
* `dgst` 가 아닌 sha, sha1, ... 등 특정 알고리즘으로 사용 가능, (`man` 참고)
*  지원하는 알고리즘 목록은 `openssl list-message-digest-algorithms`로 확인 가능
* 사용하는 `algorithm`은 `openssl dgst -help` (또는 `man` 참고)
* 사용되는 입력 파일, '`infiles` ...'는 명령문 마지막에 위치해야 함
* `man dgst` 참고
> openssl dgst 'algorithm' [-hex|binary]  [-out 'outfile']  ['infiles ...'] 
> openssl dgst  'algorithm' [-hmac 'key']  [-out 'outfile']  ['infiles ...']
> openssl dgst  'algorithm' [-sign 'key file']  [-out 'outfile']  ['infiles ...']
> openssl dgst  'algorithm' [-verify 'key file']  [-signature 'outfile']  ['infiles ...']
> ...

* Options are
```bash
-c              to output the digest with separating colons
-r              to output the digest in coreutils format
-d              to output debug info
-hex            output as hex dump
-binary         output in binary form
-hmac arg       set the HMAC key to arg
-non-fips-allow allow use of non FIPS digest
-sign   file    sign digest using private key in file
-verify file    verify a signature using public key in file
-prverify file  verify a signature using private key in file
-keyform arg    key file format (PEM or ENGINE)
-out filename   output to filename rather than stdout
-signature file signature to verify
-sigopt nm:v    signature parameter
-hmac key       create hashed MAC with key
-mac algorithm  create MAC (not neccessarily HMAC)
-macopt nm:v    MAC algorithm parameters or key
-engine e       use engine e, possibly a hardware device.
-gost-mac       to use the gost-mac message digest algorithm
-md_gost94      to use the md_gost94 message digest algorithm
-md4            to use the md4 message digest algorithm
-md5            to use the md5 message digest algorithm
-mdc2           to use the mdc2 message digest algorithm
-ripemd160      to use the ripemd160 message digest algorithm
-sha            to use the sha message digest algorithm
-sha1           to use the sha1 message digest algorithm
-sha224         to use the sha224 message digest algorithm
-sha256         to use the sha256 message digest algorithm
-sha384         to use the sha384 message digest algorithm
-sha512         to use the sha512 message digest algorithm
-whirlpool      to use the whirlpool message digest algorithm
```

## 해시(hash)
* 메시지 다이제스트
* 각 파일에 대한 해시 값을 출력, 3개 파일이 입력이면 3개의 해시 값 출력
* `-binary`와 `-hex`는 베타적으로 사용
> openssl dgst 'algorithm' [-hex|binary]  [-out 'outfile']  ['infiles ...']

```bash
# e.g.1
openssl dgst -sha256 -out text.md text.txt

# e.g.2
openssl sha256 -hex text.txt text2.txt text3.txt

# output example for e.g.2
SHA256(text.txt)= a5532c7f2c9a18ae3976a91eddf93faf7f6ed1653fe7bf73daee1eddfc999577
SHA256(text2.txt)= 6be9867ae05e7505fb9bf3d59cfd2af13337fc17915cdeb099286b082f85bb39
SHA256(text3.txt)= a4c6d0d073ff1c3405bcd49d96d8c5dc3f4905402e254ffe725c55f8746e0aec

# e.g.3
openssl dgst -sha256 -binary -out text.md text.txt 

# output example for e.g.3
hexdump text.md
0000000 53a5 7f2c 9a2c ae18 7639 1ea9 f9dd af3f
0000010 6e7f 65d1 e73f 73bf eeda dd1e 99fc 7795
0000020
```

## HMAC
* 키(key) 가 필요
* 'key' 는 hex 값
> openssl dgst 'algorithm' -hmac 'key' [-hex|binary]  [-out 'outfile']  ['infiles ...']
```bash
openssl dgst -sha256 -hmac "hmackey1234" -out text.hmac text.txt
```

## 서명 및 검증
* 키 파일(.pem, .key, ...)이 필요, 키 쌍 또는 개인 키
  * Default key encoding is PEM 
  * [EC key pair 생성](./openssl/cli/keygen#ec-key-pair) 참고
* 바이너리(binary) 로 출력, dafault

### 서명(sign)
> openssl dgst 'algorithm' -sign 'privkey file' [-out 'outfile']  ['infiles ...']

### 검증(verify)
> openssl dgst 'algorithm' -verify 'pubkey file' -signature 'signed file' [-out 'outfile'] 'infiles ...'
> openssl dgst 'algorithm' -prverify 'privkey file' -signature 'signed file' [-out 'outfile'] 'infiles ...'

* Example output for signing message(or file)
```bash
# 서명 예)
openssl dgst -sha224 -binary -out text.md text.txt
openssl dgst -sha224 -sign ecprivkey.pem -out text.sign text.md
```

* Example output for verifying signature
```bash
# 검증 예1) 공개 키로 검증
$ openssl dgst -sha224 -verify ecpubkey.pem -signature text.sign text.md
Verified OK

# 검증 예2) 개인 키로 검증
$ openssl dgst -sha224 -prverify ecprivkey.pem -signature text.sign text.md
Verified OK
```

