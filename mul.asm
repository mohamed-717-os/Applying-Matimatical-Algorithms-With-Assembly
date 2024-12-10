.model small
.386 
.code
;=============================================================================
;                           TAKING MATRIX AS INPUT
;============================================================================= 

        INPUT PROC
        
        PUSHA
        
        ; CLEAR A         
        PUSH OFFSET A
        PUSH 10
        CALL CLEAR_ARRAY  
        
        ; CLEAR B         
        PUSH OFFSET B
        PUSH 10
        CALL CLEAR_ARRAY  
        
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
        LEA DX, MAT_ELEMENTS
        MOV AH, 9h 
        INT 21h

        MOV BX, A[0] ; Number of rows
        MOV AX, A[2] ; Number of cols
        MUL BX        ; Rows * Cols = Number of elements
  
        MOV CX, AX
        MOV SI, OFFSET A[4]
        
    row_input_loop_A:
        ; Read row element
        CALL read_number
        MOV [SI], BX
        ADD SI, 2
        LOOP row_input_loop_A

        
        ; Reading Matrix B
        
        
        LEA DX, row_input 
        MOV AH, 9h 
        INT 21h 
        
        CALL read_number
        CMP A[2] ,BX
        
        JNE WRONG_MATINPUT
        
        MOV B[0], BX   
        
        LEA DX, col_input 
        MOV AH, 9h 
        INT 21h 
        
        CALL read_number
        MOV B[2], BX   
        
        LEA DX, MAT_ELEMENTS
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
        JMP END_MATINPUT
        
      WRONG_MATINPUT:
        
            LEA DX,NOT_VERIFIED
            MOV AH,9H
            INT 21H
    
        END_MATINPUT:
            
        POPA
        RET
        INPUT ENDP
; ===============================================================
;                        READ NUMBER
; ===============================================================

    read_number PROC 
    PUSH SI
    PUSH AX
    PUSH CX
    MOV BX, 0
    read_num:
        MOV AH, 01h 
        INT 21h
        
        CMP AL, 0dh  
        JE done_reading
        CMP AL, ' '  
        JE done_reading
        
        XOR AH, AH
        SUB AL, '0'
        
        mov si , ax
        mov ax , bx 
        xor dx , dx 
         
        mov cx , 10 
        
        mul cx
        add si , ax 
        mov bx , si 
        
        JMP read_num
        
    done_reading:
        POP CX
        POP AX
        POP SI
        RET
   read_number ENDP
   
;=============================================================================
;                            MATRIX MULTIPLICATION
;=============================================================================   

    MAT_MUL PROC 
        
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
        MAT_MUL ENDP       
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
        
        RET 6
    MAT_INDEX ENDP
    
; ===========================================================================  
; /////////////////////////  MATRIX SLICING   ///////////////////////////////
; ===========================================================================
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
                      
;=============================================================================
;                           PRINT NUMBER                          
;============================================================================= 
    DRAW_NUM PROC
    
    ; EAX: NUM  
        PUSHA
        MOV BP, SP  ; SAVE THE CURRENT STACK POINTER IN (BP)
        
      CONVERT:
    
        MOV EBX,10
        MOV EDX,0
        DIV EBX     ; AX = AX / 10
        ADD EDX,48  ; CONVERT REMAINDER INTO ASCII
        
        PUSH DX
        
        CMP EAX, 0
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
;=============================================================================
;                               PRINT ARRAY  
;=============================================================================
           ; ARRAY [ROW,COL, ..ELEMENTS..]              
     PRINT_ARRAY PROC
     
     LEA DX,ARRAY_RESULT_MSG
            MOV AH,9H
            INT 21H
            
            
            MOV DI,C[2] ; STORING COL'S NUM
            MOV SI,4    ; POINT TO THE FIRST ELEMENT
            MOV CX, C[0] ; STORING ROW'S NUM
            
       PRINT_ROW:
            
            MOV AH,2H
            MOV DL,'|'
            INT 21H
            MOV AX,C[SI]
           CALL DRAW_NUM
           MOV AH,2H
           MOV DL,'|'
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
; =====================================================================================
   ; //////////////////////  DELETE ELEMENTS FROM THE ARRAY  ////////////////////////
; =====================================================================================
    CLEAR_ARRAY PROC
        PUSHA  
        MOV BP, SP
        MOV SI, [BP+20]  ;> ARRAY OFFSET
        MOV CX, [BP+18]  ; LENGTH TO DELETE
          
    CLEAR1:
       
          MOV AX, 0
          MOV [SI], AX
          ADD SI, 2
          
          LOOP CLEAR1
       
       POPA    
       RET 4
    CLEAR_ARRAY ENDP
;============================================================================= 