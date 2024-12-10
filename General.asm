.MODEL SMALL

;============================================================================= 
;                       PERMUTATIONS
;============================================================================= 
    PER PROC

    ; EAX <= RESULT
    PUSH EDI
    PUSH ECX
    PUSH EBX
    
    MOV BP,SP
    MOV EDI,[BP+14] ;=> R
    MOV ECX,[BP+18] ;=> N
    
    MOV EBX,ECX   
    CALL FACTORIAL
    PUSH EBX    ;=> N!
    
    MOV EBX,EDI   
    CALL FACTORIAL    
   
        
    SUB ECX,EDI ;=> (N-R)    
    MOV EBX,ECX
    CALL FACTORIAL  ; EBX = (N-R)!    
    
    POP EAX ;=> N!
    XOR EDX,EDX
    DIV EBX ;=> N! /(N-I)!
    
    POP EBX
    POP ECX
    POP EDI
    CALL DRAW_NUM
    RET
    PER ENDP

;=============================================================================
;                           PRINT NUMBER                          
;============================================================================= 
    DRAW_NUM PROC
    
     ; AX: NUM  
    
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
       RET 
    DRAW_NUM ENDP
;=============================================================================
;                           CLEAR ARRAY                          
;=============================================================================
    CLEAR_ARRAY PROC
            PUSHA
            MOV BP, SP
            MOV SI, [BP+18]  ;> ARRAY OFFSET

            MOV AX, [SI]
            XOR DX, DX
            MOV BX, [SI+2]
            MUL BX

            MOV CX, AX
            ADD SI, 4 

           CLEAR:

              MOV AX, 0
              MOV [SI], AX
              ADD SI, 2

             LOOP CLEAR

           POPA
           RET
        CLEAR_ARRAY ENDP
;=============================================================================
