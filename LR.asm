.MODEL SMALL
.386
.DATA
    ;---------------- LINEAR REGRESSION VARIABLES -------------------
        THETA DW 1,2, 2 DUP(0)            
        
        X DW 30 DUP(0)
        Y DW 30 DUP(0)
        
        ERROR DW 30 DUP(0)    ;->  (THETA * X) - Y 
        ELEMENTS DW 0        ;->  TO STORE THE ADDRESS OF THE LAST ELEMENT
        
        EPOCHS Dw 100
        ALPHA DW 100


.CODE

; ==================================================================================
   ; //////////////////////  LINEAR REGRESSION ALGORITHM  ////////////////////////
; ==================================================================================

    LINEAR_REGRESSION PROC

        
     ; ADDRESS OF THE LAST ELEMENT
        MOV AX, X[2]  
        MOV ELEMENTS, AX
        
        SHL ELEMENTS, 1     ; ELEMENTS * 2 BECAUSE EVERY ELEMENT TAKE 2 BYTE
        
     ; ADD COLUMN OF (ONES) TO X
        ; PUT SI AFTER THE LAST ELEMENT
        MOV SI, OFFSET X
        ADD SI, 4         ; 4 FOR THE FIRST IGNORED 2 WORDS 
        ADD SI, ELEMENTS
        
        MOV CX, X[2]
        
      ADD_ONES:
        MOV WORD PTR [SI], 1
        ADD SI, 2
   
      LOOP ADD_ONES
        
      INC X[0]
      
      FIT: 
          ;------------  C = (X . THETA) [1 X N] -------------
             PUSH OFFSET THETA             ; [1 X 2]
             PUSH OFFSET X                 ; [2 X N]
             CALL MAT_MUL        ; RESULT IN C
             
          ;-------------- (ERR) = (C - Y) [1 X N] ------------------
           
           MOV BX, 4
           MOV CX, ELEMENTS 
           
         SUBTRACT:
           MOV AX, Y[BX]
           SHL AX, 7      ; SCALING Y TO SLOLVE THE FLOAT FLOORING
                           ; (WE WILL FIX THIS BY DIVIDING THETAS BY 2^6 WHILE DRAWING THE LINE) 
           SUB C[BX], AX
           
           ADD BX, 2
           SUB CX, 2
           JNZ SUBTRACT
           
        ; PUTTING C IN ERROR 
            MOV CX, C[2]
            ADD CX, 2   ; ADD 2 FOR INDECES OF ROWS AND COLS.
            
            MOV BX, 0
          PUTT_LOOP:
            MOV AX, C[BX] 
            MOV ERROR[BX], AX
            ADD BX, 2
            LOOP PUTT_LOOP
            
          ;-------------- UPDATING THETA ------------------
           
           
           MOV SI, 0
        THETA_LOOP:
           
           ; SLICING X
              PUSH OFFSET X
              PUSH SI
              CALL SLICE
            ;--------------
            
           ; ERR[J].X[:,J]
           PUSH OFFSET ERROR
           PUSH OFFSET COL_MATRIX
           CALL MAT_MUL       ; RESULT IN C => [1 X 1]
         
          ; ERR[J].X[:,J] / ALPHA * (NUMBER_OF_ELEMENTS)
           MOV AX, C[4]    ; FIRST ITEM
           XOR DX,DX
           CWD
           IDIV ALPHA       
           
           XOR DX,DX
           CWD
           IDIV X[2]
           
           SHL SI,1             ; [2*SI] >> EVERY INDEX IS 2 BYTE
           SUB THETA[SI+4], AX  ;    +4  >> FOR (ROW, COL) INDICES
           SHR SI,1
           
           INC SI
           
           CMP SI, THETA[2]
         JL THETA_LOOP
           
         DEC EPOCHS 
       JNZ FIT

       RET
    LINEAR_REGRESSION ENDP
      