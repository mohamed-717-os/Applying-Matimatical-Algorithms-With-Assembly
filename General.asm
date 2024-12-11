; PROSEDURES IN THIS FILE IS:
    ; * DRAW_NUM
    ; * DRAW_NUM
    
.MODEL SMALL
.CODE

;=============================================================================
;                    PRINTING HEXA NUMBERS AS DECIMAL                  
;============================================================================= 
    DRAW_NUM PROC
    
    ; EAX: NUM  
        PUSH AX
        PUSH BX
        MOV BP, SP  ; SAVE THE CURRENT STACK POINTER IN (BP)
        
      CONVERT:
    
        MOV EBX,10
        MOV EDX,0
        DIV EBX     ; AX = AX / 10
        ADD EDX,48  ; CONVERT REMAINDER INTO ASCII
        
        PUSH DX
        
        CMP EAX, 0
        Je  PRINT
        JMP CONVERT
        
      PRINT:
        POP     DX
        MOV     AH,02
        INT     21H
        
        CMP     BP, SP
        Je      NUM_PRINTED ; JUMP WHEN SP RETURN TO IT'S FIRST VALUE
        JMP     PRINT
        
      NUM_PRINTED:
       POP BX
       POP AX
       RET 
    DRAW_NUM ENDP
    
; ===============================================================
;          READING NUMBERS WITH ANY NUMBER OF DIGITS
; ===============================================================

    read_number PROC 
    PUSH SI
    PUSH AX
    PUSH CX
    MOV BX, 0
    read_num:
        MOV AH, 01h 
        INT 21h
        
        CMP AL, 0dh  
        JE done_reading
        CMP AL, ' '  
        JE done_reading
        
        XOR AH, AH
        SUB AL, '0'
        
        mov si , ax
        mov ax , bx 
        xor dx , dx 
         
        mov cx , 10 
        
        mul cx
        add si , ax 
        mov bx , si 
        
        JMP read_num
        
    done_reading:
        POP CX
        POP AX
        POP SI
        RET
   read_number ENDP
   
  