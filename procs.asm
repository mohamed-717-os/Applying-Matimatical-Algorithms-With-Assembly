.MODEL SMALL

.DATA
    NUM Dw 18

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
    
        ; NUM IS IN AX
    
        MOV BP, SP
        
      CONVERT:
    
        MOV BX,10
        MOV DX,0
        DIV BX
        ADD DX,48
        
        PUSH DX
        
        CMP AX, 0
        JZ  PRINT
        JMP CONVERT
        
      PRINT:
        POP     DX
        MOV     AH,02
        INT     21H
        
        CMP     BP, SP
        JZ      NUM_PRINTED
        JMP     PRINT
        
      NUM_PRINTED:
       RET 
    DRAW_NUM ENDP
  ;=============================================================================
END MAIN
