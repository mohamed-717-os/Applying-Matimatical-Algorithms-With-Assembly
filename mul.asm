.model small
.386
 .data
    ; First matrix (A)
    A DW 2,2,  1,2,3,4 ; ROW,COL,  ELEMENTS
    ; Second matrix (B)
    B DW 2,2,  2,4,6,8
    ; Result matrix (C)
    C DW 2,2,  0,0,0,0
    COUNT_ELEMENT DW 4 ; NUMBER OF MATRIX ELEMENTS
    ; YOU MUST ADD 2 FOR EVERY INDEX 
 .code 
    MAIN proc far
      .STARTUP
            CALL MULTIPLICATION
            CALL PRINT_ARRAY          
      .EXIT
    MAIN endp
    
; ===========================================================   
;              MATRIX MULTIPLICATION

    MULTIPLICATION PROC 
        POP BP
      ; ITIALIZE ROWS AND COLS OF THE RESULT
        MOV AX, A[0]
        MOV C[0], AX
        
        MOV AX, B[2]
        MOV C[2], AX
        ;--------------
        
        MOV CX,0
        ROW_LOP:
            MOV SI,0
           
            COL_LOP:
                MOV DI,0
               
                MUL_LOP:
                   ;GET A'S INDEX
                   PUSH A[2]
                   PUSH CX
                   PUSH DI
                   CALL MAT_INDEX
                   MOV AX,A[BX] ;STORING A'S ELEMENT
                   
                   ;GET B'S INDEX
                   PUSH B[2]
                   PUSH DI
                   PUSH SI
                   CALL MAT_INDEX
                   
                   MUL B[BX];THE RESULT OF C[CX, SI]
                   
                   ;GET C'S INDEX
                   PUSH B[2]
                   PUSH CX
                   PUSH SI
                   CALL MAT_INDEX
                   
                   ADD C[BX],AX ;STORING THE RESULT
                   
                   INC DI
                   CMP DI,A[2]
                   JL MUL_LOP
                   
                   INC SI
                   CMP SI,B[2]
                   JL COL_LOP
                
            INC CX
            CMP CX,A[0]
            JNZ ROW_LOP
        PUSH BP     
        RET
    MULTIPLICATION ENDP       
                        
; ===========================================================   
    MAT_INDEX PROC 
   ; MAT_INDEX (C, I, J)         
   ;  => BX: C * I +J
   ;      C = (NUM OF COLS IN THE MATRIX) 
   ;      I = (ROW INDEX) 
   ;      J = (COL INDEX)
   
   ;    C = [BP + 6]
   ;    I = [BP + 4]
   ;    J = [BP + 2]
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
        
        ADD BX, 2
        SHL BX,1
        
        POP AX
        POP DI
        pop SI
        POP BP
        RET
    MAT_INDEX ENDP
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
END MAIN