.MODEL Small

.STACK 100h

.data 

A DW ?
B DW ?
C DW ?

row_input DB 'enter the number of rows: $'
col_input DB 'enter the number of columns: $'
row_elements DB 'enter the elements of the rows for matrix  (space separated): ', 13, 10, '$'


.CODE 
    main PROC 
    MOV AX, @data
        MOV DS, AX
        
        
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

        
        .EXIT
    main ENDP

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

END main
