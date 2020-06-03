# Settings for Root CA
* openssl을 이용하여 인증서 발급을 위해 PKI 인프라 구성
* root CA 에서 사용하는 기본 디렉터리 및 파일 준비.
**Example**
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

**Check root ca for files**
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

**`openssl.cnf` 내용**
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

# Create the root CA
1. root CA key 생성
* 인증서 생성에 필요한 CA의 개인키 를 생성.
* OpenSSL 의 "[EC key pair 생성](./openssl/cli/keygen#ec-key-pair)" 참고.
* Example
```bash
cd $ROOTCA
openssl ecparam -genkey -name prime256v1 -out private/cakey.pem
openssl ec -in private/cakey.pem -out private/cakey.pem -aes256
chmod 400 private/cakey.pem
```
2. root CA 인증서 생성
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
3. 사용자 인증서 생성
* CSR(Certificate Signing Request) 를 생성 후, root CA에게 인증서 발행을 요청.
* PEM으로 출력(기본값)
**사용자 개인 키 생성 (at a host)**
* 인증서를 생성하기 위해서는 개인 키를 생성 필요.
```bash
cd opt/pki
mkdir host1 && cd host1
openssl genrsa -out host1.key.pem
```
# CSR 생성
* Do at the client side.
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

# 인증서 발행 (at a root CA)
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
```
openssl ca  -in 'csr infile' [-config 'config file']  [-keyfile 'CA keyfile']  [-cert 'CA certificate file']  [-notext]  [-md 'md algorithm]  [-out 'cert outfile'] ...
```

**`openssl.cnf` 내용**
```
dir             = /opt/pki/root         # root CA basedir.
certs           = $dir/certs
new_certs_dir   = $dir/newcerts          # use if no "-out" option.
certificate     = $dir/cacert.pem        # use if no "-cert" option.
private_key     = $dir/private/cakey.pem # use if no "-keyfile" option.
default_days    = 365                    # use if no "-days" option.
default_md      = sha256                 # use if no "-md" option.
```
**Example**
```bash
openssl ca -keyfile $ROOTCADIR/private/cakey.pem -cert $ROOTCADIR/cacert.pem -notext -md -sha1 -in host1.csr.pem -out host1.crt.pem
```

**X509 인증서 내용 출력**
```
openssl x509 -in 'infile' -noout -text
```
**Example**
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
```
openssl verify -CAfile 'CA certificate file' 'target certificate file'
```
**Example**
```bash
openssl verify -CAfile $ROOTCADIR/cacert.pem host1.crt.pem
```

