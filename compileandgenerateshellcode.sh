#!/bin/bash

echo "[+] Enter the file name sir "
read lol
echo "[+] Got it..! Compiling the nasm file..."
echo '[+] Assembling the master piece  with nasm uncles help.....'
nasm -f elf32 -o $lol.o $lol.nasm
echo '[+] Linking Pinking ...'
ld -o $lol $lol.o
echo '[+] Le bhai ho gaya !!!!'
objdump -d $lol -M intel
echo "[+] Let's extract the shellcode in hex format ..."
hexshell=`objdump -d ./$lol|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\\x/g'|paste -d '' -s |sed 's/^/"/' | sed 's/$/"/g'`
echo $hexshell
echo "[+] Pasting shellcode in C program ..."
echo "#include<stdio.h>" >shellcode.c
echo "#include<string.h>" >>shellcode.c
echo "unsigned char code[] = \\" >>shellcode.c
echo $hexshell";" >>shellcode.c
echo "main()" >>shellcode.c
echo "{" >>shellcode.c
echo "printf(\"Shellcode Length:  %d\n\", strlen(code));" >>shellcode.c
echo "  int (*ret)() = (int(*)())code;" >>shellcode.c
echo "  ret();" >>shellcode.c
echo "}" >>shellcode.c
echo "[+] Compiling shellcode.c for executable shellcode...."
gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
echo "[+] Done Sir! Enjoy ;)"
