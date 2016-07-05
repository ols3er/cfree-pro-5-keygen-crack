
      .486                                      
      .model flat, stdcall                      
      option casemap :none  

  		calcRegChar proto :dword
		findChar    proto :dword
		strlen      proto :dword
		CalcRegKeyWithMU proto :dword,:dword
		CalcMUWithRegKey proto :dword,:dword
		regUserMailCalc proto :dword,:dword,:dword,:dword
		.const
		masks	DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 000h, 03Eh, 000h, 000h, 000h, 03Fh
			DB 034h, 035h, 036h, 037h, 038h, 039h, 03Ah, 03Bh
			DB 03Ch, 03Dh, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 001h, 002h, 003h, 004h, 005h, 006h
			DB 007h, 008h, 009h, 00Ah, 00Bh, 00Ch, 00Dh, 00Eh
			DB 00Fh, 010h, 011h, 012h, 013h, 014h, 015h, 016h
			DB 017h, 018h, 019h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 01Ah, 01Bh, 01Ch, 01Dh, 01Eh, 01Fh, 020h
			DB 021h, 022h, 023h, 024h, 025h, 026h, 027h, 028h
			DB 029h, 02Ah, 02Bh, 02Ch, 02Dh, 02Eh, 02Fh, 030h
			DB 031h, 032h, 033h, 0A9h, 0ACh, 0B5h, 0DBh, 001h
			DB 002h, 001h, 001h, 009h, 003h, 005h, 000h, 009h
			DB 008h, 001h, 001h, 009h, 000h, 007h, 065h, 072h
			DB 072h, 06Fh, 072h, 031h, 03Ah, 020h, 025h, 073h
			DB 02Ch, 020h, 025h, 064h, 00Ah, 000h, 065h, 072h
			DB 072h, 06Fh, 072h, 032h, 03Ah, 020h, 025h, 073h
			DB 02Ch, 020h, 025h, 064h, 00Ah, 000h, 000h, 000h
			DB 063h, 03Ah, 05Ch, 000h, 063h, 03Ah, 05Ch, 000h
			DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			DB 000h, 000h, 000h, 000h, 057h, 067h, 000h, 000h
			DB 05Ch, 068h, 065h, 06Ch, 070h, 068h, 061h, 06Eh
			DB 064h, 06Ch, 065h, 02Eh, 064h, 06Ch, 06Ch, 000h
			DB 000h, 048h, 074h, 06Dh, 06Ch, 048h, 065h, 06Ch
			DB 070h, 048h, 061h, 06Eh, 064h, 06Ch, 065h, 000h
			DB 062h, 061h, 073h, 069h, 063h, 05Fh, 073h, 074h
			DB 072h, 069h, 06Eh, 067h, 000h, 000h, 000h, 000h
				
	      .data
			MASKLEN  EQU  18*8
			OFF_AE98 EQU offset masks
			OFF_AF13 EQU offset masks+7bh
			buffer    BYTE 256 dup(0)
			outbuffer BYTE  80  dup(0)
			msg       BYTE "Cfree5.0注册机 Cracked By ZhangYiDa",0,0
	      .code 
      
	LibMain proc hInstDLL:DWORD, reason:DWORD, unused:DWORD       
	    mov eax, 1
	    ret
	LibMain Endp
	CalcRegKeyWithMU proc lpstr:dword,lpbuffer:dword
			invoke strlen,lpstr
			mov cl,3
			div cl
			.if ah!=0
				inc al
			.endif
			movzx ecx,al
			xor eax,eax
			mov esi,lpstr
			mov edi,lpbuffer
			.while ecx
				shl eax,24
				mov ebx,dword ptr[esi]
				bswap ebx
				add esi,3
				shr ebx,8
	      		or eax,ebx
	      		invoke calcRegChar,eax
	      		;bswap ebx
	      		mov dword ptr[edi],ebx
	      		add edi,4
	      		dec ecx
			.endw
			mov dword ptr[edi],0
			ret
	CalcRegKeyWithMU endp
	
	strlen proc lpstr:dword
		xor ecx,ecx
		xor eax,eax
		mov edi,lpstr
		@@:
		mov al,byte ptr[edi]
		inc ecx
		inc edi
		cmp al,0
		jne @b
		mov eax,ecx
		dec eax
		ret
	strlen endp
	
	CalcMUWithRegKey proc lpregkey:dword,lpbuffer:dword
		invoke strlen,lpregkey
		invoke regUserMailCalc,lpregkey,eax,lpbuffer,OFF_AF13
		ret
	CalcMUWithRegKey endp
	
	calcRegChar proc rvalue:dword
		LOCAL xret:dword
		LOCAL cret:dword
			pushad
			mov eax,rvalue	
			mov edi,eax
			shr edi,24
			mov esi,OFF_AF13
			xor ebx,ebx
			xor edx,edx
			.repeat
				shl ebx,8
				mov ecx,eax
				shl eax,8
				shr ecx,16
				xor cl,byte ptr[edi+esi]
				or bl,cl
				inc edi
				inc edx
				.if edi==4
					xor edi,edi
				.endif
			.until edx>=3
			mov xret,edi
			mov edx,ebx
			mov ecx,04h
			xor edi,edi
			.while ecx
				mov ebx,edx
				shl edi,08h
				shr edx,06h
				and ebx,03fh
				invoke findChar,ebx
				or edi,eax
				dec ecx
			.endw
			mov cret,edi
			popad
			mov eax,xret
			mov ebx,cret
			ret
	calcRegChar endp
	
	
	findChar proc bit6c:dword
		LOCAL xret:dword
		pushad
		mov esi,offset masks
		assume esi:ptr byte
		mov ecx,MASKLEN
		mov eax,bit6c
		.while ecx!=0
			.break .if [esi]==al
			inc esi
			dec ecx
		.endw
		sub esi,OFF_AE98
		mov xret,esi
		popad
		assume esi:nothing
		mov eax,xret
		ret
	findChar endp
	
regUserMailCalc proc rc:dword,rclen:dword,outumbuffer:dword,ptrmaskstab13:dword
			LOCAL  local1:dword
			LOCAL  local2:dword
			LOCAL  local3:dword
			LOCAL  ptrumbuffer:dword

		  mov     eax, rc                           
		  mov     ecx, rclen                            
		  mov     edx, ptrmaskstab13  
		  .if  byte ptr[eax+ecx-1h]==0h
		  		dec     rclen
		  .endif
		  test edx,edx
		  .if ZERO?   
		  	mov local1,OFF_AF13
		  .else
		  	mov local1,edx
		  .endif
		  mov local3,0h
  		  mov edx,eax
  		  mov eax,outumbuffer
  		  mov ptrumbuffer,eax
  		  .while byte ptr[edx]!=3dh&&rclen>0
  		  	.break .if byte ptr[edx]>=7bh
  		  	mov local2,3
  		  	xor ebx,ebx
  		  	xor eax,eax
  		  	;循环从注册码中提取四个字节,并将四个字节分别映射出ecx+OFF_AE98的数值
  		  	;保存到ebx,每六位一组,
  		  	.repeat
  		  		shl ebx,6
  		  		xor ecx,ecx
  		  		mov cl,byte ptr[edx] 
  		  		.if cl==3dh           
  		  			;如果字符是=号,那么local2=--eax;
  		  			movsx ecx,byte ptr[ecx+OFF_AE98]
  		  			or ebx,ecx
  		  			dec eax
  		  			mov local2,eax
  		  			.break
  		  		.endif
  		  		.if rclen<=0h||cl<7bh 
  		  			movsx ecx,byte ptr[ecx+OFF_AE98]
  		  			or ebx,ecx
  		  			inc edx
  		  			dec rclen
  		  		.endif
  		  		inc eax
  		  	.until eax>=4
  		  	.if local2==1
  		  		shl ebx,6
  		  	.endif
  		  	and ebx,0ffffffh
  		  	xor eax,eax
  		  	.continue .if eax>=local2
			.repeat
				mov ecx,2
				mov esi,ebx
				sub ecx,eax
				mov edi,local3
				shl ecx,3 ;ecx=16
				sar esi,cl ;ebx>>16
				mov ecx,esi ;ecx = ebx
				mov esi,local1
				and cl,0ffh
				xor cl,byte ptr[edi+esi]
				mov esi,ptrumbuffer
				mov byte ptr[esi],cl
				inc local3
				inc ptrumbuffer
				.if local3==4
					;xor ecx,ecx
					mov local3,0
				.endif
				inc eax
			.until eax>=local2
  		  .endw
  		mov esi,ptrumbuffer
  		mov word ptr[esi],0
  		ret
regUserMailCalc endp

	end LibMain
