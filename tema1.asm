%include "io.inc"

section .data
    %include "input.inc"

    ; caracterele folosite pentru conversie
    characters db "0123456789abcdef", 0

    ; mesajul ce va fi afisat, este initializat in acest
    ; mod pentru a evita probleme cu encoding-ul
    display db "                                   ", 0
    
section .text

global CMAIN
CMAIN:
    mov ebp, esp
    mov esi, 0 ; array index
    xor edx, edx
    xor eax, eax

    ; parcurgem ambele array-uri
	looping_arrays:
    	mov eax, [nums_array + 4 * esi]
    	mov ecx, [base_array + 4 * esi]
    	inc esi ; avansam in ambele array-uri

    	; verificam daca baza data e valida
    	cmp ecx, 2 ; daca baza e mai mica decat 2 -> mesaj de baza incorecta
    	jl invalid_print
    	cmp ecx, 16 ; daca baza e mai mare decat 16 -> mesaj de baza incorecta
    	jg invalid_print
    	; ebx e numarul de impartiri / de caractere din mesajul 
    	; ce va fi afisat
    	mov ebx, 0
    
    	; conversia numarului dat din baza 10 in baza data
    	convert:
        	div ecx ; impartim la baza data
        	; cautam corespondentul restului impartirii
        	; in array-ul de corespondente characters
        	; si adaugam corespondenta restului in
        	; array-ul display, care e nr convertit
        	push dword [characters + edx]
        	pop dword [display + ebx]
        	inc ebx ; crestem numarul de impartiri / caractere ce vor fi
			; afisate in urma conversiei
        	xor edx, edx ; ne asiguram ca merge impartirea
        	cmp eax, 0
        	jnz convert
        
    	; afisarea mesajului / numarului convertit
    	display_converted:
        PRINT_CHAR [display + ebx - 1] ; afisam de la coada array-ului
		; numarul convertit
        dec ebx
        cmp ebx, 0
        jnz display_converted
    	NEWLINE
    	
    	; verificam daca array-urile mai pot fi parcurse
    	cmp esi, [nums] ; daca mai sunt numere continuam conversia
		; altfel programul se inchide
    	jnz looping_arrays 
    	jmp end_program
    
	; mesaj invalid            
	invalid_print:
    	PRINT_STRING "Baza incorecta"
    	NEWLINE
    	cmp esi, [nums] ; verificam daca suntem la ultimul nr
    	jz end_program ; se termina programul
    	jmp looping_arrays ; trecem la nr urmator si baza urmatoare
   
	; programul se termina 
	end_program:
    	xor eax, eax
    	ret
