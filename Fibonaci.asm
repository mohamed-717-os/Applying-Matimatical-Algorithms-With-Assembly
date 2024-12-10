.model small       

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

FIB_CALL endp

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
