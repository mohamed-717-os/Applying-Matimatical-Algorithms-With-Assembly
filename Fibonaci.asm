.model small       
.stack 100h        

.data              
    count DW ?
    input DB "enter number of Iteration:","$"

.code              
main proc         
    .startup 
    
    lea dx , input 
    mov ah , 9h 
    int 21h
    
    call read_number
    xor cx ,cx
    
    mov [count] , bx  
    mov cx , [count]
      
    call fibonacci 

    .exit

main endp

fibonacci proc
    
    cmp cx, 1          ; If n == 1    
    je base_case_0
    je base_case_1     ; Return 1
    
    cmp cx, 0          ; If n == 0
    je base_case_0     ; Return 0   
    
   
    mov ax, 0          ; a = 0 F(0))
    mov bx, 1          ; b = 1 F(1)            

fib_loop:
    ; c = a + b
    add ax, bx         ; AX = a + b
    xchg ax, bx            ; a = b, AX becomes a   
    
    push ax
    call DRAW_NUM           
                
     mov dl, ' '
     mov ah, 2
     int 21h
     
    pop ax 
       
    loop fib_loop      

    mov ax, bx         ; Result in AX
    
    
    jmp end_fi  
    
base_case_0:
    mov ax, 0          
    call DRAW_NUM 

base_case_1:
    
    mov ax, 1
    call DRAW_NUM
    
    
  
    
         
end_fi:
    ret        
    
fibonacci endp
 ;=============================================================================

     DRAW_NUM PROC
            
     ;ax => input  
        PUSH AX
        PUSH BX
        MOV BP, SP  ; SAVE THE CURRENT STACK POINTER IN (BP)

        
      CONVERT:
    
        MOV BX,10
        MOV DX,0
        DIV BX     ; AX = AX / 10
        ADD DX,48  ; CONVERT REMAINDER INTO ASCII
        
        PUSH DX
        
        CMP AX, 0
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
       POP BX
       POP AX
       
       RET 
    DRAW_NUM ENDP
  ;=============================================================================
   read_number PROC 
        MOV BX, 0
    read_num:
        MOV AH, 01h 
        INT 21h
        
        CMP AL, 0dh  
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
        RET
    read_number ENDP

end main             
