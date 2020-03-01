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

<!-- TITLE: Enctypt/Decrypt -->
<!-- SUBTITLE: A quick summary of enc commands of openssl -->

# enc

## About enc
* 대칭 암호 기능 (Symmetric cipher routines)
* 파일 암호화/복호화
* 기본적으로 stdin/stdout 사용
* `man enc` 참고
> openssl enc [-e|d] [-p] 'cipher type' -in 'infile' -out 'outfile'
> openssl enc [-e|d] [-p] 'cipher type' -in 'infile' -out 'outfile' -k 'passphrase'
> openssl enc [-e|d] [-p] 'cipher type' -in 'infile' -out 'outfile' -K 'key(in hex)' -iv 'IV(in hex)' -S 'salt(in hex)'
> ...
* Options are
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

## 암호화
* `-e` 옵션이 기본값, `-e`이 없으면 기본적으로 암호화
* `'cipher type'` 목록은 `man enc` 또는 `openssl enc -help`로 확인 가능
  * `-help`는 잘못된 옵션으로 `openssl` 에서 잘못된 옵션을 실행하면 'usage'가 출력
> openssl enc [-e] 'cipher type' -in 'infile' -out 'outfile'
> openssl enc [-e] 'cipher type' -in 'infile' -out 'outfile' -k 'passphrase'
> openssl enc [-e] 'cipher type' -in 'infile' -out 'outfile' -K 'key(in hex)' -iv 'IV(in hex)' -S 'salt(in hex)'
> ...
* e.g.
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

## 복호화
* `-d` 옵션을 사용해야 복호화
* 복호화 시에는 암호화에 사용된 알고리즘과 키 값이 동일해야 정상적으로 복호화가 이루어짐
  * IV와 salt 지정해서 암호화한 경우, IV와 salt값도 동일해야 함
  * key 값만 입력한 경우, key값을 기준으로 IV와 salt가 생성되어 암호화되므로, 복호화 시에도 key값만 입력해야 정상적인 복호화 가능
> openssl enc -d 'cipher type' -in 'infile' -out 'outfile'
> openssl enc -d 'cipher type' -in 'infile' -out 'outfile' -k 'passphrase'
> openssl enc -d 'cipher type' -in 'infile' -out 'outfile' -K 'key(in hex)' -iv 'IV(in hex)' -S 'salt(in hex)'
> ...
* e.g.
```bash
# (1) 암호화된 파일 text.bin을 AES-128-CBC 알고리즘을 이용하여 복호화한 결과를 text.txt 파일로 출력, key는 NULL 값
openssl enc -d -aes-128-cbc -in text.bin -out text.txt

# (2) key="password1234"로 암호화된 파일 복호화
openssl enc -d -aes-128-cbc -in text.bin -out text.txt -k "password1234"

# (3) key(in hex)='83A0423EB66693020B7A78AA0F08DE6C', IV(in hex)='EBA02B3EF93F14FDEB64E09A815DE8E8',
#       salt(in hex)='07C95502C4D5F3D5' 로 지정하여 파일 복호화
openssl enc -d -aes-128-cbc -in text.bin -out text.txt -K 83A0423EB66693020B7A78AA0F08DE6C -iv EBA02B3EF93F14FDEB64E09A815DE8E8 -S 07C95502C4D5F3D5
```
<!-- TITLE: Generate Key Pair -->
<!-- SUBTITLE: How to generate the key pair by using OpenSSL -->

# EC key pair
* EC(Elliptic Curve) 알고리즘을 사용한 키 생성
* Asymmetric key 알고리즘은 private key를 생성한 후, private key에 대응하는 public key를 생성

## Private key 생성
* default로 PEM(Privacy-Enhanced Mail) 포맷으로 생성
> openssl ecparam -genkey -name 'curve name' -out 'outfile'
* Example
```bash
openssl ecparam -genkey -name prime256v1 -out ecprivkey.pem
```
* Example - Encrypt private key 
```bash
openssl ec -aes-128-cbc -in ecprivkey.pem -out new_ecprivkey.pem
# man enc 참고
```

## Public key 생성
> openssl ec -in 'infile' -pubout -out 'outfile'
* `'infile'` : private key 파일
* `-pubout` : `'infile'`에 대응하는 공개 키 출력
* Example
```bash
openssl ec -in ecprivkey.pem -pubout -out ecpubkey.pem
```

## ecparam 옵션
* `man ecparam` 참고
```bash
ecparam [options] <infile> outfile
where options are
 -inform arg       input format - default PEM (DER or PEM)
 -outform arg      output format - default PEM
 -in  arg          input file  - default stdin
 -out arg          output file - default stdout
 -noout            do not print the ec parameter
 -text             print the ec parameters in text form
 -check            validate the ec parameters
 -C                print a 'C' function creating the parameters
 -name arg         use the ec parameters with 'short name' name
 -list_curves      prints a list of all currently available curve 'short names'
 -conv_form arg    specifies the point conversion form 
                   possible values: compressed
                                    uncompressed (default)
                                    hybrid
 -param_enc arg    specifies the way the ec parameters are encoded
                   in the asn1 der encoding
                   possible values: named_curve (default)
                                    explicit
 -no_seed          if 'explicit' parameters are chosen do not use the seed
 -genkey           generate ec key
 -rand file        files to use for random number input
 -engine e         use engine e, possibly a hardware device
```

## ec 옵션
* `man ec` 참고
```bash
ec [options] <infile> outfile
where options are
 -inform arg     input format - DER or PEM
 -outform arg    output format - DER or PEM
 -in arg         input file
 -passin arg     input file pass phrase source
 -out arg        output file
 -passout arg    output file pass phrase source
 -engine e       use engine e, possibly a hardware device.
 -des            encrypt PEM output, instead of 'des' every other 
                 cipher supported by OpenSSL can be used
 -text           print the key
 -noout          dont print key out
 -param_out      print the elliptic curve parameters
 -conv_form arg  specifies the point conversion form 
                 possible values: compressed
                                  uncompressed (default)
                                   hybrid
 -param_enc arg  specifies the way the ec parameters are encoded
                 in the asn1 der encoding
                 possible values: named_curve (default)
                                  explicit
```
<!-- TITLE: PKI -->
<!-- SUBTITLE: A quick summary of PKI by using openssl -->

# Settings for **Root CA**
* openssl을 이용하여 인증서 발급을 위해 PKI 인프라 구성
* root CA 에서 사용하는 기본 디렉터리 및 파일 준비.
* Example
```bash
sudo -s
mkdir -p /opt/pki/root
cd /opt/pki/root
export ROOTCADIR=`pwd`
mkdir certs crl newcerts private
echo 1000 > serial ; touch index.txt 
cp /etc/pki/tls/openssl.cnf $ROOTCADIR/openssl.cnf
export OPENSSL_CONF=$ROOTCADIR/openssl.cnf
```

* Check root ca for files
```bash
$ ls /opt/pki/root
drwx------. 2 root  4096 Sep 20 21:23 private
drwxr-xr-x. 2 root  4096 Sep 20 21:23 newcerts
drwxr-xr-x. 2 root  4096 Sep 20 21:23 crl
drwxr-xr-x. 2 root  4096 Sep 20 21:23 certs
-rw-r--r--. 1 root     5 Sep 20 21:24 serial
-rw-r--r--. 1 root     0 Sep 20 21:24 index.txt
-rw-r--r--. 1 root 10923 Sep 20 21:24 openssl.cnf
```

* `openssl.cnf` 내용
```
...
####################################################################
[ ca ]
default_ca      = CA_default            # 기본 CA 섹션

####################################################################
[ CA_default ]                          # default_ca 의 지정한 섹션 시작 부분 

dir             = /opt/pki/root         # Where everything is kept
                                        # 위에서 만든 경로로 수정
certs           = $dir/certs            # Where the issued certs are kept
crl_dir         = $dir/crl              # Where the issued crl are kept
database        = $dir/index.txt        # database index file.
#unique_subject = no                    # Set to 'no' to allow creation of
                                        # several ctificates with same subject.
new_certs_dir   = $dir/newcerts         # default place for new certs.

certificate     = $dir/cacert.pem       # The CA certificate
serial          = $dir/serial           # The current serial number
crlnumber       = $dir/crlnumber        # the current crl number
                                        # must be commented out to leave a V1 CRL
crl             = $dir/crl.pem          # The current CRL
private_key     = $dir/private/cakey.pem# The private key 
RANDFILE        = $dir/private/.rand    # private random number file

x509_extensions = usr_cert              # The extentions to add to the cert
...
```

## root CA key 생성
* 인증서 생성에 필요한 CA의 개인키 를 생성.
* OpenSSL 의 "[EC key pair 생성](./openssl/cli/keygen#ec-key-pair)" 참고.
* Example
```bash
cd $ROOTCA
openssl ecparam -genkey -name prime256v1 -out private/cakey.pem
openssl ec -in private/cakey.pem -out private/cakey.pem -aes256
chmod 400 private/cakey.pem
```

## root CA 인증서 생성
* 자가 서명(self-signed) 된 인증서를 생성.
* x509 형식의 인증서로 생성.
* PEM으로 출력(default)
* `man req` 참고.
* Example output
```bash
openssl req -new -x509 -extensions v3_ca -key private/cakey.pem -out cacert.pem
```
```bash
... 
Country Name (2 letter code) [XX]:KR
State or Province Name (full name) []:Seoul
Locality Name (eg, city) [Default City]:Seoul
Organization Name (eg, company) [Default Company Ltd]:example
Organizational Unit Name (eg, section) []:root CA
Common Name (eg, your name or your server's hostname) []:rootca.example.com
Email Address []:rootca@example.com
```
```bash
chmod 444 certs/ca.crt.pem
```

# 사용자 인증서 생성
* CSR(Certificate Signing Request) 를 생성 후, root CA에게 인증서 발행을 요청.
* PEM으로 출력(기본값)
### 사용자 개인 키 생성 (at a host)
* 인증서를 생성하기 위해서는 개인 키를 생성 필요.
```bash
cd opt/pki
mkdir host1 && cd host1
openssl genrsa -out host1.key.pem
```

## CSR 생성 (at a host)
* 사용자의 개인 키로 CSR 파일 생성.
* CSR 생성 시, Country, State, Locality, Organization 는 root CA의 인증서와 동일해야 함(기본값), openssl.cnf 에서 설정 가능.
```bash
openssl req -new -key host1.key.pem -out host1.csr.pem
```
```bash
...
Country Name (2 letter code) [XX]:KR
State or Province Name (full name) []:Daejeon
Locality Name (eg, city) [Default City]:Yuseong 
Organization Name (eg, company) [Default Company Ltd]:example
Organizational Unit Name (eg, section) []:host1
Common Name (eg, your name or your server's hostname) []:host1.example.com
Email Address []:host1@example.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

## 인증서 발행 (at a root CA)
* CA로부터 인증서 발행.
* 발행 성공 시, serial 번호가 증가하며 index.txt에 추가.
  * serial, index.txt눈 임의로 수정하면 안됨.
* `man ca` 참고.
```bash
# 기본적으로 'serial번호.pem' 형식으로 생성
openssl ca -in host1.csr.pem
# 출력 파일 이름 지정
openssl ca -in host1.csr.pem -out host1.crt.pem
```
* 옵션 없이 사용하면 openssl.cnf에서 정의된 CA의 키, 인증서, MD 알고리즘 사용(기본값).
  * `openssl.cnf` 참조, `-config` 옵션으로 openssl 설정 파일 지정 가능.
  * 발행된 인증서는 $ROOTCADIR/newcerts/시리얼번호.pem 형태로 생성.
* 옵션으로 CA 키, CA 인증서, MD 알고리즘, 발행된 인증서의 위치와 이름을 지정 가능.
* MD 알고리즘은 CA 인증서와 동일해야 발행 가능.
* 인증서 발행 시 ca 명령
> openssl ca  -in 'csr infile' [-config 'config file']  [-keyfile 'CA keyfile']  [-cert 'CA certificate file']  [-notext]  [-md 'md algorithm]  [-out 'cert outfile']
> ...

* `openssl.cnf` 내용
```
dir             = /opt/pki/root         # root CA basedir.
certs           = $dir/certs
new_certs_dir   = $dir/newcerts          # use if no "-out" option.
certificate     = $dir/cacert.pem        # use if no "-cert" option.
private_key     = $dir/private/cakey.pem # use if no "-keyfile" option.
default_days    = 365                    # use if no "-days" option.
default_md      = sha256                 # use if no "-md" option.
```
* Example
```bash
openssl ca -keyfile $ROOTCADIR/private/cakey.pem -cert $ROOTCADIR/cacert.pem -notext -md -sha1 -in host1.csr.pem -out host1.crt.pem
```

# X509 인증서 내용 출력
> openssl x509 -in 'infile' -noout -text
* Example
```bash
openssl x509 -in host1.crt.pem -noout -text
```

## 인증서 발행 확인 (at a root CA)
```bash
$ cat $ROOTCADIR/index.txt
V	170920145518Z		1000	unknown	/C=KR/ST=Daejeon/O=example/OU=host1/CN=host1.example.com/emailAddress=host1@example.com
```

## 인증서 검증
* 발행된 인증서는 CA 인증서로 검증(Verify)한다.
* CA 인증서만 있으면 검증 가능
* 인증서 검증
> openssl verify -CAfile 'CA certificate file' 'target certificate file'
* Example
```bash
openssl verify -CAfile $ROOTCADIR/cacert.pem host1.crt.pem
```

