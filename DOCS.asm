
; HERE IS THE DOCUMENTATION PAGE IN THE PROGRAM AND IT'S SCHORTCUTS
 
.MODEL SMALL
.DATA
 

LOGO  db "      __  __       _   _                          _   _           _ ", 10, 13,
      db "    |  \/  | __ _| |_| |__   ___ _ __ ___   __ _| |_(_) ___ __ _| |", 10, 13,
      db "    | |\/| |/ _` | __| '_ \ / _ \ '_ ` _ \ / _` | __| |/ __/ _` | |", 10, 13,
      db "    | |  | | (_| | |_| | | |  __/ | | | | | (_| | |_| | (_| (_| | |", 10, 13,
      db "    |_|  |_|\__,_|\__|_| |_|\___|_| |_| |_|\__,_|\__|_|\___\__,_|_|", 10, 13,
      db "           / \  | | __ _  ___  _ __(_) |_| |__  _ __ ___  ___      ", 10, 13,
      db "          / _ \ | |/ _` |/ _ \| '__| | __| '_ \| '_ ` _ \/ __|     ", 10, 13,
      db "         / ___ \| | (_| | (_) | |  | | |_| | | | | | | | \__ \     ", 10, 13,
      db "        /_/   \_\_|\__, |\___/|_|  |_|\__|_| |_|_| |_| |_|___/     ", 10, 13,
      db "                   |___/                                           ", 10,13,
      db "                          In Command Line Interface                ",10,10,13
      
      DB " ---------------------------------------------------------------", 10,13,
      DB " AUTHORS: | Mohamed Ahmed | Mohamed El Saeed | Mohamed Khaled |", 10,13,
      DB "---------------------------------------------------------------", 10,,10, 13
      DB " PRESS <ENTER> TO SEE ALL COMMANDS YOU CAN USE OR <Q> TO QUIT: ", 10,10,13, '$'
         

DOC DB " +-------------+---------------------------------------------+", 10,13,
    DB "| Command     | Description                                 |", 10,13,
    DB "+-------------+---------------------------------------------+", 10,13,
    DB "| HELP        | List available commands                     |", 10,13,
    DB "| LR          | Perform linear regression                   |", 10,13,
    DB "| MM          | Perform Matrix Multiplication               |", 10,13,
    DB "| PT          | Display Pascal's Triangle                   |", 10,13,
    DB "| FI          | Generate a Fibonacci sequence               |", 10,13,
    DB "| C           | Solving Combination Equations               |", 10,13,
    DB "| P           | Solving permutation Equations               |", 10,13,
    DB "| !           | Calculate factorial of a number             |", 10,13,
    DB "| CLS         | Clear Screen                                |",10,13,
    DB "| EXIT        | BACK TO THE HIME PAGE                       |",10,13,
    DB "+-------------+---------------------------------------------+", '$'  



                                                                           
.CODE  
                                                                
    DOC_PAGE PROC FAR

       
   ; SHOWING LOGO AND AUTORS    
      LEA DX, LOGO
      MOV AH,9
      INT 21H
      
    ; SHOWING AVILABLE COMMANDS
  COMMANDS:
      mov ah, 00h   ; Fetch key
      int 16h       ; -> AX
       
      ;  WHAITING FOR <Q> TO QUIT
      CMP AX, 1051H
      JNZ CHECK_ENTER
        MOV AX, 4C00H
        INT 21H
        
     CHECK_ENTER:
      ;  WHAITING FOR <ENTER> TO START
      CMP AX, 1C0DH      
      JNZ COMMANDS      
      
      ; DISPLAYING COMMANDS
      LEA DX, DOC
      MOV AH,9
      INT 21H
      
      RET
    DOC_PAGE ENDP
