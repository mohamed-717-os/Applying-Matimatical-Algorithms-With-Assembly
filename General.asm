.MODEL SMALL

.DATA
    NUM Dw 48

.CODE
  ;=============================================================================
    MAIN PROC FAR
      .STARTUP
      MOV AX, NUM
      CALL DRAW_NUM
         
      .EXIT
    MAIN ENDP
  ;=============================================================================

     DRAW_NUM PROC
    
     ; AX: NUM  
    
        MOV BP, SP  ; SAVE THE CURRENT STACK POINTER IN (BP)
        
      CONVERT:
    
        MOV BX,10
        MOV DX,0
        DIV BX     ; AX = AX / 10
        ADD DX,48  ; CONVERT REMAINDER INTO ASCII
        
        PUSH DX
        
        CMP AX, 0
        JZ  PRINT
        JMP CONVERT
        
      PRINT:
        POP     DX
        MOV     AH,02
        INT     21H
        
        CMP     BP, SP
        JZ      NUM_PRINTED ; JUMP WHEN SP RETURN TO IT'S FIRST VALUE
        JMP     PRINT
        
      NUM_PRINTED:
       RET 
    DRAW_NUM ENDP
  ;=============================================================================
END MAIN
