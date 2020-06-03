# Message Digest?
* 임의의 길이를 가지는 메시지에 대응되는 일정한 길이의 코드.
* 해시(hash), 메시지 다이제트(message digest)

# Message Digest Function
* 해시 함수(hash function)
* 임의의 길이를 가지는 메시지의 해시를 출력하는 함수.
* key를 사용하지 않음.
* 1비트의 변화에도 완전히 다른 해시를 출력.
* 복호화가 불가능한  one-way function.
* 대표적으로 MD5, SHA1, SHA2 암호학적 해시 알고리즘를 사용.

# HMAC(Hash-based Message Authentication Code)
- MAC 생성에 암호학적 해시 알고리즘을 사용.
- MAC를 생성/검증하기 위해 대칭키(symmetric key)를 사용.

# EVP_MD API
* hash를 출력.
* CTX와 EVP 사용.
* Init, Update, Final 순으로 수행.
* `man EVP_MD_CTX_init`
```c
#include <openssl/evp.h>

struct env_md_ctx_st {
     const EVP_MD *digest;
     ENGINE *engine;             /* functional reference if 'digest' is ENGINE-provided */
     unsigned long flags;
     void *md_data;
    /* Public key context for sign/verify */
    EVP_PKEY_CTX *pctx;
    /* Update function: usually copied from EVP_MD */
    int (*update) (EVP_MD_CTX *ctx, const void *data, size_t count);
} /* EVP_MD_CTX */ ;
```
# Basic functions
**EVP_MD_CTX_init()**
```c
void EVP_MD_CTX_init(EVP_MD_CTX *ctx);
```
* `ctx` : message digest context
* `ctx`를 초기화

**EVP_MD_CTX_create()**
```c
EVP_MD_CTX *EVP_MD_CTX_create(void);
```
* `EVP_MD_CTX` 동적할당

**EVP_DigestInit()**
```c
int EVP_DigestInit(EVP_MD_CTX *ctx, const EVP_MD *type);
int EVP_DigestInit_ex(EVP_MD_CTX *ctx, const EVP_MD *type, ENGINE *impl);
```
* `ctx` : 초기화된 message digest context
* `type` : 해시 알고리즘, 아래 함수의 리턴값.
```c
    const EVP_MD *EVP_md_null(void);
    const EVP_MD *EVP_md2(void);
    const EVP_MD *EVP_md5(void);
    const EVP_MD *EVP_sha(void);
    const EVP_MD *EVP_sha1(void);
    const EVP_MD *EVP_dss(void);
    const EVP_MD *EVP_dss1(void);
    const EVP_MD *EVP_mdc2(void);
    const EVP_MD *EVP_ripemd160(void);
    const EVP_MD *EVP_sha224(void);
    const EVP_MD *EVP_sha256(void);
    const EVP_MD *EVP_sha384(void);
    const EVP_MD *EVP_sha512(void);
```
* `impl` : `type`에서 사용되는 엔진, 기본값은 NULL.
* message digest context 설정, 해시하기 위한 초기설정.
* 성공시 1, 실패시 0 리턴.

**EVP_DigestUpdate()**
```c
int EVP_DigestUpdate(EVP_MD_CTX *ctx, const void *d, size_t cnt);
```
* `ctx` : 초기설정이 완료된 message digest context
* `d` : 해시할 메시지
* `cnt` : `d`의 길이.
* 메시지를 입력으로 해시 알고리즘을 수행한다.
* 성공시 1, 실패시 0 리턴.

**EVP_DigestFinal()**
```c
int EVP_DigestFinal(EVP_MD_CTX *ctx, unsigned char *md, unsigned int *s);
int EVP_DigestFinal_ex(EVP_MD_CTX *ctx, unsigned char *md, unsigned int *s);
```
* `ctx` : Update가 끝난 message digest context.
* `md` : 해시가 출력될 버퍼, 충분한 버퍼를 가져야함.
* `s` : 출력되는 해시의 길이를 저장, NULL이 되면 안됨.
* 계산된 해시를 `md`에 저장.
* `EVP_DigestFinal_ex()`는 자동으로 ctx를 clean up.
* 성공시 1, 실패시 0 리턴.

**EVP_MD_CTX_cleanup()**
```c
int EVP_MD_CTX_cleanup(EVP_MD_CTX *ctx);
```
* `ctx`를 clean up.

**EVP_MD_CTX_destroy()**
```c
void EVP_MD_CTX_destroy(EVP_MD_CTX *ctx);
```
* `ctx`를 clean up.
* `EVP_MD_CTX_create()`로 할당된 `ctx`를 해재.

# Useful functions & contants
**EVP_MD_CTX_copy()**
```c
int EVP_MD_CTX_copy(EVP_MD_CTX *out,EVP_MD_CTX *in);
int EVP_MD_CTX_copy_ex(EVP_MD_CTX *out,const EVP_MD_CTX *in);
```
* `in` : source message digest context.
* `out` : destination message digest context. (초기화된)
* `ctx`를 copy.
* 보통 큰 메시지에서 일부분만 다른 경우 사용.
* `EVP_MD_CTX_copy_ex()`는 자동으로 `out`을 초기화.
* 성공시 1, 실패시 0 리턴.

**EXP_MAX_MD_SIZE**
```c
#define EVP_MAX_MD_SIZE 64     /* SHA512 */
```
* OpenSSL에서 정의한 message digest의 최대 크기(in bytes)

**EVP_MD_type**
* EVP_MD에 해당하는 알고리즘의 정보를 리턴하는 함수
```c
int EVP_MD_type(const EVP_MD *md);
```
* `EVP_MD` 구조체에 해당하는 NID를 리턴.
* 실패시 `NID_undef` 리턴.
  e.g. `EVP_MD_type(EVP_sha1());` 는 `NID_sha1`를 리턴.

**EVP_MD_pkey_type()**
```c
int EVP_MD_pkey_type(const EVP_MD *md);
```
* 공개키 서명 알고리즘과 관련된 해시 함수의 NID를 리턴.
* 실패시 `NID_undef` 리턴.
  e.g. RSA방식의 키를 사용한 경우, `NID_sha1WithRSAEncrption`을 리턴.

**EVP_MD_size**
```c
int EVP_MD_size(const EVP_MD *md);
```
* `EVP_MD`에 해당하는 알고리즘이 출력하는 해시의 길이를 리턴.(바이트)

**EVP_MD_block_size**
```c
int EVP_MD_block_size(const EVP_MD *md);
```
* `EVP_MD`에 해당하는 알고리즘이 사용하는 메시지 블럭 길이를 리턴.

# Useful macro
* `ctx`에 설정된 정보를 리턴하는 함수 및 매크로
 ```c
const EVP_MD *EVP_MD_CTX_md(const EVP_MD_CTX *ctx);
#define EVP_MD_CTX_size(e)             EVP_MD_size(EVP_MD_CTX_md(e))
#define EVP_MD_CTX_block_size(e)       EVP_MD_block_size((e)->digest)
#define EVP_MD_CTX_type(e)             EVP_MD_type((e)->digest)
```

**EVP_get_digestbyname()**
```c
const EVP_MD *EVP_get_digestbyname(const char *name);
```
* `name` : 해시 알고리즘 이름(문자열), `openssl list-message-digest-algorithms` 참고
* `name`에 해당하는 `EVP_MD` 구조체 포인터를 리턴, 실패시 `NULL` 리턴.
* 함수 수행 전에 `OpenSSL_add_all_digests()`이 호출되어야 함.

**EVP_get_digestbynid()**
```c
#define EVP_get_digestbynid(a) EVP_get_digestbyname(OBJ_nid2sn(a))
```
* digest NID에 해당하는 `EVP_MD*` 리턴

**EVP_get_digestbyobj()**
```c
#define EVP_get_digestbyobj(a) EVP_get_digestbynid(OBJ_obj2nid(a))
```
* `ASN1_OBJECT` 구조체에 해당하는 `EVP_MD*` 리턴

**Examples**
## `md.c`
```c
// Example - Message digest for file
/* md.c */
#include <stdio.h>
#include <stdlib.h>
#include <openssl/evp.h>

#define eprintfExit(x, ...) { fprintf(stderr, __VA_ARGS__); exit(x); }
#define eprintfReturn(x, ...) { fprintf(stderr, __VA_ARGS__); return (x); }

void printhex(unsigned char *b, int bLen)
{
	int i;
	printf("%02X",b[0]);
	for(i=1; i<bLen; i++)
		printf(":%02X", b[i]);
	printf("\n");
}

int make_md(const char *mdname, FILE *fp, unsigned char *md, int *mdLen)
{
	EVP_MD_CTX mctx;
	const EVP_MD *evpmd;
	unsigned char in[BUFSIZ];
	int inLen;
	
	OpenSSL_add_all_digests();
	if(!(evpmd=EVP_get_digestbyname(mdname)))
		eprintfReturn(0, "Unknown digest name.\n");

	EVP_MD_CTX_init(&mctx);
	EVP_DigestInit_ex(&mctx, evpmd, NULL);

	while((inLen=fread(in, 1, sizeof(in), fp))>0)
		EVP_DigestUpdate(&mctx, in, inLen);

	EVP_DigestFinal_ex(&mctx, md, mdLen);
	//EVP_MD_CTX_cleanup(&mctx);

	return 1;
}

void main(int argc, char **argv)
{
	unsigned char md[EVP_MAX_MD_SIZE];
	int mdLen;
	FILE *fp;

	if(argc!=3)
		eprintfExit(1, "Usage: %s <digest name> <inFile>.\n", argv[0]);

	if((fp=fopen(argv[2], "rb"))==NULL)
		eprintfExit(2, "open error %s", argv[2]);

	if(!make_md(argv[1], fp, md, &mdLen))
		exit(3);

	printf("Hash=");
	printhex(md, mdLen);

	fclose(fp);
}
```

**실행 결과**
```bash
$ gcc md.c -lcrypto
$ ./a.out sha1 md.c 
Hash=64:7C:E6:5B:5C:EA:FA:39:20:EE:62:60:56:97:7B:A8:FB:16:4F:8F
$ 
```

# HMAC API
* EVP_MD와 유사함.
* Init 과정에서 키 값을 설정하는 것만 EVP_MD와 다름.
* `man hmac`

# HMAC()
```c
#include <openssl/hmac.h>

unsigned char *HMAC(const EVP_MD *evp_md, const void *key,
              int key_len, const unsigned char *d, int n,
              unsigned char *md, unsigned int *md_len);
```
* `n` 길이의 메시지 `d`에 대한 HMAC을 생성.
* 성공 시 출력된 HMAC의 포인터(`md`가 `NULL`이면 내부의 `static` 문자열의 주소 리턴), 실패시 `NULL` 리턴.
* `md_len`은 `NULL`이면 안됨.
* `evp_md` : 해시 알고리즘.
* `key` : 키(key) 값. (in binary)
* `key_len` : `key`의 길이, HMAC의 키 길이는 해시 알고리즘에 따라 달라짐.
* `md` : HMAC을 저장.
* `md_len` : 출력된 `md`의 길이를 저장.

# Basic functions
**HMAC_CTX_init()**
```c
void HMAC_CTX_init(HMAC_CTX *ctx);
```
* hmac context를 초기화.

**HMAC_Init()**
```c
int HMAC_Init(HMAC_CTX *ctx, const void *key, int key_len, const EVP_MD *md);
int HMAC_Init_ex(HMAC_CTX *ctx, const void *key, int key_len, const EVP_MD *md, ENGINE *impl);
```
* `ctx` : 초기화된 hmac context.
* `key` : 키 값. (in binary)
* `key_len` : `key`의 길이.
* `md` : 해시 알고리즘.
* `HMAC_Init_ex()`은 해시 알고리즘에 따라 **ENGINE**을 추가 구성 가능.

**HMAC_Update()**
```c
int HMAC_Update(HMAC_CTX *ctx, const unsigned char *data, int len);
```
* `ctx` : 초기설정된 hmac context.
* `data` : message.
* `len` : `data`의 길이.
* 설정된 키와 해시 알고리즘으로 HMAC을 계산.

**HMAC_Final()**
```c
int HMAC_Final(HMAC_CTX *ctx, unsigned char *md, unsigned int *len);
```
* `ctx` : `Update()`가 완료된 hmac context.
* `md` : HMAC을 저장할 버퍼.
* `len` : 출력된 HMAC의 길이를 저장.
* 출력된 HMAC을 `md`에 저장.
* `md_len`은 `NULL`이면 안됨.

**Cleanup funcions**
```c
void HMAC_CTX_cleanup(HMAC_CTX *ctx);
void HMAC_cleanup(HMAC_CTX *ctx);
```
* hmac context를 clean up. (HMAC을 생성하기 위해 할당되었던 자원을 해제, 키 값 제거 등 context의 내용을 삭제)
* `HMAC_cleanup()`은 `HMAC_CTX_cleanup()`의 별칭, 0.9.6b와 하위 호환성(back compatibility)을 위해 사용, 사용되지 않음.

**Example - hmac.c**
```c
// Example - HMAC for a message.
/* hmac.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/hmac.h>

#define eprintfExit(x, ...) { fprintf(stderr, __VA_ARGS__); exit(x); }
#define eprintfReturn(x, ...) { fprintf(stderr, __VA_ARGS__); return (x); }

void printhex(unsigned char *b, int bLen)
{
	int i;
	printf("%02X",b[0]);
	for(i=1; i<bLen; i++)
		printf(":%02X", b[i]);
	printf("\n");
}

int make_hmac(const char *mdname, unsigned char *md, int *mdLen,
		const unsigned char *key, const int keyLen,
		const unsigned char *m, const int mLen)
{
	HMAC_CTX hctx;
	const EVP_MD* evpmd;
	
	OpenSSL_add_all_digests();
	if(!(evpmd=EVP_get_digestbyname(mdname)))
		eprintfReturn(0, "Unknown digest name.\n");

	HMAC_Init(&hctx, key, keyLen, evpmd);
	HMAC_Update(&hctx, m, mLen);
	HMAC_Final(&hctx, md, mdLen);

	HMAC_CTX_cleanup(&hctx);

	return 1;
}

void main(int argc, char **argv)
{
	unsigned char md[EVP_MAX_MD_SIZE];
	int  mdLen;

	if(argc!=4)
		eprintfExit(1, "Usage: %s <digest name> <password> <messages>.\n", argv[0]);

	/* use HMAC() */
	// OpenSSL_add_all_digests();
	// HMAC(EVP_get_digestbyname(argv[1]), argv[2], strlen(argv[2]), argv[3], strlen(argv[3]), md, &mdLen);
	/* end of 'use HMAC() */
	if(!make_hmac(argv[1], md, &mdLen, argv[2], strlen(argv[2]), argv[3], strlen(argv[3])))
		exit(2);

	printf("HMAC=");
	printhex(md, mdLen);
}
```
**실행 결과**
```bash
$ gcc hmac.c -lcrypto
$ ./a.out sha1 password1234 "Hello, openssl"
HMAC=D3:94:59:1E:6D:99:06:62:E9:A6:84:BD:27:A8:34:EB:E4:6D:53:B0
$ ./a.out sha1 "password 1234" "Hello, openssl"
HMAC=F5:19:38:E1:95:8D:16:B0:54:7D:C0:00:B7:E3:3C:2E:69:3A:5C:BE
$
```


_Reference_

[1] OpenSSL을 이용한 보안 프로그래밍 / 네트워크연구실(http://network.hanbat.ac.kr)
[2] www.openssl.org
