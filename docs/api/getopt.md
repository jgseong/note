# About getopt()?
* 실행 명령(execution command)의 인자(arguments) 파싱(parsing)를 도와주는 함수
* 각 인자들은 일반적으로 공백 '` `'과 single/double quotation mark `'` ,`"`로 구분
* C/C++ 소스 코드의 `main(int argc, char *argv[])`의 parameter로 사용
  * `int argc` : 인자의 갯수, 0번째는 실행명령을 포함
  * `char *argv[]` : 인자 vector, 문자열 배열

```c
main(int argc, char *argv[])
{
#if 0
  e.g. argc, argv의 값.
   $ ./a.out -a -b -c data -d e.txt
  argc=7
  argv[0]="./a.out",  argv[1]="-a",  argv[2]="-b",  argv[3]="-c"
  argv[4]="data",     argv[5]="-d",  argv[6]="e.txt"
#endif
}
```
- 리눅스에서 보통 `-`(dash)로 옵션을 사용, 옵션 인자의 시작하는 `-`는 문자, `--`는 문자열로 구분.
- 이런 형식의 옵션 인자를 처리하기 위한 라이브러리 함수로 `getopt()` 사용. (`-`로 시작하는 문자 옵션; **short option**)
- GNU extension으로 `getopt_long()`, `getopt_long_only()` 사용. (`--`로 시작하는 문자열 옵션; **long option**)

**man getopt**
```bash
man 3 getopt
```

```c
GETOPT(3)
NAME
       getopt, getopt_long, getopt_long_only, optarg, optind, opterr, optopt - Parse command-line options

SYNOPSIS
       #include <unistd.h>

       int getopt(int argc, char * const argv[],
                  const char *optstring);

       extern char *optarg;
       extern int optind, opterr, optopt;

       #include <getopt.h>

       int getopt_long(int argc, char * const argv[],
                  const char *optstring,
                  const struct option *longopts, int *longindex);

       int getopt_long_only(int argc, char * const argv[],
                  const char *optstring,
                  const struct option *longopts, int *longindex);

   Feature Test Macro Requirements for glibc (see feature_test_macros(7)):

       getopt(): _POSIX_C_SOURCE >= 2 || _XOPEN_SOURCE
       getopt_long(), getopt_long_only(): _GNU_SOURCE
```

# Global variables
* `optarg` : 해당 옵션의 추가적인 인자(문자열).
* `optind` : 현재 argv를 가리키는 index, 1부터 시작.
* `opterr` : getopt()의 에러 출력 flag, opterr=1이면 출력, 0이면 출력 안함. 
* `optopt` : 에러가 난 문자를 저장.
  **e.g.** 옵션 인자가 `d`이고 `optsring="abc"`라면, `?`를 리턴하고 `optopt='d'`.

# getopt()

```c
int getopt(int argc, char * const argv[], const char *optstring);
```
* it parses short option in a argument vector.
  * `argc` : 인자의 총 개수, 보통 `main()`의 argc를 사용.
  * `argv` : 인자의 문자열 배열, 보통 `main()`의 `argv`를 사용.
* `optstring` : 옵션으로 사용하는 문자들로 구성된 문자열.
  * 추가적인 인자가 필요한 옵션 문자는 뒤에 `:` 또는 `::`를 사용.
  * `:`는 옵션의 추가 인자를 공백 ('` `') 또는 다음 문자부터 인자로 취급하여 `optarg`에 저장
  * `::`는 옵션의 추가 인자를 다음 문자부터 문자열로 취급 `optarg`에 저장. 공백 ('` `')은 허용안함.
  * `optstring`의 첫 문자가 `-`인 경우, `?` 대신 `1`를 리턴하며, 오류 출력을 하지 않음.
  * `optstring`의 첫 문자가 `+`인 경우, 인자에 대해 오류가 발생하면 바로 파싱을 중지(`-1`를 리턴).
  * `optstring`의 첫 문자가 `:`인 경우(`-`,`+`다음에 사용하면 중복 가능), 오류를 출력하지 않음. 
  * `optstring`의 첫 문자가 ':'인 경우, `man 3 getopt`에서는 `?` 대신 `:`를 리턴한다고 되어 있으나, 동작되지 않음. (ubuntu 16 lts, glibc 2.23 기준)
     **e.g.** 옵션이 `a`,`b`,`c`이고 `b`는 추가적인 인자가 필요하다면 `b` 뒤에 `:`를 사용, `optstring="ab:c"`.

* `argv`에서 옵션 요소(element)를 검색, `optnid`와 함수 내부의 `static 변수 nextchar`(다음 문자(열)를 가리킴)를 이용.
* 반복적으로 수행되며, 모든 옵션을 파싱하면 `-1`을 리턴. `getopt()`의 동작을 초기화하려면 `optind=1`로 설정.
* 인자가 `optstring`에 포함된 옵션(문자)가 아니면 `?`를 리턴하고, 에러를 출력. 그리고 `optopt`에 현재 옵션 인자(문자)를 저장.
* 인자가 `optstring`에 해당하는 옵션이라면, 해당하는 옵션 문자를 리턴. 만일 추가 인자가 필요한 옵션이라면 `optarg`에 추가 인자는 `optarg`에 저장(복제가 아닌, 문자열의 주소를 저장).
* 리턴 값:
  1. 모든 옵션을 파싱하면 `-1`을 리턴.
  2. 해당하는 옵션이 아니면, `?`를 리턴하고 `optopt`에 에러 문자를 저장.
  3. 해당하는 옵션이라며, 해당 옵션 문자를 리턴하고, 추가 인자가 필요한 옵션은 `optarg`에 추가 인자가 저장.
    **e.g.** shell에서 `./a.out -a -b`를 수행한 경우, `a.out`에서 `getopt()`를 수행하면, 처음에 `a`, 두번째에 `b`, 세번째에 `-1` 리턴. 
```c
char c;
while((c=getopt(argc, argv, "hvf:"))==-1)
{
  switch(c)
  {
  case 'h':
    printf("option 'h'");
    break;
  case 'v':
    printf("option 'v'");
    break;
  case 'f':
    printf("option 'f'");
    printf("option argument is %s", optarg);  // f의 추가 인자(argument)
    break;
  case '?':
  default:
    printf("unknown option %c", optopt);
  }
}
```
* Example - getopt_example.c
```c
/* getopt_example.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

// "optarg" and "optopt" are already decleared "getopt.h"

#define OPTFLG_H	0x01
#define OPTFLG_V	0x02
#define OPTFLG_F	0x04

void main(int argc, char* const *argv)
{
	int c;
	unsigned char flags=0x00;
	char farg[128];

	while((c=getopt(argc, argv, "hvf:"))!=-1)
	{
		switch(c)
		{
		case 'h':
			flags|=OPTFLG_H;
			break;
		case 'v':
			flags|=OPTFLG_V;
			break;
		case 'f':
			flags|=OPTFLG_F;
			memset(farg, 0, sizeof(farg));
			memcpy(farg, optarg, strlen(optarg));
			break;
		case '?':
			printf("Unknown flag : %c.\n", optopt);
			break;
		}
	}

	if(flags&OPTFLG_H)
		printf("option 'h'\n");
	if(flags&OPTFLG_V)
		printf("option 'v'\n");
	if(flags&OPTFLG_F)
		printf("option 'f' : %s\n", farg);
}
```
    * 실행 결과 - getopt_example.c
```bash
$ ./a.out -hf abc -v
option 'h'
option 'v'
option 'f' : abc
$ 
```

# getopt_long()
```c
int getopt_long(int argc, char * const argv[], const char *optstring, const struct option *longopts, int *longindex);
```
* it parse short option and long option in a argument vector.
* `getopt()`와 유사하게 동작. 
* `--`로 시작하는 문자열 옵션을 파싱. (GNU extension)
* `--arg=pram` 또는 `--arg pram`처럼 추가 인자를 사용 가능.
* `-`로 시작한 인자인 경우, **short option**이 우선순위가 높음.
* `longopts` : 사용할 `struct option` 배열, **long** 옵션을 정의, `struct option`은 `<getopt.h>`에 정의되어 있음.
```c
struct option {
  const char *name;
  int        has_arg;
  int        *flag;
  int        val;
}
```
* `name` : long 옵션의 이름(문자열). **e.g.** `--arg`이면 `arg`.
* `has_arg` : 추가적인 인자의 사용 유무
  * `no_argument` : defined 0, 추가 인자가 없음. 
  * `required_argument` : defined 1, 추가 인자가 반드시 사용.
  * `optional_argument` : defined 2, 추가 인자가 선택적으로 사용.
* `flag` : `getopt_long()`의 리턴 방법을 지정.
  * `NULL` : `getopt_long()`은 `val`을 리턴. (보통 `val`은 `name`에 해당하는 **short option** 문자)
  * `non-zero` : `getopt_long()`은 `0`을 리턴하고, `val`의 값을 `flag`가 가리키는 변수에 저장. 에러 시, 저장 안함.
* `val` : `getopt_long()`이 리턴하는 값. `flag` 사용시, `flag`가 가리키는 변수에 저장될 값.
  > **option** 구조체 배열 마지막 요소는 모두 0으로 설정되어야 한다.
* `longindex` : `NULL`이면 안됨. 매칭된 옵션이 `longopts`에서 선택된 옵션의 `index`를 저장할 변수의 주소.

* 리턴 값 : 
  1. 모든 옵션을 파싱하면 -1을 리턴.
  2. 해당하는 옵션(**short/long option**)이 아니면, `?`를 리턴하고 `optopt`에 에러 문자를 저장.
   1. 해당하는 옵션이라며, val를 리턴하고, 추가 인자가 필요한 옵션은 `optarg`에 추가 인자가 저장.
   2. `flag`가 지정된 옵션이 매칭하면 `0`을 리턴하고, `flag`가 지정한 변수에 `val`을 저장.

* Example - getopt_long_example.c
```c
/* getopt_long_example.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

#define MAJOR_VER	1 
#define MINOR_VER	0

#define OPTFLG_H	0x01
#define OPTFLG_V	0x02
#define OPTFLG_P	0x04

void help()
{
	printf(
		"-h, --help              print help.\n"
		"-v, --version           print version.\n"
		"-p, --print             print optarg.\n"
		"-d, --debug             print debug message\n"
		);
}

void main(int argc, char* const *argv)
{
	int o, debug=0, optflg=0, optlind=0;
	char arg[128];
	struct option lopts[]={
			{"help", no_argument, 0, 'h'},
			{"version", no_argument, 0, 'v'},
			{"print", required_argument, 0, 'p'},
			{"debug", no_argument, &debug, 1},
			{0, 0, 0, 0}
	};

	while((o=getopt_long(argc, argv, "hvp:", lopts, &optlind))!=-1)
	{
		switch(o)
		{
			case 0:
				break;
			case 'h':
				optflg|=OPTFLG_H;
				break;
			case 'v':
				optflg|=OPTFLG_V;
				break;
			case 'p':
				optflg|=OPTFLG_P;
				memset(arg, 0, sizeof(arg));
				memcpy(arg, optarg, strlen(optarg));
				break;
			case '?':
			default:
				printf("unknown option %c\n", optopt);
		}
	}

	if(debug)
		printf("DEBUG!!!\n");
	if(optflg&OPTFLG_H)
		help();
	if(optflg&OPTFLG_V)
		printf("getopt_long example ver.%d.%d\n", MAJOR_VER, MINOR_VER);
	if(optflg&OPTFLG_P)
		printf("optional argument is \"%s\".\n", arg);
}
```
    * 실행 결과 - getopt_long_example.c
```bash
$ ./a.out --debug -vh --print Hello
DEBUG!!!
-h, --help              print help.
-v, --version           print version.
-p, --print             print optarg.
-d, --debug             print debug message
getopt_long example ver.1.0
optional argument is "Hello".
$ 
```

# getopt_long()
```c
int getopt_long_only(int argc, char * const argv[], const char *optstring, const struct option *longopts, int *longindex);
```
* `getopt_long()`와 거의 동일하게 동작. 
* `getopt_long_only()`에서는 `-`와 `--`로 **long option** 사용.
* `getopt_long_only()`에서는 `-`에 **short option**이 있으면 **long option** 파싱 안됨.
* `getopt_long_only()`에서는 `-`에서 연속된 **short option** 파싱 안됨(하나만 가능).
* **long option**만 사용할거라면, `optstring`을 `""`(double quotation mark pair)로 지정. 
  * `""`은 NULL이 아닌 **empty-string**.

* Example - getopt_long_only_example.c
```c
/* getopt_long_only_example.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

#define MAJOR_VER	1 
#define MINOR_VER	0

#define OPTFLG_H	0x01
#define OPTFLG_V	0x02
#define OPTFLG_P	0x04

void help()
{
	printf(
		"-h, --help              print help.\n"
		"-v, --version           print version.\n"
		"-p, --print             print optarg.\n"
		"-d, --debug             print debug message\n"
		);
}

void main(int argc, char* const *argv)
{
	int o, debug=0, optflg=0, optlind=0;
	char arg[128];
	struct option lopts[]={
			{"help", no_argument, 0, 'h'},
			{"version", no_argument, 0, 'v'},
			{"print", required_argument, 0, 'p'},
			{"debug", no_argument, &debug, 1},
			{0, 0, 0, 0}
	};

	while((o=getopt_long_only(argc, argv, "", lopts, &optlind))!=-1)
	{
		switch(o)
		{
			case 0:
				break;
			case 'h':
				optflg|=OPTFLG_H;
				break;
			case 'v':
				optflg|=OPTFLG_V;
				break;
			case 'p':
				optflg|=OPTFLG_P;
				memset(arg, 0, sizeof(arg));
				memcpy(arg, optarg, strlen(optarg));
				break;
			case '?':
			default:
				printf("unknown option %c\n", optopt);
		}
	}

	if(debug)
		printf("DEBUG!!!\n");
	if(optflg&OPTFLG_H)
		help();
	if(optflg&OPTFLG_V)
		printf("getopt_long example ver.%d.%d\n", MAJOR_VER, MINOR_VER);
	if(optflg&OPTFLG_P)
		printf("optional argument is \"%s\".\n", arg);
}
```
    * 실행 결과 - getopt_long_only_example.c
```bash
$ ./a.out -debug -version --help -print=Hello
DEBUG!!!
-h, --help              print help.
-v, --version           print version.
-p, --print             print optarg.
-d, --debug             print debug message
getopt_long example ver.1.0
optional argument is "Hello".
$ 
```

# Misc.
* `getsubopt()` : `getopt()`, `getopt_long()`으로 파싱된 인자에서 토큰을 기준으로 문자열을 파싱.
* My skeleton code is [here](https://gist.github.com/jgseong/35116de2bcd736412f584786cf268df9).

_References_

1. [Joinc getopt](http://www.joinc.co.kr/w/man/3/getopt)
2. [Wireframe's post](http://soooprmx.com/wp/archives/4993)
