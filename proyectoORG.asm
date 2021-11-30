.model small        ;modelo de memoria
org 100h
.data               ;comienzo del segmento de datos
include "emu8086.inc"  

xor ax,ax
xor bx,bx
xor cx,cx
mov si,0   



;matriz db 6 dup (0)
;       db 6 dup (0)
;       db 6 dup (0)
;       db 6 dup (0)
;       db 6 dup (0)
;       db 6 dup (0)

matrizprueba db ' ','A','B','C','D','E','F'
             db 1,0,0,1,1,1,1
             db 2,0,0,1,1,1,0
             db 3,0,0,0,0,0,0
             db 4,0,0,0,0,0,0
             db 5,0,0,0,0,0,0
             db 6,0,1,1,1,1,1  
             

msg1 db 'BATALLA NAVAL$' 
msg2 db 'Tienes 20 misiles para destruir la flota enemiga$'              
msg3 db 'Presiona ENTER para visualizar el tablero y ubicar los barcos aleatoriamente$'
msg4 db 'Presiono tecla incorrecta, presione ENTER para continuar$'
num db ?  

msgMisil db 'Misil $' 
msgAtacar db ', ingrese la celda a atacar: $' 
contador db ?

linefeed db 13,10,"$"      

msgg1 db 'Numero al azar: $'
numero dw ?, 0ah, 0dh, '$'    


.code               ;comienzo del segmento de codigo
.start              ;inicio de las instrucciones
 


;numalAzar:
;lea dx, msgg1
;mov ah, 9
;int 21h
;Mov ah,2ch
;Int 21h
;xor ax, ax
;mov dh, 00h
;add ax, dx
;aaa
;add ax, 3030h
;mov numero[0], ax
;lea dx, numero
;mov ah, 9
;int 21h  




mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msg1        ;load efective address---> coloca contenido de variable msg1 en dx 
int 21h             ;interrupcion para mostrar contenido de dx en pantalla

mov ah,09h
mov dx, offset linefeed          ;newline
int 21h

mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msg2        ;load efective address---> coloca contenido de variable msg1 en dx 
int 21h 

mov ah,09h
mov dx, offset linefeed          ;newline
int 21h

mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msg3        ;load efective address---> coloca contenido de variable msg1 en dx 
int 21h      

mov ah,09h
mov dx, offset linefeed          ;newline
int 21h

enter:
mov ah,01         ;funcion para captar un caracter por teclado
int 21h
cmp al, 0dh
je limpiar
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msg4        ;load efective address---> coloca contenido de variable msg1 en dx 
int 21h 
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h
jmp enter


limpiar: 
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h
mov si,0 
mov bp,0
jmp imprimir
     
imprimir:
mov ax,0
mov ah,6   
mov dl,0
mov dl,matrizprueba[si]     
cmp dl, 6 
jbe sumar   
jne imprimir2   

imprimir2:
int 21h 
print " "  
inc si 
cmp si,7
je saltolinea
cmp si,14
je saltolinea
cmp si,21
je saltolinea
cmp si,28
je saltolinea  
cmp si,35
je saltolinea 
cmp si,42
je saltolinea
cmp si,49  
jne imprimir 
mov bp,1       ;CONTADOR DE MISILES
je atacar



sumar:
add dl,30h 
jmp imprimir2

saltolinea:
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h 
jmp imprimir

 

atacar: 
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgMisil         
int 21h 
;mov ah, 6
;mov cx,bp
;mov dx,cx    ;contador 
;add dx,30h
;int 21h
cmp bp,10      ;LLEGA HASTA EL MISIL 9   
jae  mayorque9
jne menorque9 
;mov ah, 09h         ;funcion para mostrar cadena de caracteres
;lea dx, msgAtacar         
;int 21h  
;inc bp  
;cmp bp,10      ;LLEGA HASTA EL MISIL 9
;jne atacar  
;je mayoresque9


mayorque9:
mov ah,6
mov dx,cx    ;contador 
add dx,30h
int 21h     
mov ah,6  
mov dx,di    ;contador2 
add dx,30h
int 21h  
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgAtacar         
int 21h 
inc bp 
inc di  
cmp bp,20
jne atacar   
je imprimir20


imprimir20:     
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgMisil         
int 21h 
inc cx 
mov ah,6
mov dx,cx    ;contador 
add dx,30h
int 21h     
mov ah,6 
mov di,0 
mov dx,di    ;contador2 
add dx,30h
int 21h  
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgAtacar         
int 21h   
jmp salir 


menorque9: 
mov ah,6
mov cx,bp
mov dx,cx    ;contador 
add dx,30h
int 21h 
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgAtacar         
int 21h 
inc bp   
mov cx,1  
mov di, 0
jmp atacar

  

salir:
.exit
end