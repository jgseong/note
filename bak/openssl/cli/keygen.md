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
