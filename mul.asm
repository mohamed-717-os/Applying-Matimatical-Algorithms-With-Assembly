.model small
.386
 .data 

A DW 100 DUP(0)
B DW 100 DUP(0)
C DW 100 DUP(0)

row_input DB 'enter the number of rows: $'
col_input DB 'enter the number of columns: $'
row_elements DB 'enter the elements of the rows for matrix  (space separated): ', 13, 10, '$'
RESULT_MSG DB 'RESULT: ',10,13,'$'

 .code 
    MAIN proc far
      .STARTUP
            CALL INPUT
            CALL MULTIPLICATION
            LEA DX,RESULT_MSG
            MOV AH,9H
            INT 21H
            CALL PRINT_ARRAY          
      .EXIT
    MAIN endp

;=============================================================================
;============================================================================= 
;                           TAKING MATRIX AS INPUT

        INPUT PROC
        
        ; Reading Matrix A
        
        LEA DX, row_input ; Read row num
        MOV AH, 9h 
        INT 21h 
        
        CALL read_number
        MOV A[0], BX   ; Store number of rows
        
        LEA DX, col_input ; Read col num
        MOV AH, 9h 
        INT 21h 
        
        CALL read_number
        MOV A[2], BX   ; Store number of columns
        
        ; Read elements of A
        LEA DX, row_elements
        MOV AH, 9h 
        INT 21h
        
        MOV DX, A[0] ; Number of rows
        MOV AX, A[2] ; Number of cols
        MUL DX        ; Rows * Cols = Number of elements
        
        MOV CX, AX
        MOV SI, OFFSET A[4]
        
    row_input_loop_A:
        ; Read row element
        CALL read_number
        MOV [SI], BX
        ADD SI, 2
        DEC CX
        JNZ row_input_loop_A

        
        ; Reading Matrix B
        
        
        LEA DX, row_input 
        MOV AH, 9h 
        INT 21h 
        
        CALL read_number
        MOV B[0], BX   
        
        LEA DX, col_input 
        MOV AH, 9h 
        INT 21h 
        
        CALL read_number
        MOV B[2], BX   
        
        LEA DX, row_elements
        MOV AH, 9h 
        INT 21h
        
        MOV DX, B[0] 
        MOV AX, B[2] 
        MUL DX        
        
        MOV CX, AX
        MOV SI, OFFSET B[4]
        
    row_input_loop_B:
        
        CALL read_number
        MOV [SI], BX
        ADD SI, 2
        DEC CX
        JNZ row_input_loop_B
        RET
        INPUT ENDP
; ===============================================================
    read_number PROC 
        MOV BX, 0
    read_num:
        MOV AH, 01h 
        INT 21h
        
        CMP AL, ' '
        JE done_reading
        CMP AL, 0dh  
        JE done_reading
        
        XOR AH, AH
        SUB AL, '0'

        SHL BX, 5
        ADD BX, AX
        
        JMP read_num
     
    done_reading:
        RET
    read_number ENDP   
;=============================================================================
;=============================================================================   
;                            MATRIX MULTIPLICATION

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
;=============================================================================
;============================================================================= 
;                           GETTING INDEX IN MATRIX  

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
;============================================================================= 
;                           PRINT NUMBER                          
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
;=============================================================================
;                               PRINT ARRAY  
                         
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