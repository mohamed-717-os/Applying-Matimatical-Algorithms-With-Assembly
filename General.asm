;=============================================================================
;                     Procedures In This File Are:
;============================================================================= 
;                     1- COMBINATION
;                     2- PERMUTATIONS
;                     3- FACTORIAL
;                     4- PRINT NUMBER
;                     5- PRINT ARRAY
;=============================================================================

.MODEL SMALL
.386
.DATA
N DD 3
R DD 2
.CODE
    MAIN PROC FAR
      .STARTUP       
      PUSH N 
      PUSH R
      CALL PER
      ADD SP,8
      CALL DRAW_NUM
      .EXIT
    MAIN ENDP
;=============================================================================
;                       COMBINATION
;============================================================================= 
    COMB PROC

    ; EAX <= RESULT
    PUSH EDI
    PUSH ECX
    PUSH EBX
    
    MOV BP,SP
    MOV EDI,[BP+14] ;=> R
    MOV ECX,[BP+18] ;=> N
    
    MOV EBX,ECX   
    CALL FACTORIAL
    PUSH EBX    ;=> N!
    
    MOV EBX,EDI   
    CALL FACTORIAL    
    
    
    MOV EAX,EBX ;=> R!
   
        
    SUB ECX,EDI ;=> (N-R)    
    MOV EBX,ECX
    CALL FACTORIAL  ; EBX = (N-R)!
    
    
    MUL EBX ;=> R! * (N-R)!     
    MOV EBX,EAX ; EBX = R! * (N-R)! 
    
    
    POP EAX ;=> N!
    XOR EDX,EDX
    DIV EBX ;=> N! / I! * (N-I)!
    
    POP EBX
    POP ECX
    POP EDI
    RET
    COMB ENDP
;============================================================================= 
;                       PERMUTATIONS
;============================================================================= 
    PER PROC

    ; EAX <= RESULT
    PUSH EDI
    PUSH ECX
    PUSH EBX
    
    MOV BP,SP
    MOV EDI,[BP+14] ;=> R
    MOV ECX,[BP+18] ;=> N
    
    MOV EBX,ECX   
    CALL FACTORIAL
    PUSH EBX    ;=> N!
    
    MOV EBX,EDI   
    CALL FACTORIAL    
   
        
    SUB ECX,EDI ;=> (N-R)    
    MOV EBX,ECX
    CALL FACTORIAL  ; EBX = (N-R)!    
    
    POP EAX ;=> N!
    XOR EDX,EDX
    DIV EBX ;=> N! /(N-I)!
    
    POP EBX
    POP ECX
    POP EDI
    RET
    PER ENDP
;=============================================================================
;                        FACTORIAL
;=============================================================================    
    FACTORIAL proc
    ; EBX <= NUM   LOCATION OF STORING
    ; EBX = INPUT
    PUSH EAX    
    MOV EAX, 1 ; Multiply neutral    
    REC:
    CMP EBX,0
    JE FINISHED 
    MUL EBX
    DEC EBX 
        Jnz REC ;Exit WHEN BX BECAME 0
        JMP FINISHED
     
    FINISHED:
        MOV EBX,EAX
        POP EAX
        RET
  FACTORIAL ENDP
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
           MOV AX, [SI]
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
