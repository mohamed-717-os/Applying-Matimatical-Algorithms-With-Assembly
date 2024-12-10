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

        
    ;---------------- MATRIX VARIABLES -------------------      
      ; THERE IS 2 INDICES BEFORE THE CONTENT OF THE MATRIX
          ; THE FIRST INDEX IS THE NUMBER OF ROWS
          ; THE SECOND INDEX IS THE NUMBER OF COLUMNS
        
        
      COL_MATRIX DW 30 DUP(0) ; FOR SEPARATING  A COLUMN FROM THE MATRIX
        ; Result matrix (C)
        C DW 30 DUP(0)
        
        ROW_NUM DW ?
        COL_NUM DW ?
    ;------------------------------------------------------

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
             CALL MULTIPLICATION        ; RESULT IN C
             
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
           CALL MULTIPLICATION       ; RESULT IN C => [1 X 1]
         
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
; ===========================================================================  
   ; //////////////////////  MATRIX SLICING   ////////////////////////
   
   SLICE PROC
    ; SEPARATE A ROW FROM THE MATRIX AND TURN IT TO ONE COLUMN (N*1)
       PUSHA
       MOV BP, SP
       
       MOV SI, [BP+20]  ; MATRIX OFFSET
       MOV BX, [BP+18]  ; COL INDEX
       
       MOV AX, SI[2]
       MOV COL_MATRIX[0], AX   ; TURNING COLS TO ROWS
       
       MOV AX, 1
       MOV COL_MATRIX[2], AX  ; MAKE IT ONE COLUMN
       
    ;------------------------------------
       MOV AX, COL_MATRIX[0]     ; NUMBER OF ELEMENTS IN THE MATRIX ROW (NUMBER_OF_COLS)
       SHL BX,1                 ; (COLUMN_INDEX * 2) >> EVERY ELEMENT TAKE 2 BYTES
       
       XOR DX, DX
       IMUL BX              ; 2 * COLUMN_INDEX * (NUMBER_OF_COLS)  
                                ; >> THE ADDRES OF THE FIRST ELEMENT IN THE COLUMN
       MOV BX, AX
       ADD BX, 4    ; 4 BYTES FOR THE FIRST 2 INDICES
       
       MOV DI, 4 ; FIRST ELEMENT
       MOV CX, COL_MATRIX[0]
       
   SLICE_LOOP:
       MOV AX, SI[BX]
       MOV COL_MATRIX[DI], AX
       
       ADD BX, 2  
       ADD DI, 2
       LOOP SLICE_LOOP
       
       POPA
       RET 4
   SLICE ENDP
; ===========================================================================  
   ; //////////////////////  MATRIX MULTIPLICATION  ////////////////////////
; =========================================================================== 
    MULTIPLICATION PROC 
        PUSHA
        MOV BP, SP
        
        MOV SI, [BP+20]  ; SI = A
        MOV DI, [BP+18]  ; DI = B
        
      ; CLEAR C         
        PUSH OFFSET C
        PUSH 30
        CALL CLEAR_ARRAY  
        
      ; ITIALIZE ROWS AND COLS OF THE RESULT
        MOV AX, SI[0]
        MOV C[0], AX
        
        MOV AX, DI[2]
        MOV C[2], AX
        
        ;--------------
        
        MOV ROW_NUM,0
        ROW_LOP:
           
            MOV COL_NUM,0
            COL_LOP:
               
                MOV CX,0
                MUL_LOP:
                
                 ;GET A'S INDEX
                   PUSH SI[2]      ; NUM OF COLS
                   PUSH ROW_NUM        ; INDEX OF ROW
                   PUSH CX        ; INDEX OF COL
                   CALL MAT_INDEX      
                   
                   MOV AX,SI[BX] ;STORING A'S ELEMENT
                   
                   ;GET B'S INDEX
                   PUSH DI[2]
                   PUSH CX
                   PUSH COL_NUM
                   CALL MAT_INDEX 
                   
                   XOR DX, DX
                   IMUL DI[BX]  ;  A[ROW_NUM, CX] * B[CX, COL_NUM]
                   
                   ;GET C'S INDEX
                   PUSH DI[2]
                   PUSH ROW_NUM
                   PUSH COL_NUM
                   CALL MAT_INDEX
                   
                   ADD C[BX],AX ; STORING THE RESULT IN C[ROW_NUM, COL_NUM]
       
                   INC CX
                   CMP CX,SI[2]
                   JL MUL_LOP
                   
               INC COL_NUM
               
               MOV AX, DI[2]
               CMP COL_NUM, AX
               JL COL_LOP
            
            INC ROW_NUM
            
            MOV AX, SI[0]
            CMP ROW_NUM, AX
            JNZ ROW_LOP
        
        POPA
        RET 4
    MULTIPLICATION ENDP       
                                                
; ========================================================================
   ; //////////////////////  RETURN MATRIX INDEX ////////////////////////   
; ========================================================================   
    MAT_INDEX PROC 
   ; MAT_INDEX (C, I, J)         
   ;  => BX: C * I + J
   ;      C = (NUM OF COLS IN THE MATRIX) 
   ;      I = (ROW INDEX) 
   ;      J = (COL INDEX)
   
   
        push BP
        MOV BP, SP
        
        PUSH SI
        PUSH DI
        PUSH AX
        
        MOV AX, [BP+8]  ;>> AX = C
        MOV SI, [BP+6]  ;>> SI = I
        MOV DI, [BP+4]  ;>> DI = J
        
        MUL SI       ; AX = C * I
        ADD AX, DI
        MOV BX, AX
        
        ADD BX, 2   ; ADD 2 FOR ROW AND COL
        SHL BX,1    ; THEN MULTIPLY BY 2 BYTES FOR EVERY INDIX
        
        POP AX
        POP DI
        pop SI
        POP BP
        
        RET 6
    MAT_INDEX ENDP
;==================================================================================
   ; //////////////////////  PRINTING HEXA AS DECEMAL NUMS ////////////////////////   
; =====================================================================================   
    DRAW_NUM PROC
    
     ; AX: NUM  
       
        PUSHA
        MOV BP, SP  ; SAVE THE CURRENT STACK POINTER IN (BP)
        
      CONVERT:
    
        MOV BX,10
        MOV DX,0
        DIV BX     ; AX = AX / 10
        ADD DX,48  ; CONVERT REMAINDER INTO ASCII
        
        PUSH DX
        
        CMP AX, 0
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
       POPA
       RET 
    DRAW_NUM ENDP

; =====================================================================================
   ; //////////////////////  DELETE ELEMENTS FROM THE ARRAY  ////////////////////////
; =====================================================================================
    CLEAR_ARRAY PROC
        PUSHA  
        MOV BP, SP
        MOV SI, [BP+20]  ;> ARRAY OFFSET
        MOV CX, [BP+18]  ; LENGTH TO DELETE
          
       CLEAR:
       
          MOV AX, 0
          MOV [SI], AX
          ADD SI, 2
          
         LOOP CLEAR
       
       POPA    
       RET 4
    CLEAR_ARRAY ENDP
;=============================================================================

   PRINT_THETA PROC 
       PUSHA 
       
       mov SI, 4
        P:
            MOV AX, THETA[SI]
            CALL DRAW_NUM 
            
            MOV DL, ' '
            MOV AH, 2
            INT 21H
            
            ADD SI, 2
            CMP SI, 8
            JL P  
            
            MOV DL, 10
            MOV AH, 2
            INT 21H
     
        POPA
        RET     
   PRINT_THETA ENDP
;=============================================================================
;============================================================================= 
     PRINT_ARRAY PROC     
            MOV DI,C[2]
            MOV SI,4
            MOV CX, C[0]
       PRINT_ROW:
           MOV AX, C[SI]
           CALL DRAW_NUM
           MOV DL, ' '
           MOV AH, 2
           INT 21H
           
           ADD SI,2
           DEC DI

           JNZ PRINT_ROW
                              
        PRINT_COL:
           MOV DI,C[2]
           
           MOV DL, 10
           MOV AH, 2
           INT 21H

           LOOP PRINT_ROW
           RET
           PRINT_ARRAY ENDP  
;=============================================================================  
