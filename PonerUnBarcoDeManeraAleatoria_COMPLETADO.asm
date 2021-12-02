.model small
.data
include "emu8086.inc"  

posicion_numero db ? 
matrizprueba db ' ','A','B','C','D','E','F'
             db 1,0,0,0,0,0,0
             db 2,0,0,0,0,0,0  
             db 3,0,0,0,0,0,0
             db 4,0,0,0,0,0,0
             db 5,0,0,0,0,0,0
             db 6,0,0,0,0,0,0
             
longitud_submarino db 3
longitud_crucero db 4
longitud_portaviones db 5
linefeed db 13,10,"$"

tipo_barco db 7



.code
.start

generacion_numero_fila:
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9
   cmp dl, 7     ;Compara que sea menor a 7 para poder multiplicar
   ja  generacion_numero_fila
   cmp dl, 0     ;comprueba que no sea 0 porque no nos sirve el indice la posicion 0
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
   cmp al, 0     ;Comprueba si es 0 y vuelve a hacer la operacion
   je  generacion_numero_columna
   mov dl, posicion_numero
   mul dl        ;Se multiplica el numero generado en fila con el de columna
   cmp al, 48    ;Tiene que verificar que no sea mayor a 48 porque es el tamano maximo de la matriz
   ja generacion_numero_columna
   mov posicion_numero, al
   mov cx, 0000h
   mov al, posicion_numero ;Guardamos la posicion que se genero
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
cmp tipo_barco, 7
jz colocar_submarino_horizontal_der  ;Se coloca un submarino

cmp tipo_barco, 8
jz colocar_crucero_horizontal_der    ;Se coloca un crucero

cmp tipo_barco, 9
jz colocar_portaviones_horizontal_der ;Se coloca un portaviones

      
    ;COLOCACION DEL SUBMARINO (8888)  

    colocar_submarino_horizontal_der: ;Trata de ubicar el barco de manera horizontal hacia la derecha
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_submarino_derecha ;limpia los datos que se hayan puesto
    mov matrizprueba[si], 7   ;Coloca el numero que se debe poner para identificar un submarino
    add si, 1
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_submarino ;Lo hace hasta llegar el tamano de un submarino
    jnz colocar_submarino_horizontal_der
    jz imprimir_colocacion_submarino_derecha  ;Si es que son iguales, se habra colocado el submarino correctamente


    limpiar_datos_submarino_derecha:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  submarino_horizontal_izq ;Va a evaluar otra posicion para ingresarlo
    mov ah, 00h
    mov al, posicion_numero ;Recupera la posicion dentro de la matriz
    mov si, ax

        recursiva_clean_submarino_derecha:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        add si, 1      ;Se anade +1 a la posicion
        add dh, 1      ;Se anade +1 al contador para saber cuantas veces lleva limpiando (dl se guarda las veces que ingreso el barco)
        cmp dh, dl     ;Se compara si dh y dl son iguales
        jz  submarino_horizontal_izq  ;Si son iguales es porque ya se termino de limpiar lo que se habia puesto
        jnz recursiva_clean_submarino_derecha ;Si no son iguales sigue limpiando el indice de la matriz que sigue

    
    ;Se realiza lo mismo hacia la izquierda, lo unico que cambia es que ya no sumamos para incrementar la posicion, sino restamos.
    submarino_horizontal_izq:    
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax
    mov dx, 00000h
    jz colocar_submarino_horizontal_izq


    colocar_submarino_horizontal_izq: ;Trata de ubicar el barco de manera horizontal hacia la iaquierda
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_submarino_izquierda ;limpia los datos que se hayan puesto
    mov matrizprueba[si], 7
    dec si
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_submarino
    jnz colocar_submarino_horizontal_izq
    jz imprimir_colocacion_submarino_izquierda

    limpiar_datos_submarino_izquierda:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  submarino_vertical_up
    mov ah, 00h
    mov al, posicion_numero ;AQUI VA POSICION_NUMERO
    mov si, ax

        recursiva_clean_submarino_izquierda:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        dec si      ;Se anade +1 a la posicion
        add dh, 1
        cmp dh, dl
        jz  submarino_vertical_up
        jnz recursiva_clean_submarino_izquierda

    ;Para colocar los barcos de manera vertical se aprovecha que si se suma 7 o se resta 7 estaremos navegando en las columnas hacia abajo y arriba respectivamente.
    
    submarino_vertical_up:
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion inicial
    mov si, ax
    mov dx, 00000h
    jz colocar_submarino_vertical_up


    colocar_submarino_vertical_up: ;Trata de ubicar el barco de manera vertical hacia arriba
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_submarino_vertical_up ;limpia los datos que se hayan puesto si es que no se puede poner
    mov matrizprueba[si], 7     ;Tipo de barco al que se pone dentro de la matriz
    sub si, 7
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_submarino
    jnz colocar_submarino_vertical_up
    jz imprimir_colocacion_submarino_arriba

    limpiar_datos_submarino_vertical_up:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  submarino_vertical_down
    mov ah, 00h
    mov al, posicion_numero ;Se recupera posicion inicial
    mov si, ax 

        recursiva_clean_submarino_vertical_up:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        sub si, 7      ;Se sube hacia arriba en la matriz
        add dh, 1
        cmp dh, dl
        jz  submarino_vertical_down
        jnz recursiva_clean_submarino_vertical_up


    submarino_vertical_down:
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax
    mov dx, 00000h
    jz colocar_submarino_vertical_down


    colocar_submarino_vertical_down: ;Trata de ubicar el barco de manera vertical hacia abajo
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_submarino_vertical_down ;limpia los datos que se hayan puesto si es que no se puede poner
    mov matrizprueba[si], 7     ;Tipo de barco al que se pone dentro de la matriz
    add si, 7                   ;Se aumenta 7 para ir hacia abajo de la matriz
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_submarino
    jnz colocar_submarino_vertical_down
    jz imprimir_colocacion_submarino_abajo


    limpiar_datos_submarino_vertical_down:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  generacion_numero_fila
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax

        recursiva_clean_submarino_vertical_down:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        add si, 7      ;Se sube hacia arriba en la matriz
        add dh, 1
        cmp dh, dl
        jz  generacion_numero_fila
        jnz recursiva_clean_submarino_vertical_down
        
        
        
   
    
    
    ;COLOCACION DEL CRUCERO (8888)
    
    colocar_crucero_horizontal_der: ;Trata de ubicar el barco de manera horizontal hacia la derecha
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_crucero_derecha ;limpia los datos que se hayan puesto
    mov matrizprueba[si], 8
    add si, 1
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_crucero
    jnz colocar_crucero_horizontal_der
    jz imprimir_colocacion_crucero_derecha


    limpiar_datos_crucero_derecha:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  crucero_horizontal_izq
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax

        recursiva_clean_crucero_derecha:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        add si, 1      ;Se anade +1 a la posicion
        add dh, 1
        cmp dh, dl
        jz  crucero_horizontal_izq
        jnz recursiva_clean_crucero_derecha


    crucero_horizontal_izq:    
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax
    mov dx, 00000h
    jz colocar_crucero_horizontal_izq


    colocar_crucero_horizontal_izq: ;Trata de ubicar el barco de manera horizontal hacia la derecha
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_crucero_izquierda ;limpia los datos que se hayan puesto
    mov matrizprueba[si], 8
    dec si
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_crucero
    jnz colocar_crucero_horizontal_izq
    jz imprimir_colocacion_crucero_izquierda

    limpiar_datos_crucero_izquierda:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  crucero_vertical_up
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax

        recursiva_clean_crucero_izquierda:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        dec si      ;Se anade +1 a la posicion
        add dh, 1
        cmp dh, dl
        jz  crucero_vertical_up
        jnz recursiva_clean_crucero_izquierda


    crucero_vertical_up:
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion inicial
    mov si, ax
    mov dx, 00000h
    jz colocar_crucero_vertical_up


    colocar_crucero_vertical_up: ;Trata de ubicar el barco de manera vertical hacia arriba
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_crucero_vertical_up ;limpia los datos que se hayan puesto si es que no se puede poner
    mov matrizprueba[si], 8     ;Tipo de barco al que se pone dentro de la matriz
    sub si, 7
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_crucero
    jnz colocar_crucero_vertical_up
    jz imprimir_colocacion_crucero_arriba

    limpiar_datos_crucero_vertical_up:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  crucero_vertical_down
    mov ah, 00h
    mov al, posicion_numero ;Se recupera posicion inicial
    mov si, ax 

        recursiva_clean_crucero_vertical_up:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        sub si, 7      ;Se sube hacia arriba en la matriz
        add dh, 1
        cmp dh, dl
        jz  crucero_vertical_down
        jnz recursiva_clean_crucero_vertical_up


    crucero_vertical_down:
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax
    mov dx, 00000h
    jz colocar_crucero_vertical_down


    colocar_crucero_vertical_down: ;Trata de ubicar el barco de manera vertical hacia abajo
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_crucero_vertical_down ;limpia los datos que se hayan puesto si es que no se puede poner
    mov matrizprueba[si], 8     ;Tipo de barco al que se pone dentro de la matriz
    add si, 7                   ;Se aumenta 7 para ir hacia abajo de la matriz
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_crucero
    jnz colocar_crucero_vertical_down
    jz imprimir_colocacion_crucero_abajo


    limpiar_datos_crucero_vertical_down:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  generacion_numero_fila
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax

        recursiva_clean_crucero_vertical_down:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        add si, 7      ;Se sube hacia arriba en la matriz
        add dh, 1
        cmp dh, dl
        jz  generacion_numero_fila
        jnz recursiva_clean_crucero_vertical_down
        
        
        
    
    
    
    ;COLOCACION DE PORTAVIONES (9999)
    
    colocar_portaviones_horizontal_der: ;Trata de ubicar el barco de manera horizontal hacia la derecha
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_portaviones_derecha ;limpia los datos que se hayan puesto
    mov matrizprueba[si], 9
    add si, 1
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_portaviones
    jnz colocar_portaviones_horizontal_der
    jz imprimir_colocacion_portaviones_derecha


    limpiar_datos_portaviones_derecha:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  portaviones_horizontal_izq
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax

        recursiva_clean_portaviones_derecha:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        add si, 1      ;Se anade +1 a la posicion
        add dh, 1
        cmp dh, dl
        jz  portaviones_horizontal_izq
        jnz recursiva_clean_portaviones_derecha


    portaviones_horizontal_izq:    
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax
    mov dx, 00000h
    jz colocar_portaviones_horizontal_izq


    colocar_portaviones_horizontal_izq: ;Trata de ubicar el barco de manera horizontal hacia la derecha
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_portaviones_izquierda ;limpia los datos que se hayan puesto
    mov matrizprueba[si], 9
    dec si
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_portaviones
    jnz colocar_portaviones_horizontal_izq
    jz imprimir_colocacion_portaviones_izquierda

    limpiar_datos_portaviones_izquierda:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  portaviones_vertical_up
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax

        recursiva_clean_portaviones_izquierda:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        dec si      ;Se anade +1 a la posicion
        add dh, 1
        cmp dh, dl
        jz  portaviones_vertical_up
        jnz recursiva_clean_portaviones_izquierda


    portaviones_vertical_up:
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion inicial
    mov si, ax
    mov dx, 00000h
    jz colocar_portaviones_vertical_up


    colocar_portaviones_vertical_up: ;Trata de ubicar el barco de manera vertical hacia arriba
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_portaviones_vertical_up ;limpia los datos que se hayan puesto si es que no se puede poner
    mov matrizprueba[si], 9     ;Tipo de barco al que se pone dentro de la matriz
    sub si, 7
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_portaviones
    jnz colocar_portaviones_vertical_up
    jz imprimir_colocacion_portaviones_arriba

    limpiar_datos_portaviones_vertical_up:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  portaviones_vertical_down
    mov ah, 00h
    mov al, posicion_numero ;Se recupera posicion inicial
    mov si, ax 

        recursiva_clean_portaviones_vertical_up:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        sub si, 7      ;Se sube hacia arriba en la matriz
        add dh, 1
        cmp dh, dl
        jz  portaviones_vertical_down
        jnz recursiva_clean_portaviones_vertical_up


    portaviones_vertical_down:
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax
    mov dx, 00000h
    jz colocar_portaviones_vertical_down


    colocar_portaviones_vertical_down: ;Trata de ubicar el barco de manera vertical hacia abajo
    mov al, matrizprueba[si]
    cmp al, 0                      ;Se confirma que los valores en donde se puede reemplazar deben ser 0's
    jnz limpiar_datos_portaviones_vertical_down ;limpia los datos que se hayan puesto si es que no se puede poner
    mov matrizprueba[si], 9     ;Tipo de barco al que se pone dentro de la matriz
    add si, 7                   ;Se aumenta 7 para ir hacia abajo de la matriz
    add dl, 1  ;cantidad de veces que se puso un barco
    cmp dl, longitud_portaviones
    jnz colocar_portaviones_vertical_down
    jz imprimir_colocacion_portaviones_abajo


    limpiar_datos_portaviones_vertical_down:
    cmp dl, 0  ;Si no se puso nada, no se limpia nada
    jz  generacion_numero_fila
    mov ah, 00h
    mov al, posicion_numero ;Se recupera la posicion
    mov si, ax

        recursiva_clean_portaviones_vertical_down:
        mov matrizprueba[si], 0 ;Se vuelve 0 en donde se habia puesto barco 
        add si, 7      ;Se sube hacia arriba en la matriz
        add dh, 1
        cmp dh, dl
        jz  generacion_numero_fila
        jnz recursiva_clean_portaviones_vertical_down  







fin_colocaciones:
print 'Se ha terminado de colocar la flota entera!'
jmp limpiar

;FEEDBACK COLOCACION PORTAVIONES
imprimir_colocacion_portaviones_abajo:
print 'Se ha colocado un portaviones hacia abajo' 
add tipo_barco, 1
jmp fin_colocaciones


imprimir_colocacion_portaviones_arriba:
print 'Se ha colocado un portaviones hacia arriba'
add tipo_barco, 1
jmp fin_colocaciones

imprimir_colocacion_portaviones_derecha:
print 'Se ha colocado un portaviones hacia a la derecha'
add tipo_barco, 1
jmp fin_colocaciones 


imprimir_colocacion_portaviones_izquierda:
print 'Se ha colocado un portaviones hacia a la izquierda'
add tipo_barco, 1
jmp fin_colocaciones




;FEEDBACK COLOCACION SUBMARINO

imprimir_colocacion_submarino_abajo:
print 'Se ha colocado un submarino hacia abajo' 
add tipo_barco, 1
jmp generacion_numero_fila


imprimir_colocacion_submarino_arriba:
print 'Se ha colocado un submarino hacia arriba'
add tipo_barco, 1
jmp generacion_numero_fila

imprimir_colocacion_submarino_derecha:
print 'Se ha colocado un submarion hacia a la derecha'
add tipo_barco, 1
jmp generacion_numero_fila 


imprimir_colocacion_submarino_izquierda:
print 'Se ha colocado un submarino hacia a la izquierda'
add tipo_barco, 1
jmp generacion_numero_fila 



;FEEDBACK COLOCACION CRUCERO

imprimir_colocacion_crucero_abajo:
print 'Se ha colocado un crucero hacia abajo' 
add tipo_barco, 1
jmp generacion_numero_fila


imprimir_colocacion_crucero_arriba:
print 'Se ha colocado un crucero hacia arriba'
add tipo_barco, 1
jmp generacion_numero_fila

imprimir_colocacion_crucero_derecha:
print 'Se ha colocado un crucero hacia a la derecha'
add tipo_barco, 1
jmp generacion_numero_fila 


imprimir_colocacion_crucero_izquierda:
print 'Se ha colocado un crucero hacia a la izquierda'
add tipo_barco, 1
jmp generacion_numero_fila



colocacion_No_exitosa:
print 'No se ha podido colocar un barco'
jmp salir



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
je salir



sumar:
add dl,30h 
jmp imprimir2

saltolinea:
mov ah,09h
mov dx, offset linefeed          ;newline
int 21h 
jmp imprimir



salir:
.exit
end