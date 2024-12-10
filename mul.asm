.model small
.386
 .data
 
 ; THERE IS 2 INDICES BEFORE THE CONTENT OF THE MATRIX
 ; THE FIRST INDEX IS THE NUMBER OF ROWS
 ; THE SECOND INDEX IS THE NUMBER OF COLUMNS
    
    ; First matrix (A)
    A DW 1,4,  -5,-6,-7,-8 ; ROW,COL,  ELEMENTS
    ; Second matrix (B)
    B DW 4,1,  1,2,3,4
    C DW 1,1,  0,0,0,0
    ; Result matrix (C)
    
    ROW_NUM DW ?
    COL_NUM DW ?
       
.code 
 ; =========================================================== 
    MAIN proc far
      .STARTUP
            PUSH OFFSET A
            PUSH OFFSET B
            CALL MULTIPLICATION
            ADD SP, 4
            CALL PRINT_ARRAY          
      .EXIT
    MAIN endp
    
; ===========================================================   
;              MATRIX MULTIPLICATION

    MULTIPLICATION PROC 
        PUSHA
        MOV BP, SP
        
        MOV SI, [BP+20]  ; SI = A
        MOV DI, [BP+18]  ; DI = B
        
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
                   ADD SP, 6       
                   
                   MOV AX,SI[BX] ;STORING A'S ELEMENT
                   
                   ;GET B'S INDEX
                   PUSH DI[2]
                   PUSH CX
                   PUSH COL_NUM
                   CALL MAT_INDEX
                   ADD SP, 6  
                   
                   MUL DI[BX];THE RESULT OF C[ROW_NUM, COL_NUM]
                   
                   ;GET C'S INDEX
                   PUSH DI[2]
                   PUSH ROW_NUM
                   PUSH COL_NUM
                   CALL MAT_INDEX
                   ADD SP, 6  
                   
                   ADD C[BX],AX ;STORING THE RESULT
                   
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