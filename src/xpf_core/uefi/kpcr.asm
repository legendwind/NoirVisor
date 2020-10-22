; NoirVisor - Hardware-Accelerated Hypervisor Solution
;
; Copyright 2018-2020, Zero Tang. All rights reserved.
;
; This file saves processor states for UEFI.
;
; This program is distributed in the hope that it will be successful, but
; without any warranty (no matter implied warranty of merchantability or
; fitness for a particular purpose, etc.).
;
; File location: ./xpf_core/uefi/kpcr.asm

section .text

%ifdef _amd64

bits 64

noir_get_segment_attributes:
	
	and rdx,0fff8h
	add rcx,rdx
	mov ax,word[rcx+5]
	and ax,0f0ffh
	ret

global noir_save_processor_state
noir_save_processor_state:

	; Function start. Initialize shadow space on stack.
	sub rsp,20h
	push rbx
	mov rbx,rcx

	; Initialize the Structure with zero.
	push rdi
	cld
	mov rdi,rcx
	mov rcx,2ch
	xor rax,rax
	rep stosq
	pop rdi
	
	; Save cs,ds,es,fs,gs,ss Selectors
	mov word[rbx],cs
	mov word[rbx+10h],ds
	mov word[rbx+20h],es
	mov word[rbx+30h],fs
	mov word[rbx+40h],gs
	mov word[rbx+50h],ss

	; Save cs,ds,es,fs,gs,ss Limits
	lsl eax,word[rbx]
	mov dword[rbx+04h],eax
	lsl eax,word[rbx+10h]
	mov dword[rbx+14h],eax
	lsl eax,word[rbx+20h]
	mov dword[rbx+24h],eax
	lsl eax,word[rbx+30h]
	mov dword[rbx+34h],eax
	lsl eax,word[rbx+40h]
	mov dword[rbx+44h],eax
	lsl eax,word[rbx+50h]
	mov dword[rbx+54h],eax

	; Save Task Register State
	str word[rbx+60h]
	lsl eax,word[rbx+60h]
	mov dword[rbx+64h],eax

	; Save Global Descriptor Table Register
	sgdt [rbx+76h]
	shr dword[rbx+74h],16

	; Save Interrupt Descriptor Table Register
	sidt [rbx+86h]
	shr dword[rbx+84h],16
	
	; Save Segment Attributes - CS
	mov rcx,qword[rbx+78h]
	mov dx,word[rbx]
	call noir_get_segment_attributes
	mov word[rbx+2h],ax

	; Save Segment Attributes - DS
	mov rcx,qword[rbx+78h]
	mov dx,word[rbx+10h]
	call noir_get_segment_attributes
	mov word[rbx+12h],ax

	; Save Segment Attributes - ES
	mov rcx,qword[rbx+78h]
	mov dx,word[rbx+20h]
	call noir_get_segment_attributes
	mov word[rbx+22h],ax

	; Save Segment Attributes - FS
	mov rcx,qword[rbx+78h]
	mov dx,word[rbx+30h]
	call noir_get_segment_attributes
	mov word[rbx+32h],ax

	; Save Segment Attributes - GS
	mov rcx,qword[rbx+78h]
	mov dx,word[rbx+40h]
	call noir_get_segment_attributes
	mov word[rbx+42h],ax

	; Save Segment Attributes - SS
	mov rcx,qword[rbx+78h]
	mov dx,word[rbx+50h]
	call noir_get_segment_attributes
	mov word[rbx+52h],ax

	; Save Segment Attributes - TR
	mov rcx,qword[rbx+78h]
	mov dx,word[rbx+60h]
	call noir_get_segment_attributes
	mov word[rbx+62h],ax

	; Save Segment Base of TR
	mov rcx,qword[rbx+78h]
	mov ax,word[rbx+60h]
	and rax,0fff8h
	add rcx,rax
	xor edx,edx
	mov dx,word[rcx+2]
	xor eax,eax
	or rax,rdx
	xor edx,edx
	mov dl,byte[rcx+4]
	shl edx,16
	or rax,rdx
	xor edx,edx
	mov dl,byte[rcx+7]
	shl edx,24
	or rax,rdx
	mov edx,dword[rcx+8]
	shl rdx,32
	or rax,rdx
	mov qword[rbx+68h],rax

	; Save LDT Register Selector
	sldt word[rbx+90h]

	; Save Control Registers
	mov rax,cr0
	mov qword[rbx+0a0h],rax
	mov rax,cr2
	mov qword[rbx+0a8h],rax
	mov rax,cr3
	mov qword[rbx+0b0h],rax
	mov rax,cr4
	mov qword[rbx+0b8h],rax
	mov rax,cr8
	mov qword[rbx+0c0h],rax

	; Save Debug Registers
	mov rax,dr0
	mov qword[rbx+0c8h],rax
	mov rax,dr1
	mov qword[rbx+0d0h],rax
	mov rax,dr2
	mov qword[rbx+0d8h],rax
	mov rax,dr3
	mov qword[rbx+0e0h],rax
	mov rax,dr6
	mov qword[rbx+0e8h],rax
	mov rax,dr7
	mov qword[rbx+0f0h],rax

	; Save Model Specific Registers
	; Save SysEnter_CS
	mov ecx,174h
	rdmsr
	mov dword[rbx+0f8h],eax
	mov dword[rbx+0fch],edx

	; Save SysEnter_ESP
	inc ecx
	rdmsr
	mov dword[rbx+100h],eax
	mov dword[rbx+104h],edx

	; Save SysEnter_EIP
	inc ecx
	rdmsr
	mov dword[rbx+108h],eax
	mov dword[rbx+10ch],edx

	; Save Debug Control MSR
	mov ecx,1d9h
	rdmsr
	mov dword[rbx+110h],eax
	mov dword[rbx+114h],edx

	; Save PAT
	mov ecx,277h
	rdmsr
	mov dword[rbx+118h],eax
	mov dword[rbx+11ch],edx

	; Save EFER
	mov ecx,0c0000080h
	rdmsr
	mov dword[rbx+120h],eax
	mov dword[rbx+124h],edx

	; Save STAR
	inc ecx
	rdmsr
	mov dword[rbx+128h],eax
	mov dword[rbx+12ch],edx

	; Save LSTAR
	inc ecx
	rdmsr
	mov dword[rbx+130h],eax
	mov dword[rbx+134h],edx

	; Save CSTAR
	inc ecx
	rdmsr
	mov dword[rbx+138h],eax
	mov dword[rbx+13ch],edx

	; Save SFMASK
	inc ecx
	rdmsr
	mov dword[rbx+144h],edx
	mov dword[rbx+140h],eax

	; Save FS Base
	mov ecx,0c0000100h
	rdmsr
	shl rdx,32
	or rdx,rax
	mov qword[rbx+148h],rdx	; Save to MSR-State Area
	mov qword[rbx+38h],rdx	; Save to Segment State Area

	; Save GS Base
	inc ecx
	rdmsr
	shl rdx,32
	or rdx,rax
	mov qword[rbx+150h],rdx	; Save to MSR-State Area
	mov qword[rbx+48h],rdx	; Save to Segment State Area

	; Save GS Swap
	inc ecx
	rdmsr
	mov dword[rbx+158h],eax
	mov dword[rbx+15ch],edx

	; MSR Saving is Over
	pop rbx
	; Function end. Finalize shadow space on stack.
	add rsp,20h
	ret

global noir_xsetbv:

	mov eax,edx
	shr rdx,32
	xsetbv
	ret

%endif