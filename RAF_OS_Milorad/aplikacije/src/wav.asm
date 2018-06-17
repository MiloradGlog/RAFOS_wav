
    %include "OS_API.inc"                   
    PocetakFajla equ app_main + 1000h      

    org app_main                           
	
Start:
        cmp     byte [arg1], 0              
        jne     .ZadatoIme
        mov     si, NijeZadatoIme           
        call    _print_string
        ret

.ZadatoIme:
		mov     ax, arg1			;stavlja se arg1 u ax
        call    _file_exists                
        jc     .NePostoji
        jmp    .Ucitaj
    
.NePostoji:                                 
        mov     si, NePostojiDat
        call    _print_string
		ret
		
.Ucitaj:								
        mov     cx, PocetakFajla           ;pocetak u cx
        call    _load_file					;load sa ax=arg1 i cx=pocetakfajla
		mov		word [Velicina], bx
		mov		bx, PocetakFajla
		mov		cx, word [Velicina]
		
		;test
		push ax
		mov 	al, cl
        mov     ah, 0Eh			
        int     10h
		mov 	al, ch
		int 	10h
		
		pop ax
		
		mov     si, OtvorioFajl
		call	_print_string
		
		
.Petlja:

		; port 220+0ch komandom out
		
		; vrti pocetakfajla + pointer
		; kad dodje do velicine fajla idi na kraj
		
		mov dx, 220h
		add dx, 0Ch
		
		mov al, 10h
		out dx, al

		
		; slanje podatka
		mov si, [Pointer]
		mov al, [PocetakFajla + si]
		out dx, al
		
;		mov cx, 400
;		.delay:
;			nop
;			loop .delay

		inc word [Pointer]
		cmp word [Pointer], 51529
		jb .Petlja
			
		jmp .Kraj

.Kraj:
	ret
		


	Pointer 	dw 0
	Velicina		dw 0
	
	NijeZadatoIme   db 10, 13, 'Nije zadato ime datoteke.', 13, 10, 0
	NePostojiDat	db 10, 13, 'Datoteka ne postoji.', 13, 10, 0
	OtvorioFajl		db 10, 13, 'Otvorio fajl', 13, 10, 0	
		
	;File:		incbin "sample.wav" 	
		