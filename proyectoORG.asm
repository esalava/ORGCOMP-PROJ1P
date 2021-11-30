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
             db 1,5,0,4,4,4,4
             db 2,5,0,3,3,3,0  
             db 3,5,0,0,0,0,0
             db 4,5,0,0,0,0,0
             db 5,5,0,0,0,0,0
             db 6,0,0,0,0,0,0  
             

msg1 db 'BATALLA NAVAL$' 
msg2 db 'Tienes 20 misiles para destruir la flota enemiga$'              
msg3 db 'Presiona ENTER para visualizar el tablero y ubicar los barcos aleatoriamente$'
msg4 db 'Presiono tecla incorrecta, presione ENTER para continuar$'  

msgMisil db 'Misil $' 
msgAtLetra db ', ingrese la celda (LETRA) a atacar: $'  
msgAtNum db   'ingrese la celda (NUMERO) a atacar: $'
contador db ?   

msgImpacto db  'Impacto confirmado$'
msgNoImpacto db  'Sin impacto $' 

linefeed db 13,10,"$"      

msgg1 db 'Numero al azar: $'
numero dw ?, 0ah, 0dh, '$'

num db ?
letra db ?    

;Variables de comprobacion para saber si un barco fue hundido
recorrido_tres db 3
recorrido_cuatro db 4
recorrido_cinco db 5


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
jmp imprimir     ;JMP IMPRIMIR
     
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
mov si,0    
cmp bp,10      ;LLEGA HASTA EL MISIL 9   
jae  mayorque9
jne menorque9 



mayorque9:
cmp bp,20 
jae salir 
mov ah,6
mov dx,cx    ;contador 
add dx,30h
int 21h     
mov ah,6   
mov dx,0
mov dx,di    ;contador2 
add dx,30h
int 21h  
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgAtLetra         
int 21h 
mov ah,01         ;funcion para captar un caracter por teclado
int 21h 
inc di    
jmp comparar



menorque9: 
mov ah,6
mov cx,bp
mov dx,cx    ;contador 
add dx,30h
int 21h 
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgAtLetra         
int 21h 
mov ah,01         ;funcion para captar un caracter por teclado
int 21h 
mov di,0
jmp comparar    

comparar:
cmp al, 'A' 
je sumarA
cmp al, 'B' 
je sumarB
cmp al, 'C' 
je sumarC 
cmp al, 'D' 
je sumarD 
cmp al, 'E' 
je sumarE 
cmp al, 'F' 
je sumarF  
jne atacar
 
 
sumarA:
add si, 2   
jmp continuar  

sumarB:
add si, 3   
jmp continuar

sumarC:
add si, 4 
jmp continuar 

sumarD:
add si, 5   
jmp continuar 

sumarE:
add si, 6  
jmp continuar

sumarF:
add si, 7  
jmp continuar

continuar:
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgAtNum         
int 21h 
mov ah,01         ;funcion para captar un caracter por teclado
int 21h   
sub al, 30h
cmp al,1 
je sumar1
cmp al,2 
je sumar2
cmp al,3 
je sumar3
cmp al,4 
je sumar4
cmp al,5 
je sumar5
cmp al,6 
je sumar6

sumar1: 
add si,6                                       
jmp confirmarMatriz  

sumar2: 
add si,13                                       
jmp confirmarMatriz

sumar3: 
add si,20                                       
jmp confirmarMatriz

sumar4: 
add si,27                                       
jmp confirmarMatriz

sumar5: 
add si,34                                       
jmp confirmarMatriz

sumar6: 
add si,41                                       
jmp confirmarMatriz                           


confirmarMatriz:
mov ax,0
mov ah,6   
mov dl,0
mov dl,matrizprueba[si]          
cmp dl, 3
je impacto
cmp dl, 4
je impacto
cmp dl, 5
je impacto                              
jne noimpacto         

impacto:             
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h 
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgImpacto         
int 21h  
inc bp   
mov cx,1 
cmp bp,20 
ja salir
je imprimir20
jb atacar

noImpacto:
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h 
mov ah, 09h         ;funcion para mostrar cadena de caracteres
lea dx, msgNoImpacto         
int 21h 
inc bp   
mov cx,1   
cmp bp, 20
ja salir
je imprimir20
jb atacar
      


 
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
lea dx, msgAtLetra        
int 21h  
mov ah,01         ;funcion para captar un caracter por teclado
int 21h 
jmp comparar

  

salir:
.exit
end