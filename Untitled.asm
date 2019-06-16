;%%%%%%%%%%%%%%%%%%%%%%%%%%%% MICROCONTROLADORES PIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;AUTOR : REYNALDO DURAN - V19893220
;PRACTICA #1 : SUMA, RESTA Y MULTIPLICACION DE DOS NUMEROS DE 16 BITS

		LIST P=PIC18F45K50 				; list directive to define processor
		#INCLUDE <P18F45K50.INC> 		; processor specific variable definitions
        ORG 0                           ; El programa comienza en la dirección 0
		
		CBLOCK 0X21
        numeroAL						; Primer numero 8 bits menos significativos
		numeroAH						; Primer numero 8 bits mas significativos
		numeroBL						; Segundo numero 8 bits menos significativos
		numeroBH						; Segundo numero 8 bits mas significativos
		sumaL							; Resultado de la suma 8 bits menos significativos
		sumaH							; Resultado de la suma 8 bits mas significativos
		restaL							; Resultado de la resta 8 bits menos significativos
		restaH							; Resultado de la resta 8 bits mas significativos
		numeroA8bits					; Primer numero para la multiplicacion
		numeroB8bits					; Segundo numero para la multiplicacion
		multiplicacion					; Resultado de la multiplicacion
		selectorDeOperacion				;1 - Suma | 2 - Resta | 3 - Multiplicacion
		carry							; Guarda el bit 0 del STATUS para llevar el control de acarreo
		aux								; Auxiliar para el conteo de multiplicacion		
		ENDC

;Inicializacion de los dos numeros a operar

		movlw .12
		movwf numeroAL
		movlw .1
		movwf numeroAH

		movlw .10
		movwf numeroBL
		movlw .0
		movwf numeroBH

		movlw 0x5
		movwf numeroA8bits

		movlw 0x6
		movwf numeroB8bits

		movlw 0x0
		movwf aux

		movlw 0x2
		movwf selectorDeOperacion
		
; Selector de operacion

		movf selectorDeOperacion, 0
		sublw b'00000001'				; Comparacion para SUMA
		btfsc STATUS, Z 	
		goto SUMA	

		movf selectorDeOperacion, 0
		sublw b'00000010'				; Comparacion para RESTA
		btfsc STATUS, Z 	
		goto RESTA	

		movf selectorDeOperacion, 0
		sublw b'00000011'				; Comparacion para MULTIPLICACION
		btfsc STATUS, Z 	
		goto MULTIPLICACION	

; Operaciones

SUMA

		clrf carry, 0					; Se inicializa el carry

		movf numeroAL, 0				; Se mueve AL a W
		addwf numeroBL, 0				; Se suma AL con BL
		movwf sumaL						; El resultado se mueve a sumaL (suma low)
		
		btfsc STATUS,0 					; Se verifica si el carry del status detecto desbordamiento
		bsf carry, 0					; Carry se setea a 1 si la instruccion anterior aplica
		
		movf numeroAH, 0				; Se mueve AH a W
		addwf numeroBH, 0				; Se suma AH con BH
		addwf carry, 0					; Se suma el acarreo anterior al resultado de la suma H
		movwf sumaH						; El resultado final se mueve a suma H

		goto FIN
; El total de la suma, de no haber desbordamiento, sera sumaH - sumaL
		
RESTA

		movf numeroAL, 0				; Se mueve AL a W
		subwf numeroBL, 0				; Se resta AL con BL
		movwf restaL					; El resultado se mueve a restaL (resta low)
		
		btfsc STATUS,0 					; Se verifica si el carry del status detecto desbordamiento
		bsf carry, 0					; Carry se setea a 1 si la instruccion anterior aplica
		
		movf numeroAH, 0				; Se mueve AH a W
		subwf numeroBH, 0				; Se resta AH con BH
		subwf carry, 0					; Se resta el acarreo anterior al resultado de la resta H
		movwf restaH						; El resultado final se mueve a resta H

		goto FIN

MULTIPLICACION

		movlw 0x0
		movwf multiplicacion

		SEGUIR
		movf numeroA8bits, 0
		addwf multiplicacion, 1 
		
		incf aux
		movf aux, 0
		CPFSEQ	numeroB8bits
		goto SEGUIR

FIN		
		goto $                            ; Fin del programa

		END