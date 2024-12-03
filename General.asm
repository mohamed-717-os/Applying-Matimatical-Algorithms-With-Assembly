.MODEL SMALL
.386

.DATA
    NUM DD 12

    FACTORIAL_RESULT DD 0
.CODE
  ;=============================================================================
    MAIN PROC FAR
      .STARTUP
      MOV EAX, NUM
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
        JZ  PRINT
        JMP CONVERT
        
      PRINT:
        POP     EDX
        MOV     AH,02
        INT     21H
        
        CMP     BP, SP
        JZ      NUM_PRINTED ; JUMP WHEN SP RETURN TO IT'S FIRST VALUE
        JMP     PRINT
        
      NUM_PRINTED:
       RET 
    DRAW_NUM ENDP
  ;============================================================================= 
    FACTORIAL proc
    
        ; AX:NUM
        
    REC:
        DEC NUM
        MOV EBX,NUM
        MUL EBX
        
        CMP EBX,1
        JZ FINISHED ;JUMP WHEN BX BECAME 1
        JMP REC
     
    FINISHED:
        RET
  FACTORIAL ENDP
    ;=============================================================================
  
END MAIN
