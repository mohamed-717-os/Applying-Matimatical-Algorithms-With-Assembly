.model small       
.stack 100h        

.code              
FIB_CALL proc         
    
    lea dx , input 
    mov ah , 9h 
    int 21h
    
    call read_number
    xor cx ,cx
    
    mov [count] , bx  
    mov cx , [count]
      
    call fibonacci 

    RET
FIB_CALL endp

fibonacci proc
    ; input >> CX
   
    mov ax, 0          ; a = 0 F(0))
    mov bx, 1          ; b = 1 F(1)            

    call DRAW_NUM  
fib_loop:
    
    CMP CX, 0 
    JLE END_FI
    
    ; c = a + b
    add ax, bx         ; AX = a + b
    xchg ax, bx            ; a = b, AX becomes a   
    
    push ax
    
     mov dl, ' '
     mov ah, 2
     int 21h
     
    pop ax 
    call DRAW_NUM           
                
     
    
    DEC CX  
    jmp fib_loop      

END_FI:
        
    ret        
    
fibonacci endp