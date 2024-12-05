.model small
.386 
.DATA
    HEIGHT DD 8
    N DD 0 ; -> HEIGHT
    I DD 0 ; -> N
    CSIZE DD 0 ; -> RESULT'S SIZE
    NUM DD ?
    C DD 100 dup(0)
.CODE 
MAIN PROC
    .STARTUP
    CALL PASCAL
    CALL PRINT_ARRAY

    .EXIT
    MAIN ENDP
;=============================================================================
;                           PASCAL TRIANGLE
    PASCAL PROC
         MOV SI,OFFSET C
        OUTER:
            MOV I,0
        INNER:
            PUSH N
            PUSH I
            CALL COMB
            ADD SP,8
            
            MOV [SI],EAX
            ADD SI,4
            INC I
            MOV ECX,N
            CMP I,ECX
            JLE INNER
            INC N
            MOV ECX,N
            CMP ECX,HEIGHT
            JL OUTER   
            RET
    PASCAL ENDP
 ;============================================================================= 
;                       COMBINATION
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
;============================================================================= 
;                               PRINT ARRAY  
                         
     PRINT_ARRAY PROC
        MOV ECX,CSIZE 
        MOV EBX,0
        MOV EDI,I
        MOV NUM,EDI
        MOV N,0
        MOV SI,0
        LEA SI,C
       PRINT_ROW:
        CENTER:
        MOV DL, ' '
           MOV AH, 2
           INT 21H
           DEC NUM
           JNZ CENTER

        START:
                      
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
           CMP EBX,N
           JLE START
           
           MOV DL,10    ; next row
           MOV AH, 2
           INT 21H
           
           MOV EBX,0
           DEC I
           
           MOV EDI,I
           MOV NUM,EDI
           
           INC N
           MOV EDI,N
           CMP EDI,HEIGHT
           JL CENTER
           JE PFINISH

           PFINISH: 
           RET
           PRINT_ARRAY ENDP  
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
END
    