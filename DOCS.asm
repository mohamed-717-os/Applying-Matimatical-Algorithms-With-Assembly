.MODEL SMALL
.DATA
 

LOGO  db "  __  __       _   _                          _   _           _ ", 10, 13,
      db "|  \/  | __ _| |_| |__   ___ _ __ ___   __ _| |_(_) ___ __ _| |", 10, 13,
      db "| |\/| |/ _` | __| '_ \ / _ \ '_ ` _ \ / _` | __| |/ __/ _` | |", 10, 13,
      db "| |  | | (_| | |_| | | |  __/ | | | | | (_| | |_| | (_| (_| | |", 10, 13,
      db "|_|  |_|\__,_|\__|_| |_|\___|_| |_| |_|\__,_|\__|_|\___\__,_|_|", 10, 13,
      db "       / \  | | __ _  ___  _ __(_) |_| |__  _ __ ___  ___      ", 10, 13,
      db "      / _ \ | |/ _` |/ _ \| '__| | __| '_ \| '_ ` _ \/ __|     ", 10, 13,
      db "     / ___ \| | (_| | (_) | |  | | |_| | | | | | | | \__ \     ", 10, 13,
      db "    /_/   \_\_|\__, |\___/|_|  |_|\__|_| |_|_| |_| |_|___/     ", 10, 13,
      db "               |___/                                           ", 10,13,
      db "                      In Command Line Interface                ",10,10,13
      
      DB " ---------------------------------------------------------------", 10,13,
      DB " AUTHORS: | Mohamed Ahmed | Mohamed El Saeed | Mohamed Khaled |", 10,13,
      DB "---------------------------------------------------------------", 10,,10, 13
      DB " PRESS <ENTER> TO SEE ALL COMMANDS YOU CAN USE: ", 10,10,13, '$'
         

DOC DB " +-------------+---------------------------------------------+", 10,13,
    DB "| Command     | Description                                 |", 10,13,
    DB "+-------------+---------------------------------------------+", 10,13,
    DB "| !           | Calculate factorial of a number             |", 10,13,
    DB "| FI          | Generate a Fibonacci sequence               |", 10,13,
    DB "| LR          | Perform linear regression                   |", 10,13,
    DB "| PT          | Display Pascal's Triangle                   |", 10,13,
    DB "| HELP        | List available commands                     |", 10,13,
    DB "| HOME        | BACK TO THE HIME PAGE                       |",10,13,
    DB "+-------------+---------------------------------------------+", '$'  



                                                                           
.CODE  
                                                                
    DOC_PAGE PROC FAR
      .STARTUP
       
   ; SHOWING LOGO AND AUTORS    
      LEA DX, LOGO
      MOV AH,9
      INT 21H
      
    ; SHOWING AVILABLE COMMANDS
  COMMANDS:
      mov ah, 00h   ; Fetch key
      int 16h       ; -> AX
       
      ;  WHAITING FOR <ENTER> 
      CMP AX, 1C0DH      
      JNZ COMMANDS      
      
      ; DISPLAYING COMMANDS
      LEA DX, DOC
      MOV AH,9
      INT 21H
      

    DOC_PAGE ENDP
END DOC_PAGE
