.model small
.386
<<<<<<< HEAD
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
=======
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
>>>>>>> 2e7d82ae06215881e5b9a29ddb0ec9963fe42d60
            CALL PRINT_ARRAY          
      .EXIT
    MAIN endp

;=============================================================================
;                           TAKING MATRIX AS INPUT
;============================================================================= 

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
;                        READ NUMBER
; ===============================================================
    read_number PROC 
    ;BX <= NUM
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
;                            MATRIX MULTIPLICATION
;=============================================================================   

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
;=============================================================================
;                           GETTING INDEX IN MATRIX  
;============================================================================= 

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
;                           PRINT NUMBER                          
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
;                               PRINT ARRAY  
;=============================================================================
           ; ARRAY [ROW,COL, ..ELEMENTS..]              
     PRINT_ARRAY PROC
                        
            MOV DI,C[2] ; STORING COL'S NUM
            MOV SI,4    ; POINT TO THE FIRST ELEMENT
            MOV CX, C[0] ; STORING ROW'S NUM
       PRINT_ROW:
            MOV AX,C[SI]
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