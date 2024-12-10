.MODEL SMALL
.386
INCLUDE DATA.ASM
INCLUDE mul.ASM
INCLUDE Pascal.ASM
INCLUDE Draw.ASM
INCLUDE Fibonaci.ASM
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
    START_POINT:
        MOV AH,2H
        
        MOV DL,10
        INT 21H

        MOV DL,13
        INT 21H
            
        ; PRINTING [>]
        MOV DL,10h        
        INT 21H 
        
        LEA SI,OPS
        MOV CX,9
          CLEAR:
            MOV OPS[SI], 1
              ADD SI, 1
             LOOP CLEAR
        
        MOV BX, 0
        MOV Q,0
    MAIN_read_num:
        MOV AH, 01h 
        INT 21h
        
        CMP AL, 0dh
        JNE PASS
        JE DONE
    DONE:
        MOV AL,'$'
        MOV CX,10
        PASS:
        LEA DI,OPS
        
;==================================================================                
;==================================================================
;                        CHOOSING FUNCTION
;==================================================================
;==================================================================                 


;==================================================================                
;////////////////////////////HELP//////////////////////////////////
;==================================================================
                      
    CHELP:
    CMP OPS[DI],0
    JE CLINEAR
    ;SETTING INDEX  
     LEA SI,HELP
     ADD SI,Q
     
     CMP AL ,[SI]
     JE CLINEAR
     JMP NOTMATCH
     
;==================================================================                
;////////////////////////////LINEAR////////////////////////////////
;================================================================== 
               
    CLINEAR:
     INC DI
     CMP OPS[DI],0
     JE CMATRIX
    
     CMP Q,3
     JNE CONT1
     JMP NOTMATCH
     CONT1:
     ;SETTING INDEX  
     LEA SI,LINEAR_DEF
     ADD SI,Q
     

     CMP AL,[SI]
     JE  CMATRIX
     JMP NOTMATCH
     
;==================================================================                
;////////////////////////////MATRIX////////////////////////////////
;==================================================================
            
    CMATRIX:
     INC DI
     CMP OPS[DI],0
     JE CPASCAL

     CMP Q,3
     JNE CONT2
     JMP NOTMATCH
    CONT2:
     ;SETTING INDEX  
     LEA SI,MATRIX_DEF
     ADD SI,Q
     
     CMP AL,[SI]
     JE  CPASCAL
     JMP NOTMATCH
     
;==================================================================                
;////////////////////////////PASCAL////////////////////////////////
;================================================================== 
      
    CPASCAL:
     INC DI
     CMP OPS[DI],0
     JE CFIBONACCI

     CMP Q,3
     JNE CONT3
     JMP NOTMATCH
 CONT3:
     ;SETTING INDEX  
     LEA SI,PASCAL_DEF
     ADD SI,Q
     
     CMP AL,[SI]
     JE  CFIBONACCI
     JMP NOTMATCH
     
;==================================================================                
;////////////////////////////FIBONACCI/////////////////////////////
;==================================================================
      
     CFIBONACCI:
     INC DI
     CMP OPS[DI],0
     JE CCOMPINATION
     
     CMP Q,3
     JNE CONT4
     JMP NOTMATCH
 CONT4:
     ;SETTING INDEX  
     LEA SI,FIBONACCI_DEF
     ADD SI,Q
     
     CMP AL,[SI]
     JE  CCOMPINATION
     JMP NOTMATCH
     
;==================================================================                
;///////////////////////////COMPINATION////////////////////////////
;==================================================================
     
     CCOMPINATION:
     INC DI
     CMP OPS[DI],0
     JE CPERMUTATION
     
     CMP Q,2
     JNE CONT5
     JMP NOTMATCH
 CONT5:
     ;SETTING INDEX  
     LEA SI,COMPINATION_DEF
     ADD SI,Q
     
     CMP AL,[SI]
     JE  CPERMUTATION
     JMP NOTMATCH
     
;==================================================================                
;//////////////////////////PERMUTATION////////////////////////////
;==================================================================
      
     CPERMUTATION:
     INC DI
     CMP OPS[DI],0
     JE CFACTORIAL
     
     CMP Q,2
     JNE CONT6
     JMP NOTMATCH
 CONT6:
     ;SETTING INDEX  
     LEA SI,PERMUTATION_DEF
     ADD SI,Q
     
     CMP AL,[SI]
     JE  CFACTORIAL
     JMP NOTMATCH
     
;==================================================================                
;///////////////////////////FACTORIAL//////////////////////////////
;==================================================================
        
     CFACTORIAL:
     INC DI
     CMP OPS[DI],0
     JE CEXIT ;NEXT INPUT
     
     CMP Q,2
     JNE CONT7
     JMP NOTMATCH
 CONT7:
     ;SETTING INDEX  
     LEA SI,FACTORIAL_DEF
     ADD SI,Q
     
     CMP AL,[SI]
     JNE NOTMATCH

;==================================================================                
;////////////////////////////EXIT//////////////////////////////////
;==================================================================
 
    CEXIT:
     INC DI
     CMP OPS[DI],0
     JE CCLEAR ;NEXT INPUT
    
     CMP Q,5
     JNE CONT8
     JMP NOTMATCH
 CONT8:
     ;SETTING INDEX  
     LEA SI,EXIT
     ADD SI,Q
     
     CMP AL,[SI]
     JNE NOTMATCH

;==================================================================                
;////////////////////////////CLEAR/////////////////////////////////
;==================================================================
    CCLEAR:
     INC DI
     CMP OPS[DI],0
     JE FINISH ;NEXT INPUT
    
     CMP Q,3
     JNE CONT9
     JMP NOTMATCH
 CONT9:
     ;SETTING INDEX  
     LEA SI,CLEAR_SCREEN
     ADD SI,Q
     
     CMP AL,[SI]
     JNE NOTMATCH
;==================================================================                
;///////////////////////FINSHED COMPARING//////////////////////////
;==================================================================

FINISH:
    INC Q
    CMP CX,10
    JE MAIN_done_reading
    JMP MAIN_read_num
    
;==================================================================                
;//////////////////////OPERATION NOT MATCH/////////////////////////
;==================================================================
         
    NOTMATCH:
     LEA BX,OPS
     MOV OPS[DI],0
     
     CMP DI,BX
     JNE NCONT
     JMP CLINEAR
 NCONT:
     INC BX
     CMP DI,BX
     JNE NCONT1
     JMP CMATRIX
 NCONT1:
     INC BX
     CMP DI,BX
     JNE NCONT2
     JMP CPASCAL
 NCONT2:
     INC BX
     CMP DI,BX
     JNE NCONT3
     JMP CFIBONACCI
 NCONT3:
     INC BX
     CMP DI,BX
     JNE NCONT4
     JMP CCOMPINATION
 NCONT4:
     INC BX
     CMP DI,BX
     JNE NCONT5
     JMP CPERMUTATION
 NCONT5:
     INC BX
     CMP DI,BX
     JNE NCOUNT6
     JMP CFACTORIAL
 NCOUNT6:
     INC BX
     CMP DI,BX
     JNE NCOUNT7
     JMP CEXIT
 NCOUNT7:
     INC BX
     CMP DI,BX
     JNE FINISH
     JMP CCLEAR  
;==================================================================                
;//////////////////////////DONE READING////////////////////////////
;================================================================== 
       
MAIN_done_reading:
     
        LEA DI,OPS
        MOV CX,9    
        CHOOSED:
            CMP OPS[DI],1  ;GETTING THE CHOSEN OPERATION  
            JE EXCUTE
            INC DI
            LOOP CHOOSED
            JMP WRONG_INPUT           
            
;==================================================================                
;==================================================================
;                        EXCUTING OPERATIONS
;==================================================================
;==================================================================

EXCUTE:

;GETTING INDEX OF OPERATION 
 LEA BX,OPS
 CMP DI,BX
 JE DETECT
 SUB DI,BX
 JMP DETECT
 
;================================================================== 
;==================================================================                
;////////////////////DETECT CHOSEN OPERATION///////////////////////
;================================================================== 
;================================================================== 

     DETECT:
     
     CMP DI,0     
     JE EHELP
     
     CMP DI,1
     JE ELINEAR
     
     CMP DI,2
     JE EMATRIX

     CMP DI,3
     JE EPASCAL

     CMP DI,4
     JE EFIBONACCI
     
     CMP DI,5
     JE ECOMPINATION
 
     CMP DI,6
     JE EPERMUTATION

     CMP DI,7
     JE EFACTORIAL
     
     CMP DI,8
     JE EEXIT
     
     CMP DI,9
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
    JMP START_POINT
    
;==================================================================                
;////////////////////////////PASCAL////////////////////////////////
;================================================================== 

EPASCAL:
    CALL PASCAL_CALL
    JMP START_POINT
    
;==================================================================                
;////////////////////////////FIBONACCI/////////////////////////////
;==================================================================

EFIBONACCI:
    CALL FIB_CALL
    JMP START_POINT
    
;==================================================================                
;///////////////////////////COMPINATION////////////////////////////
;================================================================== 

ECOMPINATION:
    CALL COMP_CALL
    JMP START_POINT
    
;==================================================================                
;//////////////////////////PERMUTATION////////////////////////////
;================================================================== 

EPERMUTATION:
    CALL PER_CALL
    JMP START_POINT
;==================================================================                
;///////////////////////////FACTORIAL//////////////////////////////
;==================================================================
EFACTORIAL:
    CALL FACT_CALL
    JMP START_POINT
;==================================================================                
;////////////////////////////EXIT//////////////////////////////////
;==================================================================   
EEXIT:

 RET
START ENDP 
WRONG_INPUT:
            LEA DX,WRONG_COMMAND
            MOV AH,9H
            INT 21H
            JMP START_POINT        

;==================================================================                
;////////////////////////////CLEAR/////////////////////////////////
;==================================================================
    ECLEAR:
        MOV AX,0003H
        INT 10H
        JMP START_POINT
        
END MAIN
