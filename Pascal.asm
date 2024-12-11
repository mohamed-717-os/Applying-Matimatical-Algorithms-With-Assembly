; PROSEDURES IN THIS FILE IS:
    ; * FACTORIAL      , (AND IT'S CALL PROC)
    ; * PERMUTATIONS   , (AND IT'S CALL PROC)
    ; * COMBINATION    , (AND IT'S CALL PROC)
    ; * PASCAL         , (AND IT'S CALL PROC)
    ; * PRINT_TRIANGLE


.model small
.CODE 

;=============================================================================
;                           PASCAL CALL
;=============================================================================
PASCAL_CALL PROC

    LEA DX,PT_MSG
    MOV AH,9H
    INT 21H
    
    CALL read_number

    ; CLEAR ARRAY         
        PUSH OFFSET TRI
        PUSH 20
        CALL CLEAR_ARRAY  
        
    CALL PASCAL
    
        
    CALL PRINT_TRIANGLE
    
    RET

PASCAL_CALL ENDP

;=============================================================================
;                           FACTORIAL CALL
;=============================================================================
FACT_CALL PROC

    XOR EBX,EBX
    
    LEA DX,FACT_MSG
    MOV AH,9H
    INT 21H
    CALL read_number
    
    LEA DX,NUM_RESULT_MSG
    MOV AH,9H
    INT 21H
    
    CALL FACTORIAL
    
    MOV EAX,EBX  
    CALL DRAW_NUM
    
    RET

    FACT_CALL ENDP

;=============================================================================
;                           COMBINATION CALL
;=============================================================================

COMP_CALL PROC
    
    MOV N,0
    MOV R,0
    
    LEA DX, INPUT_MSG
    MOV AH,9H
    INT 21H
    
    CALL read_number
    MOV N,EBX
    
        MOV AH, 2h      
        MOV DL, 'C'  
        INT 21h         
        MOV DL, ' '
        INT 21H
        
    CALL read_number
    MOV R,EBX
    
        MOV AH, 2h      
        MOV DL, '='  
        INT 21h         
        MOV DL, ' '
        INT 21H
        
    PUSH N
    PUSH R
    
    XOR EAX,EAX
        
    CALL COMP
    CALL DRAW_NUM
     
    RET 

COMP_CALL ENDP


;=============================================================================
;                           PERMUTATION CALL
;=============================================================================

    PER_CALL PROC
    
    MOV N,0
    MOV R,0

    LEA DX, INPUT_MSG
    MOV AH,9H
    INT 21H
    
    CALL read_number
    MOV N,EBX
    
        MOV AH, 2h      
        MOV DL, 'P'  
        INT 21h         
        MOV DL, ' '
        INT 21H
        
    CALL read_number
    MOV R,EBX
    
        MOV AH, 2h      
        MOV DL, '='  
        INT 21h         
        MOV DL, ' '
        INT 21H
        
    PUSH N
    PUSH R
    
    XOR EAX,EAX
    
    CALL PER
    CALL DRAW_NUM
     
    RET 

    PER_CALL ENDP
    
;=============================================================================
;                        FUNCTIONS ALGORITHM 
;============================================================================= 


;=============================================================================
;                           PASCAL TRIANGLE
;=============================================================================

    PASCAL PROC     
    
    MOV SI,OFFSET TRI
    MOV HEIGHT,EBX
    MOV T,0
        OUTER:
            MOV I,0
        INNER:
            PUSH T
            PUSH I
            CALL COMP
            
            MOV [SI],EAX
            
            ADD SI,4
            INC I
            MOV ECX,T
            CMP I,ECX
            JLE INNER
            INC T
            MOV ECX,T
            CMP ECX,HEIGHT
            JL OUTER
            
            RET
            
    PASCAL ENDP
    
;============================================================================= 
;                               COMBINATION
;=============================================================================
COMP PROC

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
    
    RET 8
    COMP ENDP
    
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
    RET 8
    PER ENDP

;=============================================================================
;                               FACTORIAL
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
;                               PRINT TRIANGLE  
;============================================================================= 
                         
     PRINT_TRIANGLE PROC
     
            
        MOV ECX,CSIZE 
        MOV EBX,0
        MOV EDI,I
        MOV NUM,EDI
        MOV T,0
        MOV SI,0
        LEA SI,TRI
        PRINT_TROW:
        CENTER:
        MOV DL, ' '
           MOV AH, 2
           INT 21H
           DEC NUM
           JNZ CENTER

       START1:
                      
           MOV EAX, [SI]           
           CMP EAX,0
           JE PFINISH
           PUSH EBX
           CALL DRAW_NUM
           
           MOV DL, ' '
           MOV AH, 2
           INT 21H
           
           ADD SI,4
           
           POP EBX
           INC EBX          
           CMP EBX,T
           JLE START1
           
           MOV DL,10    ; next row
           MOV AH, 2
           INT 21H
           
           MOV EBX,0
           DEC I
           
           MOV EDI,I
           MOV NUM,EDI
           
           INC T
           MOV EDI,T
           CMP EDI,HEIGHT
           JL CENTER
           JE PFINISH

           PFINISH: 
           RET
           PRINT_TRIANGLE ENDP  
     