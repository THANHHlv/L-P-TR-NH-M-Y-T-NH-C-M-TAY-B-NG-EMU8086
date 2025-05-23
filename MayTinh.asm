TITLE CALCULATOR  ; hien ra cai may tinh
.model medium   
.stack
.data

    dev db ,0ah,0dh,'Developed by:$'

    p1 db 'Enter operand 1:$'
    p2 db 'Enter operand 2:$'
    p3 db 'Enter operator (+,-,*,/,^):$'   
         
    num dw ?
    x dw ?
    y dw ?
    num1 dw ?
    num2 dw ?
    tmp dw ?
    ten dw 10
    op_char db ? 
    ;--Label
    crlf db 13, 10, '$' ;0dh, 0ah
    multiplicated db 'MULTIPLIED!$' 
    subbed db 'SUBTRACTED!$'
    added db 'ADDED!$'
     
	undef db 'UNDEFINED$'
    divided db 'DIVIDED!$' 
    
    power db 'POWED!$'
    continue db 'Continue(y/n)?:$'
   
.code                               
main   proc 

  
    mov ax,@data            ; khoi tao thanh ghi
    mov ds,ax
    
    jmp screen              ; nhay toi man hinh

Lap1:                       ; nhap so dau tien
    
	mov ah,2
	mov bh,0
	mov dh,2                ; di chuyen con tro ve dong dau
	mov dl,25               ; hang 2 o 25
	int 10h
	
    mov ah,9
    mov dx,offset p1        ; hien thi operand 1:$
    int 21h         
    
    call nhapSo             ; ham nhap so no se tra ve ax
   
    mov num1, ax
    mov ax, 0
    call endl               ; goi ham xuong dong
    
Lap2 :                      ; nhap so thu 2
	
	mov ah,2
	mov bh,0
	mov dh,3                ; chuyen xuong dong 3 o 25
	mov dl,25
	int 10h
    
    
    mov ah,9
    mov dx,offset p2        ; in ra so thu 2
    int 21h
             
    call nhapSo
   
    mov num2, ax 
    mov ax, 0               ; tra ve 0
    call endl               ; goi ham xuong dong
	
operator: ;--- Select Operator 
        
    mov ah,2
	mov bh,0
	mov dh,4                ; chuyen den dong 4 cot 25
	mov dl,25
	int 10h
	
	mov ah,09h
    mov dx,offset p3        ; in ra title cua toan tu
	int 21h 
	
	mov ah,01h              ; nhap ki tu
	int 21h                 ; khi nhap ki tu no se luu vao al 
	
	 
	mov cl, al 
	mov op_char, al
	mov ah,02h              ; chuyen ki tu do vao cl
	mov dl,0Ah              ; chuyen con tro toi dau dong
	int 21h
     
     
    ;--- Directory for the operands
    cmp cl, '*'
	je multiplication
	
	cmp cl, '/'
	je division
	
	cmp cl, '+'             ; so sanh voi cac ki tu
	je addition
	
	cmp cl, '-'
	je subtraction
	
	cmp cl, '^'
	je Pow

multiplication:   
    mov ah,2
	mov bh,0
	mov dh,5                ; xuong dong 5 cot 25
	mov dl,25
	int 10h
	 
    call inBieuThuc
    
    mov ax, num1
    mov bx, num2 
    mul bx                  ; ax = ax * bx
    
    call inSo
     
	mov ah,2
	mov bh,0
	mov dh,6
	mov dl,25               ; xuong dong 6 de in multipiled
	int 10h
	
    mov ah,9
    mov dx,offset multiplicated
	int 21h
    jmp getInp
    
addition:   
	mov ah,2
	mov bh,0
	mov dh,5                ; xuong dong 5 cot 25
	mov dl,25
	int 10h
	
    call inBieuThuc
	
	mov ax, num1            
	add ax, num2            ; ax = ax + num2
	
	call inSo               ; in ra ax
	
	mov ah,2
	mov bh,0
	mov dh,6
	mov dl,25
	int 10h
	
    mov ah,9
    mov dx,offset added
	int 21h
    jmp getInp

subtraction: 
    mov ah,2
	mov bh,0
	mov dh,5                ; xuong dong 5 o 25 
	mov dl,25
	int 10h 
	
    call inBieuThuc
    
    mov ax, num1
    mov bx, num2 
    
    sub ax, bx              ; ax = ax - bx
    call inSo
	
    mov ah,2
	mov bh,0
	mov dh,6
	mov dl,25
	int 10h
    
    mov ah,9
    mov dx,offset subbed
	int 21h
	
    jmp getInp  ; continue(y/n)

division:
	mov ah,2
	mov bh,0
	mov dh,5                ; xuong dong 5
	mov dl,25
	int 10h
	
    call inBieuThuc
    
    mov ax, num1
    mov bx, num2 

    cmp bx, 0
    je chia_cho_0           ; chia cho 0 thi thong bao
     
    mov cx, 0
    
    cmp ax, 0               ; check num1
    jns check_num2          ; neu >= 0
    neg ax                  ; chuyen ax âm
    inc cx
    
    check_num2:
        cmp bx, 0
        jns pre_div
        neg bx              ; chuyen bx am
        xor cx, 1           ; neu le 1 thi ket qua la am -
        mov num2, bx        ; chuyen bx lai vao num2 de còn tính phan thap phan
        
    pre_div:
        cmp cx, 0
        jz  DIVIDE          ; nhau neu = 0 
        
        push ax             ; luu ax vao stack de sau su dung
        mov ah, 02h
        mov dl, '-'         ; neu am in dau -
        int 21h 
        
        pop ax
        
    DIVIDE: 
        mov dx, 0
        div bx              ; ax = thuong, dx = du 
        
        push dx
        call inSo
    
        mov ah, 02h
        mov dl, '.'         ; in dau .
        int 21h                   
    
        pop ax
        call print_decimal  ; in phan thap phan

    
    ;--- thong bao DIVIDED! ---
    mov ah, 2
    mov bh, 0
    mov dh, 6
    mov dl, 25
    int 10h

    mov ah, 9
    mov dx, offset divided
    int 21h

    jmp getInp

chia_cho_0:
    ;--- chia cho 0 ---
    mov ah, 2
    mov bh, 0
    mov dh, 5
    mov dl, 25
    int 10h

    mov ah, 9
    mov dx, offset undef    ; ko xac dinh
    int 21h

    jmp getInp

Pow:
    mov ah,2
	mov bh,0
	mov dh,5                ; xuong dong 5 o 25 
	mov dl,25
	int 10h

    call inBieuThuc
    
	mov ax, 1
	mov bx, num1
	mov cx, num2
	cmp cx, 0
	jl mu_am
	poww:
	    mul bx
	    loop poww
	call inSo
	
	mov ah, 2
    mov bh, 0
    mov dh, 6
    mov dl, 25
    int 10h

    mov ah, 9
    mov dx, offset power
    int 21h
	
	jmp getInp

mu_am:
    ;--- chia cho 0 ---
    mov ah, 2
    mov bh, 0
    mov dh, 5
    mov dl, 25
    int 10h

    mov ah, 9
    mov dx, offset undef  ; ko xac dinh
    int 21h

    jmp getInp    
    	
getInp:	;-- Get Yes or No From User

    mov ah,2
	mov bh,0
	mov dh,8
	mov dl,25
	int 10h
	
    mov ah,9
   	mov dx,offset continue
   	int 21h
	mov ah,1   ; get input for continying
	int 21h    ; al='y/n'

	cmp al,'y'  ; Check if Yes or No
	je screen
	cmp al,'Y'
	je screen
	cmp al,'n'
	je exit
	cmp al,'N'
	je exit
	jmp getInp      


screen:
    mov ah,6
    mov al,0
    mov bh,01111111b
    mov ch,0
    mov cl,0
    mov dh,24
    mov dl,80
    int 10h
	
;mov ah,6 ;bg inside box -black box - screen
	mov al,0
	mov bh,00001110b
	mov ch,2 ;--- start  ng box sa taas
	mov cl,25 ;--- start ng box sa left
	mov dh,9 ;--- eto yung pahaba starting sa baba
	mov dl,58 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad 
	mov al,0
	mov bh,00001110b
	mov ch,11 ;--- start  ng box sa taas
	mov cl,25 ;--- start ng box sa left
	mov dh,13 ;--- eto yung pahaba starting sa baba
	mov dl,30 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad 
	mov al,0
	mov bh,00001110b
	mov ch,11 ;--- start  ng box sa taas
	mov cl,32 ;--- start ng box sa left
	mov dh,13 ;--- eto yung pahaba starting sa baba
	mov dl,37 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad 
	mov al,0
	mov bh,00001110b
	mov ch,11 ;--- start  ng box sa taas
	mov cl,39 ;--- start ng box sa left
	mov dh,13 ;--- eto yung pahaba starting sa baba
	mov dl,44 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad 
	mov al,0
	mov bh,00001110b
	mov ch,11 ;--- start  ng box sa taas
	mov cl,46 ;--- start ng box sa left
	mov dh,13 ;--- eto yung pahaba starting sa baba
	mov dl,51 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,11 ;--- start  ng box sa taas
	mov cl,53 ;--- start ng box sa left
	mov dh,13 ;--- eto yung pahaba starting sa baba
	mov dl,58 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,15 ;--- start  ng box sa taas
	mov cl,25 ;--- start ng box sa left
	mov dh,17 ;--- eto yung pahaba starting sa baba
	mov dl,30 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,15 ;--- start  ng box sa taas
	mov cl,32 ;--- start ng box sa left
	mov dh,17 ;--- eto yung pahaba starting sa baba
	mov dl,37 ; --- eto yung sa pahaba sa right
	int 10h
;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,15 ;--- start  ng box sa taas
	mov cl,39 ;--- start ng box sa left
	mov dh,17 ;--- eto yung pahaba starting sa baba
	mov dl,44 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,15 ;--- start  ng box sa taas
	mov cl,46 ;--- start ng box sa left
	mov dh,17 ;--- eto yung pahaba starting sa baba
	mov dl,51 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,15 ;--- start  ng box sa taas
	mov cl,53 ;--- start ng box sa left
	mov dh,17 ;--- eto yung pahaba starting sa baba
	mov dl,58 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,19 ;--- start  ng box sa taas
	mov cl,25 ;--- start ng box sa left
	mov dh,21 ;--- eto yung pahaba starting sa baba
	mov dl,30 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,19 ;--- start  ng box sa taas
	mov cl,32 ;--- start ng box sa left
	mov dh,21 ;--- eto yung pahaba starting sa baba
	mov dl,37 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,19 ;--- start  ng box sa taas
	mov cl,39 ;--- start ng box sa left
	mov dh,21 ;--- eto yung pahaba starting sa baba
	mov dl,44 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,19 ;--- start  ng box sa taas
	mov cl,46 ;--- start ng box sa left
	mov dh,21 ;--- eto yung pahaba starting sa baba
	mov dl,51 ; --- eto yung sa pahaba sa right
	int 10h

;mov ah,6 ;bg inside box --- number pad -- 
	mov al,0
	mov bh,00001110b
	mov ch,19 ;--- start  ng box sa taas
	mov cl,53 ;--- start ng box sa left
	mov dh,21 ;--- eto yung pahaba starting sa baba
	mov dl,58 ; --- eto yung sa pahaba sa right
	int 10h

;--- numbers (1)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,12
	mov dl,27
	int 10h

	mov ah,2    ;display char 
	mov dl,31h
	int 21h

;--- numbers (2)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,12
	mov dl,34
	int 10h

	mov ah,2    ;display char 
	mov dl,32h
	int 21h

;--- numbers (3)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,12
	mov dl,41
	int 10h

	mov ah,2    ;display char 
	mov dl,33h
	int 21h	
;--- numbers (4)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,16
	mov dl,27
	int 10h

	mov ah,2    ;display char 
	mov dl,34h
	int 21h	

;--- numbers (5)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,16
	mov dl,34
	int 10h

	mov ah,2    ;display char 
	mov dl,35h
	int 21h	


;--- numbers (6)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,16
	mov dl,41
	int 10h

	mov ah,2    ;display char 
	mov dl,36h
	int 21h	

;--- numbers (7)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,20
	mov dl,27
	int 10h

	mov ah,2    ;display char 
	mov dl,37h
	int 21h	

;--- numbers (8)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,20
	mov dl,34
	int 10h

	mov ah,2    ;display char 
	mov dl,38h
	int 21h	

;--- numbers (9)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,20
	mov dl,41
	int 10h

	mov ah,2    ;display char 
	mov dl,39h
	int 21h	

;--- numbers (0)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,20
	mov dl,48
	int 10h

	mov ah,2    ;display char 
	mov dl,30h
	int 21h	

;--- operators (+)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,12
	mov dl,48
	int 10h

	mov ah,2    ;display char 
	mov dl,2bh
	int 21h	

;--- operators (-)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,12
	mov dl,55
	int 10h

	mov ah,2    ;display char 
	mov dl,2dh
	int 21h	

;--- operators (*)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,16
	mov dl,48
	int 10h

	mov ah,2    ;display char 
	mov dl,2ah
	int 21h	

;--- operators (/)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,16
	mov dl,55
	int 10h

	mov ah,2    ;display char 
	mov dl,2fh
	int 21h

;--- operators (=)
	mov ah,2   ; set cursor 
	mov bh,0
	mov dh,20
	mov dl,55
	int 10h

	mov ah,2    ;display char 
	mov dl,94
	int 21h	
	
	jmp Lap1

     
exit: 	
    mov ah,4ch
	int 21h
           
main endp

nhapSo proc
    mov x, 0                ; luu ket qua
    mov y, 0                ; luu tung chu so
    mov cx, 0               ; cx = 1 l so am
    mov bx, 10              ; de x10
        nhap:
            mov ah, 1       ; nhap ki tu
            int 21h         ; dung nhap
             
            cmp al, '-'     ; kiem tra so am   
            jne CheckEnter
            mov cx, 1
            jmp nhap
            
        CheckEnter:
            cmp al, 13          ; kiem tra xuong dong
            je nhapXong           
            
            sub al,'0'          ; chuyen thanh so
            mov ah, 0           ; tra ve = 0
            mov y, ax                    
            
            mov ax, x           ; truyen x vao ax
            mul bx              ; ax  = ax * bx = ax * 10
            add ax, y           ; x * 10 + y
            
            mov x, ax           ; tra ve x
            jmp nhap
            
        nhapXong:
            mov ax, x  
            cmp cx, 1           ; kiem tra so am
            jne endNhap
            neg ax              ; dao dau
    
    endNhap:         
        ret  ; tra ve ax 
    
nhapSo endp

inBieuThuc proc
    ; in num1
    mov ax, num1
    call inSo
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    ; in toan tu
    mov ah, 02h     
    mov dl, op_char      ; toan tu
    int 21h
    mov ah, 02h
    mov dl, ' '
    int 21h

    ; in num2
    mov ax, num2
    call inSo
    mov ah, 02h
    mov dl, ' '
    int 21h

    ; in =
    mov ah, 02h     
    mov dl, '='
    int 21h
    mov ah, 02h
    mov dl, ' '
    int 21h
    ret
inBieuThuc endp


endl proc
    mov ah, 02h
    mov dl, 0Dh   ; CR
    int 21h
    mov dl, 0Ah   ; LF    ; hieu don gian xuong 
    int 21h
    ret
endl endp

inSo proc
    mov cx, 0
    mov bx, 10
    cmp ax, 0           ; kiem tra so am
    jl dao_dau
    jmp lap
    
    dao_dau: 
        push ax         ; luu ax vao stack de sau su dung
        mov ah, 02h
        mov dl, '-'
        int 21h  
        
        pop ax          ; khoi phuc gia tri goc cua ax
        neg ax          ; dao dau
        
    Lap:
        mov dx, 0       ; khi chia bx
        div bx          ; la minh lay ax / bx       
        push dx         ; lay phan du        
        inc cx          ; tang cx
        
        cmp ax, 0    
        jg lap          
    
    hienthi:            
        pop dx          ; push pop phai ax, dx, cx, bx 16 bit
        add dl, '0'     ; chuyen thanh ky tu
        mov ah, 02h
        int 21h
        loop hienthi    ; vong lap
        
        ret
    
inSo endp 

print_decimal proc
    mov cx, 9
    
    decimal_loop:
        mov bx, num2        ; lay so chia
        mul ten             ; nhan phan du voi 10
        div bx              ; ax / bx
        push dx             ; day phan du vao stack
                                         
        add al, '0'         ; chuy thanh ki tu de in ra
        mov dl, al
        mov ah, 2
        int 21h
        
        pop ax              ; lay phan du
        
        cmp ax, 0
        je end_decimal      ; neu so du = 0 thì ket thuc
        
        loop decimal_loop
        jmp decimal_done
        
    end_decimal:
        
        dec cx              ;da in 1 cs
        jcxz decimal_done   ;in du 9 cs thi ket thuc
        
    decimal_done:
        ret
print_decimal endp
    
end main