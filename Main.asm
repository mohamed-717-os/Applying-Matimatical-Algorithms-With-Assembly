.MODEL SMALL
.386
INCLUDE DATA.ASM
INCLUDE matmul.ASM
INCLUDE Pascal.ASM
INCLUDE Draw.ASM
INCLUDE Fibonaci.ASM
INCLUDE DOCS.ASM
INCLUDE General.ASM


.CODE

MAIN PROC FAR
.STARTUP
CALL START

.EXIT
MAIN ENDP
;==================================================================
;==================================================================
;                          INPUT
;==================================================================
;==================================================================

START PROC 

    DISPLAY_DOC:
        CALL DOC_PAGE
        
    START_POINT:
        
       ; MAKING A NEW LINE 
        MOV AH,2H
        MOV DL,10
        INT 21H
        MOV DL,13
        INT 21H

            
        ; PRINTING [>]
        MOV DL,10h        
        INT 21H 
        
        MOV SI, 0
        MOV CX, OPS_NUM  
          CLEAR:
              MOV OPS[SI], 1
              ADD SI, 2
              LOOP CLEAR
        
     ; MAKING ARRAY OF THE MASEGES OFFSETS
         MOV OPS_OFSTS[0], OFFSET HELP
         MOV OPS_OFSTS[2], OFFSET LINEAR_DEF
         MOV OPS_OFSTS[4], OFFSET MATRIX_DEF
         MOV OPS_OFSTS[6], OFFSET PASCAL_DEF
         MOV OPS_OFSTS[8], OFFSET FIBONACCI_DEF
         MOV OPS_OFSTS[10], OFFSET COMPINATION_DEF
         MOV OPS_OFSTS[12], OFFSET PERMUTATION_DEF
         MOV OPS_OFSTS[14], OFFSET FACTORIAL_DEF
         MOV OPS_OFSTS[16], OFFSET EXIT
         MOV OPS_OFSTS[18], OFFSET CLEAR_SCREEN

        MOV Q,0
    MAIN_read_num:
        MOV AH, 01h 
        INT 21h
        
        CMP AL, 0dh
        JNE PASS

    DONE:
        CMP Q, 0        ; IF IT IS THE FIRST CHARACTER
        JE START_POINT  ; AND IT IS <ENTER> : READ AGAIN
        
        MOV AL,'$'
        
    PASS:
        MOV SI, OFFSET OPS_OFSTS 
        MOV BX, -2  ; REFERS TO THE OPERATION
        
  ; CHEKING THE MACHED OPERATION                  
    CHECK_OP:
        ADD BX, 2
        
        MOV BP, OPS_NUM
        SHL BP, 1
        
        CMP BX, BP
        JE FINISH

        CMP OPS[BX], 0
        JE CHECK_OP
        
    ;SETTING INDEX  
     MOV DI, [SI+BX]   ; > DI = OPERATION OFFSET
     ADD DI, Q         ; > DI = LETTER OFFSET
     
     CMP AL ,[DI]
     JE CHECK_OP       ; IF [DI] = INPUT LETTER THEN OPS[BX] STAYS 1
       MOV OPS[BX], 0      ; IF THE OPERATION DON'T MATCH: OPS[BX] = 0
       JMP CHECK_OP

FINISH:
    INC Q
    CMP AL, '$' 
    JNE MAIN_read_num
    
     
    MOV BX, 0
    MOV CX, OPS_NUM    
    CHOOSED:
        CMP OPS[BX], 1  ;GETTING THE CHOSEN OPERATION  
        JE DETECT
          ADD BX, 2
      LOOP CHOOSED
        JMP WRONG_INPUT           
        

;==================================================================                
;////////////////////DETECT CHOSEN OPERATION/////////////////////// 
;================================================================== 

     DETECT:
     SHR BX, 1
     
     CMP BX,0     
     JE EHELP
     
     CMP BX,1
     JE ELINEAR
     
     CMP BX,2
     JE EMATRIX

     CMP BX,3
     JE EPASCAL

     CMP BX,4
     JE EFIBONACCI
     
     CMP BX,5
     JE ECOMPINATION
 
     CMP BX,6
     JE EPERMUTATION

     CMP BX,7
     JE EFACTORIAL
     
     CMP BX,8
     JE EEXIT
     
     CMP BX,9
     JE ECLEAR
     
;==================================================================
;==================================================================                
;/////////////////////EXCUTE CHOSEN OPERATION//////////////////////
;==================================================================
;==================================================================

;==================================================================                
;////////////////////////////HELP//////////////////////////////////
;==================================================================

EHELP:
    
    LEA DX,MSG1
    MOV AH,9H
    INT 21H
    
    ; NEW LINE
    MOV AH,2H
    MOV DL,10
    INT 21H
    JMP START_POINT
    
;==================================================================                
;////////////////////////////LINEAR////////////////////////////////
;==================================================================

ELINEAR:
    CALL VISUALIZE_LR
    JMP START_POINT
    
;==================================================================                
;////////////////////////////MATRIX////////////////////////////////
;==================================================================

EMATRIX:
    CALL MAT_CALL

    ; NEW LINE
    MOV AH,2H
    MOV DL,10
    INT 21H
    JMP START_POINT
    
;==================================================================                
;////////////////////////////PASCAL////////////////////////////////
;================================================================== 

EPASCAL:
    CALL PASCAL_CALL
    
    ; NEW LINE
    MOV AH,2H
    MOV DL,10
    INT 21H
    JMP START_POINT
    
;==================================================================                
;////////////////////////////FIBONACCI/////////////////////////////
;==================================================================

EFIBONACCI:
    CALL FIB_CALL
    
    ; NEW LINE
    MOV AH,2H
    MOV DL,10
    INT 21H
    JMP START_POINT
    
;==================================================================                
;///////////////////////////COMPINATION////////////////////////////
;================================================================== 

ECOMPINATION:
    CALL COMP_CALL
    
    ; NEW LINE
    MOV AH,2H
    MOV DL,10
    INT 21H
    JMP START_POINT
    
;==================================================================                
;//////////////////////////PERMUTATION////////////////////////////
;================================================================== 

EPERMUTATION:
    CALL PER_CALL
    
    ; NEW LINE
    MOV AH,2H
    MOV DL,10
    INT 21H
    JMP START_POINT
;==================================================================                
;///////////////////////////FACTORIAL//////////////////////////////
;==================================================================
EFACTORIAL:
    CALL FACT_CALL
    
    ; NEW LINE
    MOV AH,2H
    MOV DL,10
    INT 21H
    JMP START_POINT
;==================================================================                
;////////////////////////////EXIT//////////////////////////////////
;==================================================================   
EEXIT:
    MOV AX,0003H
    INT 10H
    JMP DISPLAY_DOC
 
;==================================================================                
;////////////////////////////CLEAR/////////////////////////////////
;==================================================================
ECLEAR:
    MOV AX,0003H
    INT 10H
    JMP START_POINT
    
;==================================================================                
;/////////////////////       WRONG INPUT     //////////////////////
;==================================================================

WRONG_INPUT:
    LEA DX,WRONG_COMMAND
    MOV AH,9H
    INT 21H
    JMP START_POINT        

        
START ENDP 
END MAIN
