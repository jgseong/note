# About EVP
* Perhaps, EVP stands for Envelope.
* High-level Cryptographic Functions.
* 다양한 OpenSSL의 암호 API를 하나의 인터페이스(interface)로 구성.
* The EVP interface, which can be accessed by including `penssl/evp.h`

# About CTX(Context)
* EVP로 Encryption, Decryption 등, 각 수행에 필요하거나 변경되는 정보들을 유지하는 구조체.
  * 암호화 알고리즘, 키(key) 값, IV(initialization vector) 값, padding 설정 등...
  * 대칭키 암호에서 `EVP_CIPHER_CTX` 구조체를 사용.

# EVP Cipher APIs
* EVP 사용 시 여러 암호 알고리즘을 동일한 루틴(routine)으로 사용 가능.
  * 실질적으로 데이터를 암호/복호화하는 함수.
    * `EVP_EncryptUpdate()`, `EVP_DecryptUpdate()`, `EVP_CipherUpdate()`, ...
* 접미사 `_ex`가 붙는 함수는 암호 알고리즘에 따라 추가적인 설정이 가능.
* 암호/복호화의 동작 루틴은 동일하고 사용되는 함수명만 다름.
* APIs
  * `man EVP_CIPHER_CTX_init`
* 헤더(header) 파일
  * `#include <openssl/evp.h>`

# EVP_CIPHER_CTX 구조체
```c
struct evp_cipher_ctx_st{
  const EVP_CIPHER *cipher; 
  ENGINE *engine;           /* functional reference if 'cipher' is ENGINE-provided */
  int encrypt;              /* encrypt or decrypt */
  int buf_len;              /* number we have left */
  unsigned char ovi[EVP_MAX_IV_LENGTH];  /* original iv */
  unsigned char iv[EVP_MAX_IV_LENGTH];   /* working iv */
  unsigned char buf[EVP_MAX_BLOCK_LENGTH];  /* saved partial block */
  int num;                   /* used by cfb/ofb/ctr mode */
  void *app_data;            /* application stuff */
  int key_len;               /* May change for variable length cipher */
  unsigned long flags;       /* Various flags */
  void *cipher_data;         /* per EVP data */
  int final_used;
  unsigned char final[EVP_MAX_BLOCK_LENGTH]; /* possible final block */
} /* EVP_CIPHER_CTX */ ;
```

# EVP_CIPHER_CTX functions
**EVP_CIPHER_CTX_init()**
```c
void EVP_CIPHER_CTX_init(EVP_CIPHER_CTX *ctx);
```
  * cipher context를 초기화.
  * `ctx` : cipher context의 주소.

**EVP 암호/복호화 초기 설정 - Init()**
```c
int EVP_EncryptInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, unsigned char *key, unsigned char *iv);
int EVP_DecryptInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, unsigned char *key, unsigned char *iv);
int EVP_CipherInit(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, unsigned char *key, unsigned char *iv, int enc);
int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, ENGINE *impl, unsigned char *key, unsigned char *iv);
int EVP_DecryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, ENGINE *impl, unsigned char *key, unsigned char *iv);
int EVP_CipherInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, ENGINE *impl, unsigned char *key, unsigned char *iv, int enc);
```
  * 암호/복호화 하기 위한 초기 설정.
  * 성공시 `1`, 실패시 `0` 리턴.
  * `ctx` : 사용되는 cipher context.
  * `type` : 암호화 알고리즘(cipher)
    e.g. `EVP_des_ecb()`, `EVP_aes_128_cbc()`, ... 등의 리턴 값.
  * `key` : binary key 값, 암호 알고리즘에 따라 길이가 잘림.
  * `iv` : binary iv 값, 암호 알고리즘에 따라 길이가 잘림, ECB mode에서는 `NULL`로 설정, 값이 있더라도 사용되지 않음.
  * `enc` : 암호/복호화 flag, `1`이면 **암호화**, `0`이면 **복호화**.

**EVP 암호/복호화 수행 - Update()**
```c
int EVP_EncryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl, unsigned char *in, int inl);
int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl, unsigned char *in, int inl);
int EVP_CipherUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl, unsigned char *in, int inl);
```
  * 실질적으로 데이터를 암호/복호화.
  * 성공시 `1`, 실패시 `0` 리턴.
  * block size가 맞지 않으면, `Final()`,`Final_ex()`에서 처리. (ECB/CBC mode처럼 block cipher인 경우)
  * `outl`은 암호/복호화에 성공한 바이트 크기를 나타냄, 즉 암호/복호화가 성공한 바이트 크기.
  * `ctx` : 사용되는 cipher context.
  * `out` : 암호/복호화된 데이터가 저장될 버퍼.
  * `outl` : `out`의 길이가 저장될 변수, 암호/복호화된 데이터의 길이.
  * `in` : 입력 데이터, 암호화시 평문, 복호화시 암호문.
  * `inl` : `in`의 길이

**EVP 암호/복호화 수행 - Final()**
```c
int EVP_EncryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
int EVP_EncryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
int EVP_DecryptFinal(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
int EVP_DecryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
int EVP_CipherFinal(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
int EVP_CipherFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
```
  * 패딩 및 필요한 작업을 처리
  * 성공시 1, 실패시 0 리턴.
  * block size가 맞지 않아 Update()에서 처리가 안된 데이터를 처리. (ECB/CBC mode처럼 block cipher인 경우)
  * ECB/CBC mode에서 암호화시 패딩(padding)이 추가, 복호화시 패딩이 제거.
  * `ctx` : 사용되는 cipher context.
  * `out` : 암호/복호화된 데이터가 저장될 버퍼
  * `outl` : `out`의 길이가 저장될 변수
  
# Useful APIs
**EVP_CIPHER_CTX_set_padding()**
```c
int EVP_CIPHER_CTX_set_padding(EVP_CIPHER_CTX *ctx, int padding);
```
  * 패딩(padding) 사용 유무를 결정.
  * 항상 `1` 리턴.
  * **ECB/CBC mode**에서 사용.
  * `padding` : `1`이면 on, `0`이면 off.

**EVP_CIPHER_CTX_set_key_length()**
```c
int EVP_CIPHER_CTX_set_key_length(EVP_CIPHER_CTX *ctx, int keylen);
```
  * `ctx`의 key 길이를 설정.
  * 항상 1 리턴.
  * cipher에 따라 가변적인 key 길이 설정 가능.
  * `keylen` : 바이트 단위의 key 길이.

**EVP_CIPHER_CTX_ctrl()**
```c
int EVP_CIPHER_CTX_ctrl(EVP_CIPHER_CTX *ctx, int type, int arg, void *ptr);
```
  * cipher에 관련된 설정 파라미터(configurable parameters)를 설정 가능.
  * Linux system call의 `fctrl()`와 유사.
  * `type` : 암호 알고리즘에 따라 설정 가능한 값, refer to "openssl/evp.h"
    e.g. EVP_CTRL_GET_RC2_KEY_BITS, EVP_CTRL_SET_RC2_KEY_BITS, EVP_CTRL_GET_RC5_ROUNDS, EVP_CTRL_SET_RC5_ROUNDS, ... 등.
  * `arg` : 파라미터(정수형), `type`에 따라 용도가 달라짐.
  * `ptr` : 파라미터(정수형), 읽을/저장될 변수의 주소 등으로 사용 가능, type에 따라 용도가 달라짐.

**EVP_CIPHER_CTX_cleanup()**
```c
int EVP_CIPHER_CTX_cleanup(EVP_CIPHER_CTX *ctx);
```
  * `ctx`의 내용을 삭제.

**EVP_get_cipherbyname()**
```c
const EVP_CIPHER *EVP_get_cipherbyname(const char *name);
```
  * `name`에 해당하는 EVP_CIPHER 구조체를 리턴.
  * `OpenSSL_add_all_ciphers()`를 먼저 호출해야 사용 가능.
  * `name` : cipher 이름, refer to "man enc"
    e.g. `des-ecb`, `aes-128-ecb`, `aes-192-cbc`, `...`.

# EVP macros and others.
* How to check that `padding` is disable
```c
int pad=(ctx->flags&EVP_CIPH_NO_PADDING);
```

**EVP_get_cipherbynid/obj**
```c
// a : integer
#define EVP_get_cipherbynid(a) EVP_get_cipherbyname(OBJ_nid2sn(a))
#define EVP_get_cipherbyobj(a) EVP_get_cipherbynid(OBJ_obj2nid(a))
```

* Get an attributes from EVP_CIPHER
```c
// e : const EVP_CIPHER*
#define EVP_CIPHER_nid(e)              ((e)->nid)
#define EVP_CIPHER_block_size(e)       ((e)->block_size)
#define EVP_CIPHER_key_length(e)       ((e)->key_len)
#define EVP_CIPHER_iv_length(e)        ((e)->iv_len)
#define EVP_CIPHER_flags(e)            ((e)->flags)
#define EVP_CIPHER_mode(e)             ((e)->flags) & EVP_CIPH_MODE)
int EVP_CIPHER_type(const EVP_CIPHER *ctx);
```

* Get an attributes from EVP_CIPHER_CTX
```c
// e : EVP_CIPHER_CTX*
#define EVP_CIPHER_CTX_cipher(e)       ((e)->cipher)  // get cipher object
#define EVP_CIPHER_CTX_nid(e)          ((e)->cipher->nid)  // get cipher nid
#define EVP_CIPHER_CTX_block_size(e)   ((e)->cipher->block_size)  // get cipher block size
#define EVP_CIPHER_CTX_key_length(e)   ((e)->key_len)  // get cipher key length
#define EVP_CIPHER_CTX_iv_length(e)    ((e)->cipher->iv_len)  // get cipher IV length
#define EVP_CIPHER_CTX_get_app_data(e) ((e)->app_data)
#define EVP_CIPHER_CTX_set_app_data(e,d) ((e)->app_data=(char *)(d))
#define EVP_CIPHER_CTX_type(c)         EVP_CIPHER_type(EVP_CIPHER_CTX_cipher(c))  // get cipher type
#define EVP_CIPHER_CTX_flags(e)        ((e)->cipher->flags)  // get flags
#define EVP_CIPHER_CTX_mode(e)         ((e)->cipher->flags & EVP_CIPH_MODE)  // get mode
```

* Convert for ASN.1
```c
int EVP_CIPHER_param_to_asn1(EVP_CIPHER_CTX *c, ASN1_TYPE *type);
int EVP_CIPHER_asn1_to_param(EVP_CIPHER_CTX *c, ASN1_TYPE *type);
```

# EVP 암호/복호화 과정
**Example code for `do_crypt`**
```c
do_crypt(FILE *inFp, FILE *outFp, const EVP_CIPHER *cipher,
        const unsigned char *key, const unsigned char *iv/*, int enc*/) // enc는 EVP_Cipher~()에서 사용
{
  int inLen, outLen;
  unsigned char inBuf[BUFSIZ], outBuf[BUFSIZ+EVP_MAX_BLOCK_LENGTH];
// inBuf 크기는 cipher에 따라 block size의 배수.
// outBuf 크기는 inBuf보다 추가적인 block size를 더 가잠. (padding 등의 이유)
// block cipher인 ECB/CBC mode에서 적용되는 사항 (CBC만 IV 필요)
// stream cipher인OFB/CFB/CTR에서는 plaintext와 ciphertext의 크기가 같음. (단, IV가 필요)
  EVP_CIPHER_CTX ctx;

// 1. context 초기화
  EVP_CIPHER_CTX_init(&ctx);

// 2. 암호/복호화 초기 설정
  EVP_EncryptInit_ex(&ctx, cipher, NULL, key, iv); // encrypt
//EVP_DecryptInit_ex(&ctx, cipher, NULL, key, iv); // decrypt
//EVP_CipherInit_ex(&ctx, cipher, NULL, key, iv, enc); // enc=1 : encrypt, enc=0 : decrypt 

// 3. 데이터 암호/복호화
  while((inLen=fread(inBuf, 1, sizeof(inBuf), inFp))>0)
  {
    EVP_EncryptUpdate(&ctx, outBuf, &outLen, inBuf, inLen);
//  EVP_DecryptUpdate(&ctx, outBuf, &outLen, inBuf, inLen);
//  EVP_CipherUpdate(&ctx, outBuf, &outLen, inBuf, inLen);
    fwrite(outBuf, 1, outLen, outFp);
  }

// 4. 암호화 마지막 처리, e.g. 패딩 처리
  EVP_EncryptFinal_ex(&ctx, outBuf, &outLen);
//EVP_DecryptFinal_ex(&ctx, outBuf, &outLen);
//EVP_CipherFinal_ex(&ctx, outBuf, &outLen);
  fwrite(outBuf, 1, outLen, outFp);

  EVP_CIPHER_CTX_cleanup(&ctx);
}
```

**Example 1 - using EVP_Encrypt/Decrypt~()**
```c
/* enc.c */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <openssl/evp.h>
#include <openssl/rand.h>
#include <getopt.h>

#define PrintfErrorExit(x, ...) { fprintf(stderr, __VA_ARGS__); exit(x); }

int encrypt(FILE *inFp, FILE *outFp, const EVP_CIPHER *cipher, 
		const unsigned char *key, const unsigned char *iv)
{
	int inLen, outLen;		// inLen:입력된 데이터의 길이, outLen:출력된 데이터의 길이
	char inBuf[BUFSIZ], outBuf[BUFSIZ+EVP_MAX_BLOCK_LENGTH];	// inBuf:입력 데이터 버퍼, outBuf:출력 데이터 버퍼
	EVP_CIPHER_CTX ctx;		// 암호화 수행에 사용할 context

	// 1. context 초기화
	EVP_CIPHER_CTX_init(&ctx);

	// 2. 암호화 초기 설정.
	// - context, 암호 알고리즘, 키 값, IV 값 설정
	EVP_EncryptInit_ex(&ctx, cipher, NULL, key, iv);

	// 3. 데이터 암호화
	while((inLen=fread(inBuf, 1, sizeof(inBuf), inFp))>0)		// 입력 파일에서 BUFSIZ만큼 데이터를 read
	{
		if(!EVP_EncryptUpdate(&ctx, outBuf, &outLen, inBuf, inLen))		// read된 데이터를 암호화
		{
			printf("EVP_EncryptUpdate() error.\n");
			EVP_CIPHER_CTX_cleanup(&ctx);
			return -1;
		}
		fwrite(outBuf, 1, outLen, outFp);		// 출력 파일에 암호화된 데이터를 write
	}

	// 4. 암호화의 마지막 처리, e.g. 패딩 처리
	if(!EVP_EncryptFinal_ex(&ctx, outBuf, &outLen))		
	{
		printf("EVP_EncryptFinal_ex() error.\n");
		EVP_CIPHER_CTX_cleanup(&ctx);
		return -2;
	}
	fwrite(outBuf, 1, outLen, outFp);			// 출력 파일에 마지막으로 암호화된(패딩 처리된) 데이터를 write

	EVP_CIPHER_CTX_cleanup(&ctx);			// context 초기화
	return 0;
}

int decrypt(FILE *inFp, FILE *outFp, const EVP_CIPHER *cipher,
		const unsigned char *key, const unsigned char *iv)
{
	int inLen, outLen;
	char inBuf[BUFSIZ], outBuf[BUFSIZ+EVP_MAX_BLOCK_LENGTH];
	EVP_CIPHER_CTX ctx;		// 복호화 수행에 사용할 context

	// 1. context 초기화
	EVP_CIPHER_CTX_init(&ctx);

	// 2. 복호화 초기 설정.
	// - context, 암호 알고리즘, 키 값, IV 값 설정
	EVP_DecryptInit_ex(&ctx, cipher, NULL, key, iv);

	// 3. 데이터 복호화
	while((inLen=fread(inBuf, 1, sizeof(inBuf), inFp))>0)	// 입력 파일에서 BUFSIZ만큼 데이터를 read
	{
		if(!EVP_DecryptUpdate(&ctx, outBuf, &outLen, inBuf, inLen))		// read된 데이터를 복호화, 실패 시 0 리턴
		{
			printf("EVP_DecryptUpdate() error.\n");
			EVP_CIPHER_CTX_cleanup(&ctx);
			return -1;
		}
		fwrite(outBuf, 1, outLen, outFp);		// 출력 파일에 복호화된 데이터를 write
	}

	// 4. 복호화의 마지막 처리, e.g. 패딩 처리
	if(!EVP_DecryptFinal_ex(&ctx, outBuf, &outLen))
	{
		printf("EVP_DecryptFinal_ex() error.\n");
		EVP_CIPHER_CTX_cleanup(&ctx);
		return -2;
	}
	fwrite(outBuf, 1, outLen, outFp);		// 출력 파일에 마지막으로 복호화된(패딩 처리된) 데이터를 write

	EVP_CIPHER_CTX_cleanup(&ctx);
	return 0;
}

void printhex(const char *prefix, const unsigned char *s, const int sLen)
{
	int i;
	printf("%s[%d]:\n", prefix, sLen);
	printf("%02X", s[0]);
	for(i=1; i<sLen; i++)
		printf(":%02X", s[i]);
	printf("\n");
}

int main(int argc, char **argv)
{
	FILE *inFp, *outFp;											// 입출력 파일의 파일 포인터
	int opt;													// 옵션 문자
	int keyLen, ivLen;											// 입력된 key 값, iv 값
	unsigned char key[EVP_MAX_KEY_LENGTH];						// key 버퍼
	unsigned char iv[EVP_MAX_IV_LENGTH];						// iv 버퍼
	const EVP_CIPHER *cipher=EVP_enc_null();					// 암호 알고리즘
	int (*crypt)(FILE*, FILE*, const EVP_CIPHER*, 				// 함수 포인터
			const unsigned char*, const unsigned char *);		

	if(argc!=4 || (opt=getopt(argc, argv, "ed"))==-1)
		PrintfErrorExit(2, "Usage: %s -e|d <inFile> <outFile>\n", argv[0]);


	switch(opt)
	{
		case 'e':	// encrypt
			crypt=encrypt;
			break;
		case 'd':	// decrypt
			crypt=decrypt;
			break;
		case '?':
		default:
			PrintfErrorExit(3, "Usage: %s -e|d <inFile> <outFile>\n", argv[0]);
	}

	if((inFp=fopen(argv[2], "rb"))==NULL)
		PrintfErrorExit(4, "fopen(\"%s\") error.\n", argv[1]);

	if((outFp=fopen(argv[3], "wb"))==NULL)
		PrintfErrorExit(5, "fopen(\"%s\") error.\n", argv[2]);

	OpenSSL_add_all_ciphers(); 		// EVP_get_cipherbyname()을 사용하기 위해 호출.
	cipher=EVP_get_cipherbyname("aes-128-cbc");

	memcpy(key, "password01234567", keyLen=EVP_CIPHER_key_length(cipher));
	memcpy(iv, "01234567", ivLen=EVP_CIPHER_iv_length(cipher));
	printhex("key", key, keyLen);
	printhex("iv", iv, ivLen);

	if(crypt(inFp, outFp, cipher, key, iv)<0)
		exit(6);

	fclose(inFp);
	fclose(outFp);

	exit(0);
}
```

**Example 2 - using EVP_Cipher~()**
```c
/* enc2.c */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <openssl/evp.h>
#include <openssl/rand.h>
#include <getopt.h>

#define PrintfErrorExit(x, ...) { fprintf(stderr, __VA_ARGS__); exit(x); }

int do_crypt(FILE *inFp, FILE *outFp, const EVP_CIPHER *cipher, 
		const unsigned char *key, const unsigned char *iv, int enc)
{
	int inLen, outLen;		// inLen:입력된 데이터의 길이, outLen:출력된 데이터의 길이
	char inBuf[BUFSIZ], outBuf[BUFSIZ+EVP_MAX_BLOCK_LENGTH];	// inBuf:입력 데이터 버퍼, outBuf:출력 데이터 버퍼
	EVP_CIPHER_CTX ctx;		// 암호/복호화 수행에 사용할 context

	// 1. context 초기화
	EVP_CIPHER_CTX_init(&ctx);

	// 2. 암호/복호화 초기 설정.
	// - context, 암호 알고리즘, 키 값, IV 값 설정
	EVP_CipherInit_ex(&ctx, cipher, NULL, key, iv, enc);

	// 3. 데이터 암호화
	while((inLen=fread(inBuf, 1, sizeof(inBuf), inFp))>0)		// 입력 파일에서 BUFSIZ만큼 데이터를 read
	{
		if(!EVP_CipherUpdate(&ctx, outBuf, &outLen, inBuf, inLen))		// read된 데이터를 암호/복호화
		{
			printf("EVP_EncryptUpdate() error.\n");
			EVP_CIPHER_CTX_cleanup(&ctx);
			return -1;
		}
		fwrite(outBuf, 1, outLen, outFp);		// 출력 파일에 암호/복호화된 데이터를 write
	}

	// 4. 암호/복호화의 마지막 처리, e.g. 패딩 처리
	if(!EVP_CipherFinal_ex(&ctx, outBuf, &outLen))		
	{
		printf("EVP_EncryptFinal_ex() error.\n");
		EVP_CIPHER_CTX_cleanup(&ctx);
		return -2;
	}
	fwrite(outBuf, 1, outLen, outFp);			// 출력 파일에 마지막으로 암호/복호화된(패딩 처리된) 데이터를 write

	EVP_CIPHER_CTX_cleanup(&ctx);			// context 초기화
	return 0;
}

void printhex(const char *prefix, const unsigned char *s, const int sLen)
{
	int i;
	printf("%s[%d]:\n", prefix, sLen);
	printf("%02X", s[0]);
	for(i=1; i<sLen; i++)
		printf(":%02X", s[i]);
	printf("\n");
}

int main(int argc, char **argv)
{
	FILE *inFp, *outFp;											// 입출력 파일의 파일 포인터
	int opt, enc;												// 옵션 문자, 암호/복호화 flag
	int keyLen, ivLen;											// 입력된 key 값, iv 값
	unsigned char key[EVP_MAX_KEY_LENGTH];						// key 버퍼
	unsigned char iv[EVP_MAX_IV_LENGTH];						// iv 버퍼
	const EVP_CIPHER *cipher=EVP_enc_null();					// 암호 알고리즘
	int (*crypt)(FILE*, FILE*, const EVP_CIPHER*, 				// 함수 포인터
			const unsigned char*, const unsigned char *);		

	if(argc!=4 || (opt=getopt(argc, argv, "ed"))==-1)
		PrintfErrorExit(2, "Usage: %s -e|d <inFile> <outFile>\n", argv[0]);


	switch(opt)
	{
		case 'e':	// encrypt
			enc=1;
			break;
		case 'd':	// decrypt
			enc=0;
			break;
		case '?':
		default:
			PrintfErrorExit(3, "Usage: %s -e|d <inFile> <outFile>\n", argv[0]);
	}

	if((inFp=fopen(argv[2], "rb"))==NULL)
		PrintfErrorExit(4, "fopen(\"%s\") error.\n", argv[1]);

	if((outFp=fopen(argv[3], "wb"))==NULL)
		PrintfErrorExit(5, "fopen(\"%s\") error.\n", argv[2]);

	OpenSSL_add_all_ciphers(); 		// EVP_get_cipherbyname()을 사용하기 위해 호출.
	cipher=EVP_get_cipherbyname("aes-128-cbc");

	memcpy(key, "password01234567", keyLen=EVP_CIPHER_key_length(cipher));
	memcpy(iv, "01234567", ivLen=EVP_CIPHER_iv_length(cipher));
	printhex("key", key, keyLen);
	printhex("iv", iv, ivLen);

	if(do_crypt(inFp, outFp, cipher, key, iv, enc)<0)
		exit(6);

	fclose(inFp);
	fclose(outFp);

	exit(0);
}
```

**Example 결과**
```bash
$ gcc enc.c -lcrypto
$ cat -v data.txt
OpenSSL EVP Symmetric Key Cipher APIs
$ ./a.out -e data.txt data.bin
key[16]:
70:61:73:73:77:6F:72:64:30:31:32:33:34:35:36:37
iv[16]:
30:31:32:33:34:35:36:37:00:6B:65:79:00:69:76:00
$ cat -v data.bin && echo
A"M-3M-FM-rM-d^_bE.&FdM-T-M-<^G^HdM-#M-VM-^F^SM-^H4<EM-gM-\i^EM-}M-<qfe0M-^F]M-H@M-9BM-'M-1"M-,(
$ ./a.out -d data.bin data.out
key[16]:
70:61:73:73:77:6F:72:64:30:31:32:33:34:35:36:37
iv[16]:
30:31:32:33:34:35:36:37:00:6B:65:79:00:69:76:00
$ cat -v data.out
OpenSSL EVP Symmetric Key Cipher APIs
$
```

_Reference_

1. OpenSSL을 이용한 보안 프로그래밍 / [네트워크연구실](http://network.hanbat.ac.kr) 
2. [OpenSSL Official Site](https://www.openssl.org)
