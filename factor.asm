.MODEL SMALL
.386

.DATA
    NUM DD 10
    
.CODE
  ;=============================================================================
    MAIN PROC FAR
      .STARTUP
      MOV EAX, 1 ; Multiply neutral 
      MOV EBX, NUM      
      CALL FACTORIAL
      CALL DRAW_NUM
      .EXIT
    MAIN ENDP
  ;=============================================================================

     DRAW_NUM PROC
    
     ; AX: NUM  
    
        MOV BP, SP  ; SAVE THE CURRENT STACK POINTER IN (BP)
        
      CONVERT:
    
        MOV EBX,10
        MOV EDX,0
        DIV EBX     ; AX = AX / 10
        ADD EDX,48  ; CONVERT REMAINDER INTO ASCII
        
        PUSH EDX
        
        CMP EAX, 0
        Je  PRINT
        JMP CONVERT
        
      PRINT:
        POP     EDX
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
    
        ; EAX:NUM
        
    REC:
        MUL EBX
        DEC EBX 
        Jnz REC ;JUMP WHEN BX BECAME 0
        JMP FINISHED
     
    FINISHED:
        RET
  FACTORIAL ENDP
    ;=============================================================================
  
END MAIN
