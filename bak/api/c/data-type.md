<!-- TITLE: Data Type -->
<!-- SUBTITLE: Data types for C -->

# Primitive System Data Type

* 소프트웨어의 이식성을 위해 사용자 정의 자료형(정수 자료형)을 사용.
* 플랫폼(platform)마다 자료형(data type)의 크기가 다를 수있음.
  **e.g.** C언어의 기본 자료형 중 `long` 타입은 32-bit Linux gcc 컴파일러에서 **4 bytes**(32-bit), 64-bit Linux gcc 컴파일러에서 **8 bytes**(64-bit).
* 정수 비트 길이와 바이트 길이가 문제가 될 때, `char` 또는 `short`, `int`, `long`, `long long`과 같은 자료형 대신 고정 길이 자료형을 이용. [1]
* **ISO**가 개발한 C 언어 표준 **ISO/IEC 9899**에서는 `char` 또는 `short`, `int`, `long`, `long long`같은 자료형의 길이(비트 길이)에 대한 처리 시스템마다 정의하는 것이 허용되며, 이것은 이식성 문제를 일으킴. [1]
* 1999년에 개정된 **ISO/IEC 9899: 1999**에서도 이 문제의 잠재적인 원인은 해결되지 않았지만, 비트 길이를 고유하게 정의한 자료형이 추가. 이 형식은 `stdint.h`에 정의. [1]

* `# include <stdint.h>`
* [u]intN_t : 요구되는 bit의 길이를 N에 명시하여 사용하며, u는 unsigned.
* 이러한 방식은 C99 표준에 정의.
* Exact-width integer types.
  * Integer types having exactly the specified width
```c
typedef singed char int8_t;                // signed 8-bit integer
typedef unsigned char uint8_t;             // unsigned 8-bit integer
typedef singed int int16_t;                // signed 16-bit integer
typedef unsigned int uint16_t;             // unsigned 16-bit integer
typedef singed long int int32_t;           // signed 32-bit integer
typedef unsigned long int uint32_t;        // unsigned 32-bit integer
typedef singed long long int int64_t;      // signed 64-bit integer
typedef unsigned long long int  uint64_t;  // unsigned 64-bit integer
```

Reference
=====
[1] http://blog.daum.net/_blog/BlogTypeView.do?blogid=09ehJ&articleno=18230429&categoryId=884391&regdt=20100414204400 
[2] http://mgoons.tistory.com/4