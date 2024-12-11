; PROSEDURES IN THIS FILE IS:
    ; * MAT_CALL  
    ; * INPUT  ( HOW THE USER ENTER THE MATRICES VALUES  
    ; * MAT_MUL 
    ; * MAT_INDEX (TO KNOW THE INDEX FROM THE ROW & COL
    ; * SLICE    ( SLICE A ROW FROM THE MATRIX AND TURN IT TO A COLUMN) >> USED IN LR
    ; * CLEAR_ARRAY
    ; * PRINT_ARRAY
    
.model small
.386 
.code
MAT_CALL PROC

    CALL INPUT    
        MOV AX,A[2]
        CMP AX,B[0]
        JNE NOT_VERIFIEDD
        
     
    PUSH OFFSET A             
    PUSH OFFSET B
    CALL MAT_MUL  ; RESULT IN C
      
    CALL PRINT_ARRAY
    JMP VERIFIED
    
NOT_VERIFIEDD:
   LEA DX,NOT_VERIFIED
   MOV AH,9H
   INT 21H
  
   JMP START_POINT
   
VERIFIED:
    RET

MAT_CALL ENDP


;=============================================================================
;                           TAKING MATRIX AS INPUT
;============================================================================= 

        INPUT PROC
        
        PUSHA
        
        ; CLEAR A         
        PUSH OFFSET A
        PUSH 30
        CALL CLEAR_ARRAY  
        
        ; CLEAR B         
        PUSH OFFSET B
        PUSH 30
        CALL CLEAR_ARRAY  
        
        MOV SI, OFFSET A
        MOV CX, 1
      MAT_INPUT_LOOP:
    
       ; DEFINE ROWS AND COLS
        LEA DX, MAT_INPUT 
        MOV AH, 9h 
        INT 21h 
        
        MOV AX, CX     ; MATRIX 1 OR 2
        CALL DRAW_NUM

        MOV AH, 2h 
        MOV DL, ':' ; Read row num
        INT 21h 
        MOV DL, ' ' ; Read row num
        INT 21h 
        
        CALL read_number
        MOV SI[0], BX   ; Store number of rows
                
        
        MOV AH, 2h      
        MOV DL, 'x'  
        INT 21h         
        MOV DL, ' '
        INT 21H
        
        CALL read_number
        MOV SI[2], BX   ; Store number of columns
        
      ; READING THE VALUES OF THE MATRIX
        LEA DX, MAT_ELEMENTS
        MOV AH, 9h 
        INT 21h
        
        MOV DX, SI[0] ; Number of rows
        MOV AX, SI[2] ; Number of cols
        MUL DX        ; AX = Rows * Cols = Number of elements
        
        ADD SI, 4
        
    ENTER_MAT_VALUES:
        ; Read row element
        CALL read_number
        MOV [SI], BX
        ADD SI, 2
        DEC AX
        JNZ ENTER_MAT_VALUES
    
      MOV SI, OFFSET B
      INC CX
      CMP CX, 2
      JLE MAT_INPUT_LOOP        
        POPA
        RET
        INPUT ENDP

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