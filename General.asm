.MODEL SMALL
.386
.DATA
    
.CODE
  ;=============================================================================
    MAIN PROC FAR
      .STARTUP       
      .EXIT
    MAIN ENDP
  ;=============================================================================

     DRAW_NUM PROC

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
    FACTORIAL proc
    
    ; EBX <= NUM   LOCATION OF STORING
    ; EBX = INPUT
    PUSH EAX    
    MOV EAX, 1 ; Multiply neutral    
    REC:
    CMP EBX,0
    JE FINISHED 
    MUL EBX
    DEC EBX 
        Jnz REC ;Exit WHEN BX BECAME 0
        JMP FINISHED
     
    FINISHED:
        MOV EBX,EAX
        POP EAX
        RET
  FACTORIAL ENDP
;=============================================================================
;============================================================================= 
;                       COMBINATION
COMB PROC

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
    
    
    MOV EAX,EBX ;=> R!
   
        
    SUB ECX,EDI ;=> (N-R)    
    MOV EBX,ECX
    CALL FACTORIAL  ; EBX = (N-R)!
    
    
    MUL EBX ;=> R! * (N-R)!     
    MOV EBX,EAX ; EBX = R! * (N-R)! 
    
    
    POP EAX ;=> N!
    XOR EDX,EDX
    DIV EBX ;=> N! / I! * (N-I)!
    
    POP EBX
    POP ECX
    POP EDI
    RET
    COMB ENDP
;============================================================================= 
  
END MAIN
