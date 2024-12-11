; PROSEDURES IN THIS FILE IS:
    ; * DRAW_LINE  
    ; * DRAW_CYCLE  
    ; * DRAW_SQUARE 
    ; * DRAW_GRAPH 
    ; * DRAW_GRID
    ; * DRAW_CLICK
    ; * VISUALIZE_LR

.MODEL SMALL
.386

.DATA
    INCLUDE LR.asm

    ;---------------- GRAPH COORDINATES -------------------
      GRAPH_X DW 30            ; X-coordinate for the GRAPH
      GRAPH_Y DW 20            ; Y-coordinate for the GRAPH
    
      GRAPH_W DW 250         ; Size of the GRAPH
      GRAPH_H DW 150       ; Size of the GRAPH
    ;------------------------------------------------------
    
    ;---------------- SQUARE COORDINATES -------------------
      SQUARE_X DW 20            ; X-coordinate for the GRAPH
      SQUARE_Y DW 20           ; Y-coordinate for the GRAPH
        
      SQUARE_W DW 10         ; Size of the GRAPH
      SQUARE_H DW 10        ; Size of the GRAPH
      
      SQUARE_COLOR DB 0Fh
    ;------------------------------------------------------
    
    ;---------------- SYCLE COORDINATES -------------------
      CYCLE_X DW 5           ; X-coordinate for the GRAPH
      CYCLE_Y DW 5            ; Y-coordinate for the GRAPH
 
      CYCLE_R DW 7
   
      CYCLE_COLOR DB 0Dh
    ;------------------------------------------------------
    
    ;---------------- LINE COORDINATES -------------------
      LINE_AX DW 2        
      LINE_B DW 0 
        
      FRAME_X1 DW 30
      FRAME_Y1 DW 20
      
      FRAME_X2 DW 530 
      FRAME_Y2 DW 370

      LINE_COLOR DB 0Ch
    ;------------------------------------------------------

.CODE

; =====================================================================================
   ; //////////////////////  LINEAR REGRESSION VISUALIZATION  ////////////////////////
; =====================================================================================
   
    VISUALIZE_LR PROC 

    START_DRAWING:  
        mov ax, 0012h  ; Set video mode 12h (640x480)
        int 10h

     ;RETERN DEFULT VALUES
        MOV THETA[4], WORD PTR 0
        MOV THETA[6], WORD PTR 0
        
        PUSH OFFSET X
        PUSH 30
        CALL CLEAR_ARRAY
        
        PUSH OFFSET Y
        PUSH 30
        CALL CLEAR_ARRAY
      
        MOV EPOCHS, WORD PTR 100

      ; -----------------------
      
      CALL DRAW_GRAPH
      CALL DRAW_CLICK

      ; -----------------------
         CALL LINEAR_REGRESSION
  
         MOV AX, THETA[4]
         MOV LINE_AX, AX
         
         MOV AX, THETA[6]
         MOV LINE_B, AX
      ; -----------------------
       
       CALL DRAW_LINE
      
      
  END_DRAWING:
      mov ah, 00h   ; Fetch key
      int 16h       ; -> AX

      ;  REDRAWING WHEN FETCHING <0>
      CMP AX, 5230H     ; (0) FROM THE NUMPAD  
      JZ START_DRAWING   
      CMP AX, 0B30H      
      JZ START_DRAWING   
       
      ;  CLOSE THE PROGRAM WHEN PUTTING <ENTER> 
      CMP AX, 1C0DH      
      JNZ END_DRAWING      
      
     ; Set video mode 3 (80x25 text mode)
      mov ax, 0003h 
      int 10h
        
      RET
    VISUALIZE_LR ENDP
    
;=============================================================================
   ; //////////////////////  DRWING WHEN CLICK  ////////////////////////
;=============================================================================
  
    DRAW_CLICK PROC
        PUSHA
        
      mov ax, 0000h  ; Initialize the mouse
      int 33h        
      mov ax, 0001h  ; Show mouse pointer
      int 33h 
     
      MOV AX, 1AH    ; Set mouse sensitivity
      MOV BX, 50    ; horizontal coordinates per pixel
      MOV CX, 50    ; vertical coordinates per pixel
      INT 33H
        
      ; DEFINE ONE ROW
        MOV X[0], WORD PTR 1
        MOV Y[0], WORD PTR 1
        
        ; PUTTING INDIX AT THE FIRST ELEMENT
        MOV SI, OFFSET X
        ADD SI, 4
        MOV DI, OFFSET Y
        ADD DI, 4
        
        MainLoop:
          mov  ax, 0003h ; Get mouse info
          int  33h       ; -> BX CX DX
          
          test bx, 1     ; Test left mouse button
          jz   UP        ; If not pressed, skip drawing
          
         ; IF IT THE SAME (X,Y) SKIP DRAWING [TO AVOIND SEVERAL PLOTS IN ONE CLICK]
          CMP CYCLE_X, CX
          JE UP
          CMP  CYCLE_Y, DX
          JE UP
          
          ; Hide the mouse pointer before drawing
          mov ax, 0002h  ; Hide mouse pointer
          int 33h
          
          
          ; Draw the CYCLE
          MOV  CYCLE_X, CX
          MOV  CYCLE_Y, DX
          CALL DRAW_CYCLE 

          ; Show the mouse pointer again
          mov ax, 0001h  ; Show mouse pointer
          int 33h
          ;------
         
          ; ADDING Y DATA  (Y2 - Y)
           MOV AX, DX
           NEG AX
           ADD AX, FRAME_Y2
           SHR AX, 5     ; SCALING Y BY 2^5
        
        
           MOV [DI], AX
           ADD DI, 2
           
           ; ADDING X DATA (X + X1)
          MOV AX, CX
          SUB AX, FRAME_X1 
          SHR AX, 5     ; SCALING X BY 2^5
          
          MOV [SI], AX
          ADD SI, 2 
          
          ; ADDING 1 TO THE NUMBER OF COLUMNS
           INC X[2]
           INC Y[2]
          
          UP:
            mov ah, 01h   ; Test keyboard
            int 16h       ; -> AX ZF
            jz MainLoop   ; No key is waiting
    
        POPA
        RET
      DRAW_CLICK ENDP
;=============================================================================
   ; //////////////////////  DRWING THE GRAPH ////////////////////////
;=============================================================================

    DRAW_GRAPH PROC NEAR
        PUSHA
        
    ; THE MAIN GRAPH SCREEN
        MOV SQUARE_X, 30
        MOV SQUARE_Y, 20
        MOV SQUARE_W, 500
        MOV SQUARE_H, 350
        MOV SQUARE_COLOR, 0FH 
        CALL DRAW_SQUARE
      
     ; ---------------
        CALL DRAW_GRID
        
     ; COORDINATES  
        ; Y AXIS
        MOV SQUARE_X, 40
        MOV SQUARE_Y, 20
        MOV SQUARE_W, 2
        MOV SQUARE_H, 350        
        MOV SQUARE_COLOR, 9H 
        CALL DRAW_SQUARE
        
        ; X AXIS
        MOV SQUARE_X, 30
        MOV SQUARE_Y, 360
        MOV SQUARE_W, 500
        MOV SQUARE_H, 2        
        MOV SQUARE_COLOR, 9H 
        CALL DRAW_SQUARE
        
        POPA
        RET                   
    DRAW_GRAPH ENDP
;=============================================================================
   ; //////////////////////  DRWING THE GRID ////////////////////////
;=============================================================================

    DRAW_GRID PROC NEAR
        PUSHA
        
       MOV AX, 50 ;> X
      MOV BX, 30 ;> Y 
      
      MOV CX, 48
   GRIDY_LOOP:
     ; VERTICAL GRID
        MOV SQUARE_X, AX
        MOV SQUARE_Y, 20
        MOV SQUARE_W, 1
        MOV SQUARE_H, 350        
        MOV SQUARE_COLOR, 7H 
        CALL DRAW_SQUARE
        
        ADD AX, 10
        LOOP GRIDY_LOOP
       
       MOV CX, 33
    GRIDX_LOOP:
        ; X AXIS
        MOV SQUARE_X, 30
        MOV SQUARE_Y, BX
        MOV SQUARE_W, 500
        MOV SQUARE_H, 1        
        MOV SQUARE_COLOR, 7H 
        CALL DRAW_SQUARE

        ADD BX, 10
        LOOP GRIDX_LOOP
        
        POPA
        RET                   
        DRAW_GRID ENDP
;=============================================================================
    ; //////////////////////  DRWING SQUARE ////////////////////////
;=============================================================================

    DRAW_SQUARE PROC 
        PUSHA
        
      ; DRAW_SQUARE(X, Y, H, W)
        ; Set initial coordinates
        MOV CX, SQUARE_X
        MOV DX, SQUARE_Y

      DRAW_HORIZONTAL:
        ; PLOTTING A pixel
        MOV AH, 0Ch             ; Function: Write pixel
        MOV AL, SQUARE_COLOR    ; Color: White
        MOV BH, 00h             ; Page number
        INT 10h                 ; Write pixel

        ; Move to next column
        INC CX
        MOV AX, CX
        SUB AX, SQUARE_X        ; AX = CX - SQUARE_X
        CMP AX, SQUARE_W     ; If AX > SQUARE_WIDTH, go to next line
        JNG DRAW_HORIZONTAL

    DRAW_VERTICAL:
        MOV CX, SQUARE_X
        INC DX
        MOV AX, DX
        SUB AX, SQUARE_Y        ; AX = DX - SQUARE_Y
        CMP AX, SQUARE_H     ; If AX <= SQUARE_HIGHT, continue drawing
        JNG DRAW_HORIZONTAL

        POPA
        RET                   ; Return when SQUARE is fully drawn
    DRAW_SQUARE ENDP
    
;============================================================================= 
    ; //////////////////////  DRWING CYCLE ////////////////////////
;=============================================================================

    DRAW_CYCLE PROC NEAR
        PUSHA
        
      ; DRAW_CYCLE(X, Y, H, W)
        ; Set in coordinates
        MOV CX, CYCLE_X
        MOV DX, CYCLE_Y
        MOV SI, CYCLE_R
       
       HORIZONTAL:
        PUSH DX
        PUSH CX
        
           SUB CX, CYCLE_X
           SUB CX, CYCLE_R  ; ((X - X1) - R)
           
           MOV AX, CX 
           XOR DX, DX
           MUL CX           ; ((X - X1) - R) ^ 2
         
        POP CX
         
        MOV BX, AX 
        
        POP DX
        PUSH DX
        
         SUB DX, CYCLE_Y
         SUB DX, CYCLE_R
         
         MOV AX, DX
         MUL DX              ; ((Y - Y1) - R) ^ 2
          
         ADD BX, AX      ; BX = ((X - X1) - R)^2 + ((Y - Y1) - R)^2
         
         MOV AX, SI
         MUL SI             ; R^2
       POP DX   
         
         CMP BX, AX
         JGE NEXT_COL
       
        ; Set graphics pixel
        MOV AH, 0Ch             ; Function: Write pixel
        MOV AL, CYCLE_COLOR    ; Color: White
        MOV BH, 00h             ; Page number
        INT 10h                 ; Write pixel

    NEXT_COL:
        INC CX
        MOV AX, CX
        SUB AX, CYCLE_X        ; AX = X - X1
        
        MOV BX, CYCLE_R
        SHL BX, 1             
        CMP AX, BX         ; If AX >= 2R (CYCLE SIZE), go to next line
        JNG HORIZONTAL

    VERTICAL:
        MOV CX, CYCLE_X
        INC DX
        MOV AX, DX
        SUB AX, CYCLE_Y        ; AX = Y - Y1
        
        MOV BX, CYCLE_R
        SHL BX, 1
        CMP AX, BX         ; If AX < 2R, continue drawing
        JNG HORIZONTAL  

        POPA
        RET                   ; Return when CYCLE is fully drawn
    DRAW_CYCLE ENDP
    
;=============================================================================
   ; //////////////////////  DRWING LINE ////////////////////////
;=============================================================================

    DRAW_LINE PROC
        PUSHA
    
     ; Compute differences
     MOV CX, FRAME_X1
     LOOPX:
     
        MOV BX, CX
        SUB BX, FRAME_X1  ;  BX = X - X1
        
        MOV AX, LINE_AX   ;
        XOR DX,DX         ;  (X-X1)*SLOP
        MUL BX
        
        ADD AX, LINE_B   ; Y = (X-X1)*SLOP + B
        SHR AX, 6        ; FOR SCALING THETAS
        
        
        MOV DX, FRAME_Y2   ;
        SUB DX, AX         ;  DX = Y2 - Y
        
        CMP DX, FRAME_Y1   ;
        JL SKIP_PLOT       ;  Y1 < Y2 - Y < Y2
        CMP DX, FRAME_Y2   ;
        JG SKIP_PLOT       ;
        
        ; PLOTTING
        MOV SQUARE_X, CX
        MOV SQUARE_Y, DX
        MOV SQUARE_W, 2
        MOV SQUARE_H, 2        
        MOV SQUARE_COLOR, 0CH 
        CALL DRAW_SQUARE
    
        SKIP_PLOT:
        
     INC CX                     
     CMP CX, FRAME_X2           
     JL LOOPX                   
      
        POPA
        RET
    DRAW_LINE ENDP
;=============================================================================
