.model small
.data
include "emu8086.inc"  

posicion_numero db ? 
matrizprueba db ' ','A','B','C','D','E','F'
             db 1,0,0,0,0,9,0
             db 2,0,0,0,0,0,0  
             db 3,0,0,0,0,0,0
             db 4,0,0,0,0,0,0
             db 5,0,0,0,0,0,0
             db 6,0,0,0,0,9,0
             
longitud_barco db 3

.code
.start

generacion_numero_fila:
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9
   cmp dl, 7
   ja  generacion_numero_fila
   cmp dl, 0
   je  generacion_numero_fila 
   mov posicion_numero, dl
   mov cx, 0000h
   
generacion_numero_columna:
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      
   
   
   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9 
   mov ax, dx
   cmp al, 0
   je  generacion_numero_columna
   mov dl, posicion_numero
   mul dl
   cmp al, 48
   ja generacion_numero_columna
   mov posicion_numero, al
   mov cx, 0000h
   mov al, posicion_numero
   mov ah, 00h
   jbe convertir
 
convertir:
mov bl, 10
div bl
mov dx, ax
mov ax, 0000h
mov al, dh
push ax
mov ax, 0000h
mov al, dl
add cl, 1 ;Se anade uno al contador para saber cuantos valores hay que sacar de la pila
cmp al, 0
jnz convertir
mov ah, 02h
mov dl, 00h
int 21h
jz mostrar

mostrar:
pop ax
add al, 30h
mov dl, al
mov ah, 02h
int 21h
dec cl
cmp cl, 0
jnz mostrar


mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax
mov dx, 00000h
jz colocar_barco_horizontal_der

colocar_barco_horizontal_der: ;Trata de ubicar el barco de manera horizontal hacia la derecha
mov al, matrizprueba[si]
cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
jnz limpiar_datos_derecha ;limpia los datos que se hayan puesto
mov matrizprueba[si], 3
add si, 1
add dl, 1  ;cantidad de veces que se puso un barco
cmp dl, longitud_barco
jnz colocar_barco_horizontal_der
jz imprimir_colocacion_derecha


limpiar_datos_derecha:
cmp dl, 0  ;Si no se puso nada, no se limpia nada
jz  barco_horizontal_izq
mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax
;mov dx, 00000h

    recursiva_clean_derecha:
    mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
    add si, 1      ;Se anade +1 a la posicion
    add dh, 1
    cmp dh, dl
    jz  barco_horizontal_izq
    jnz recursiva_clean_derecha


barco_horizontal_izq:    
mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax
mov dx, 00000h
jz colocar_barco_horizontal_izq


colocar_barco_horizontal_izq: ;Trata de ubicar el barco de manera horizontal hacia la derecha
mov al, matrizprueba[si]
cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
jnz limpiar_datos_izquierda ;limpia los datos que se hayan puesto
mov matrizprueba[si], 3
dec si
add dl, 1  ;cantidad de veces que se puso un barco
cmp dl, longitud_barco
jnz colocar_barco_horizontal_izq
jz imprimir_colocacion_izquierda

limpiar_datos_izquierda:
cmp dl, 0  ;Si no se puso nada, no se limpia nada
jz  barco_vertical_up
mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax
;mov dx, 00000h

    recursiva_clean_izquierda:
    mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
    dec si      ;Se anade +1 a la posicion
    add dh, 1
    cmp dh, dl
    jz  barco_vertical_up
    jnz recursiva_clean_izquierda


barco_vertical_up:
mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax
mov dx, 00000h
jz colocar_barco_vertical_up


colocar_barco_vertical_up: ;Trata de ubicar el barco de manera vertical hacia arriba
mov al, matrizprueba[si]
cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
jnz limpiar_datos_vertical_up ;limpia los datos que se hayan puesto si es que no se puede poner
mov matrizprueba[si], 3     ;Tipo de barco al que se pone dentro de la matriz
sub si, 7
add dl, 1  ;cantidad de veces que se puso un barco
cmp dl, longitud_barco
jnz colocar_barco_vertical_up
jz imprimir_colocacion_arriba

limpiar_datos_vertical_up:
cmp dl, 0  ;Si no se puso nada, no se limpia nada
jz  barco_vertical_down
mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax 

    recursiva_clean_vertical_up:
    mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
    sub si, 7      ;Se sube hacia arriba en la matriz
    add dh, 1
    cmp dh, dl
    jz  barco_vertical_down
    jnz recursiva_clean_vertical_up


barco_vertical_down:
mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax
mov dx, 00000h
jz colocar_barco_vertical_down


colocar_barco_vertical_down: ;Trata de ubicar el barco de manera vertical hacia abajo
mov al, matrizprueba[si]
cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
jnz limpiar_datos_vertical_down ;limpia los datos que se hayan puesto si es que no se puede poner
mov matrizprueba[si], 3     ;Tipo de barco al que se pone dentro de la matriz
add si, 7                   ;Se aumenta 7 para ir hacia abajo de la matriz
add dl, 1  ;cantidad de veces que se puso un barco
cmp dl, longitud_barco
jnz colocar_barco_vertical_down
jz imprimir_colocacion_abajo


limpiar_datos_vertical_down:
cmp dl, 0  ;Si no se puso nada, no se limpia nada
jz  generacion_numero_submarino_fila
mov ah, 00h
mov al, posicion_numero ;AQUI VA POSICION_NUMERO
mov si, ax

    recursiva_clean_vertical_down:
    mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
    add si, 7      ;Se sube hacia arriba en la matriz
    add dh, 1
    cmp dh, dl
    jz  generacion_numero_submarino_fila
    jnz recursiva_clean_vertical_down  






 
 
imprimir_colocacion_abajo:
print 'Se ha colocado un barco hacia abajo'
jmp generacion_numero_submarino_fila


imprimir_colocacion_arriba:
print 'Se ha colocado un barco hacia arriba'
jmp generacion_numero_submarino_fila

imprimir_colocacion_derecha:
print 'Se ha colocado un barco hacia a la derecha'
jmp generacion_numero_submarino_fila 


imprimir_colocacion_izquierda:
print 'Se ha colocado un barco hacia a la izquierda'
jmp generacion_numero_submarino_fila



colocacion_No_exitosa:
print 'No se ha podido colocar un barco'
jmp salir

;poner_barco_horizontal_izq:
;mov al, matrizprueba[si]
;cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
;jnz poner_barco_horizontal_izq ;Cambia la posicion en la que se coloca el barco
;mov matrizprueba[si], 3
;add si, 1
;add dl, 1
;cmp dl, longitud_barco 

;jz salir
;jnz poner_barco
 


salir:
.exit
end