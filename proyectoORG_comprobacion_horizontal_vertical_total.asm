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
             db 1,7,0,8,8,8,8
             db 2,7,0,0,0,0,0  
             db 3,7,0,0,0,0,0
             db 4,0,0,0,0,0,0
             db 5,0,0,0,0,0,0
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
barco_impactado db 0   ;Aloja el tipo de barco al que es atacado
recorrido_tres db 2
recorrido_cuatro db 3
recorrido_cinco db 4
limite_barco db 0

tipo_barco db ?


.code               ;comienzo del segmento de codigo
.start              ;inicio de las instrucciones
 

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
cmp dl, 9 
jbe sumar   
ja imprimir2   

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
cmp dl, 7
je impacto
cmp dl, 8
je impacto
cmp dl, 9
je impacto                              
jne noimpacto         

impacto:
mov al, matrizprueba[si]  ;Se guarda el tipo de barco al que se dio
mov tipo_barco, al
mov bx, si ;Se guarda la posicion en donde se encontraba si (BX guarda la posicion y no la modifica)
mov matrizprueba[si], 0
mov di, bx ;Se copia la posicion
mov dx, 0000h ;se limpia el registro
mov dx, di ;Se copia la posicion en un registro

cmp al, 7
jz change_submarino
cmp al, 8
jz change_crucero
cmp al, 9
jz change_portaviones


change_submarino:
add dx, 2 ;Se tiene el limite hasta el que llega el tipo de barco (suma)
jmp comprobar_barco_destruido_horizontal_der

change_crucero:
add dx, 3 ;Se tiene el limite hasta el que llega el tipo de barco (suma)
jmp comprobar_barco_destruido_horizontal_der
 
change_portaviones:
add dx, 4 ;Se tiene el limite hasta el que llega el tipo de barco (suma)
jmp comprobar_barco_destruido_horizontal_der


    comprobar_barco_destruido_horizontal_der:    
    add di, 1 ;Se aumenta 1 a la posicion
    cmp di, 48 ;OUT OF BOUND OF MATRIX
    ja  comprobar_horizontal_izq
    mov al, matrizprueba[di] ;Tipo de barco o 0 se guarda aqui se rescata
    
        cmp al, 1
        jz comprobar_horizontal_izq
        
        cmp al, 2
        jz comprobar_horizontal_izq
        
        cmp al, 3
        jz comprobar_horizontal_izq
        
        cmp al, 4
        jz comprobar_horizontal_izq
        
        cmp al, 5
        jz comprobar_horizontal_izq
        
        cmp al, 6
        jz comprobar_horizontal_izq
        
     
     
    cmp al, tipo_barco  ;Tipo de barco con el que se comprueba
    jz mensaje_impacto  ;Si es que encuentra a un numero similar al del barco el barco sigue existiendo
    cmp dx, di
    je comprobar_horizontal_izq
    jne comprobar_barco_destruido_horizontal_der
    
comprobar_horizontal_izq:
mov di, bx ;Se copia la posicion
mov al, tipo_barco  ;Se trae el valor del barco que se habia guardado
mov dx, 0000h ;se limpia el registro
mov dx, di ;Se copia la posicion en un registro 

cmp al, 7
jz change_submarino_izq
cmp al, 8
jz change_crucero_izq
cmp al, 9
jz change_portaviones_izq


change_submarino_izq:
sub dx, 2 ;Se tiene el limite hasta el que llega el tipo de barco (resta)
jmp comprobar_barco_destruido_horizontal_izq

change_crucero_izq:
sub dx, 3 ;Se tiene el limite hasta el que llega el tipo de barco (resta)
jmp comprobar_barco_destruido_horizontal_izq
 
change_portaviones_izq:
sub dx, 4 ;Se tiene el limite hasta el que llega el tipo de barco (resta)
jmp comprobar_barco_destruido_horizontal_izq
    
    comprobar_barco_destruido_horizontal_izq:
    dec di
    cmp di, 8
    jb  comprobar_vertical_up  ;OUT OF BOUND OF MATRIX
    mov al, matrizprueba[di] ;Tipo de barco o 0 se guarda aqui
    
    ;Toma los bordes en cuenta

    cmp al, tipo_barco  ;Tipo de barco con el que se comprueba
    jz mensaje_impacto
    cmp dx, di
    jnz comprobar_barco_destruido_horizontal_izq
    jz  comprobar_vertical_up

    
comprobar_vertical_up:
mov di, bx ;Se copia la posicion
mov al, tipo_barco  ;Se trae el valor del barco que se habia guardado
mov dx, 0000h ;se limpia el registro
mov dx, di ;Se copia la posicion en un registro
;mov bh, 1  ;Contador de cantidad de veces que se va a ir para arriba
;mov dl, 0  ;Limite de veces que se va a ir para arriba

cmp al, 7
jz change_submarino_up
cmp al, 8
jz change_crucero_up
cmp al, 9
jz change_portaviones_up
   

change_submarino_up:
mov dl, 2 ;Se puede ir 2 veces hacia arriba
jmp comprobar_barco_destruido_vertical_up

change_crucero_up:
mov dl, 3 ;Se puede ir 3 veces hacia arriba
jmp comprobar_barco_destruido_vertical_up
 
change_portaviones_up:
mov dl, 4 ;Se puede ir 4 veces hacia arriba
jmp comprobar_barco_destruido_vertical_up

    comprobar_barco_destruido_vertical_up:
    sub di, 7
    cmp di, 8
    jb comprobar_vertical_down  ;OUT OF BOUND OF MATRIX
    mov al, matrizprueba[di] ;Tipo de barco o 0 se guarda aqui
    
    
    cmp al, tipo_barco  ;Tipo de barco con el que se comprueba
    jz mensaje_impacto
    jnz comprobar_barco_destruido_vertical_up 
    

comprobar_vertical_down:
mov di, bx ;Se copia la posicion
mov al, tipo_barco  ;Se trae el valor del barco que se habia guardado
mov dx, 0000h ;se limpia el registro
mov dx, di ;Se copia la posicion en un registro

    comprobar_barco_destruido_vertical_down:
    add di, 7
    cmp di, 48   ;OUT OF BOUND OF MATRIX
    ja  mensaje_eliminado
    mov al, matrizprueba[di] ;Tipo de barco o 0 se guarda aqui
    
    cmp al, tipo_barco  ;Tipo de barco con el que se comprueba
    jz mensaje_impacto
    jnz comprobar_barco_destruido_vertical_down

              
mensaje_eliminado:
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h 
print 'Ha destruido un barco'
    
     
    
mensaje_impacto:             
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
jb limpiar

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