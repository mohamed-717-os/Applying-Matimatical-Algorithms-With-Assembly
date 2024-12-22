# Applying-Mathematical-Algorithms-Using-Assembly-Language


> بسم الله الرحمن الرحيم، الحمد لله رب العالمين، والصلاة والسلام على سيدنا محمد وعلى آله وصحبه أجمعين.  
> هذا البرنامج يمثل تطبيقا لمجموعة من الخوارزميات الرياضية بلغة التجميع،  
>  وكان ذلك بمثابة مشروع لمادة (لغة التجميع) في كلية الحاسبات والمعلومات جامعة المنصورة  
> قام بالعمل عليه ثلاثة طلاب في الصف الثالث ***محمد احمد حنفي*** و***محمد السعيد زكي*** و***محمد خالد الزعلوك***   
> ونرجوا من الله ان يكون في هذا نفعا لنا ولكم، وفيما يلي وصف أكثر تفصيلا باللغة الإنجليزية، صحبتكم السلامة.
### Introduction

This project implements several famous mathematical algorithms through a command-line interface, developed using assembly language (.86 and .386) with GUI Turbo Assembler (TASM).

### Features

- Perform mathematical operations such as matrix multiplication, Pascal's triangle, Fibonacci sequence, and linear regression.
- Including some graphical drawing capabilities, such as lines and cycles.

### Project Structure
### Main.asm

The central file integrates all other modules and maps commands to their respective operations.

### DATA.asm

Contains reusable messages and variables used across other modules.

### matmul.asm
**Procedures:**

- `MAT_CALL`: Calls the matrix multiplication operation.
- `INPUT`: Handles user input for entering matrix values.
- `MAT_MUL`: Performs matrix multiplication.
- `MAT_INDEX`: Calculates the index of a matrix element based on its row and column.
- `SLICE`: Slices a row into a column format, useful in linear regression.
- `CLEAR_ARRAY`: Clears the contents of an array.
- `PRINT_ARRAY`: Prints the contents of a matrix.
- 
### Pascal.asm
**Procedures:**

- `FACTORIAL`: Computes the factorial of a number.
- `PERMUTATIONS`: Calculates permutations based on input values.
- `COMBINATION`: Computes combinations.
- `PASCAL`: Generates Pascal's triangle.
- `PRINT_TRIANGLE`: Displays Pascal's triangle.

    > And has some procedures to handle user input and call the function
    

### Fibonacci.asm

- Implements Fibonacci sequence generation and visualization.

### DOCS.asm

- Handles documentation strings and descriptions.

### LR.asm

- Implements linear regression-related procedures.

### Draw.asm
**Procedures:**

- `DRAW_LINE`
- `DRAW_CYCLE`
- `DRAW_SQUARE`
- `DRAW_GRAPH`
- `DRAW_GRID`: Draws a grid pattern.
- `DRAW_CLICK`: Uses `DRAW_CYCLE` to draw a cycle when clicking the left mouse button.
- `VISUALIZE_LR`: Passes inputs and Visualizes the result of linear regression.
    

### General.asm
**Procedures:**

- `DRAW_NUM`: Converting hexadecimal numbers to decimal and printing them as a string.
- `READ_NUMBER`: Handles user input for number entry.

### Images From The Program

- ![image](https://github.com/user-attachments/assets/93f6bc48-7fb7-45e0-9074-144334f2ab25)
- ![image](https://github.com/user-attachments/assets/83b89792-e974-4eec-96f9-a279abce0e65)
- ![image](https://github.com/user-attachments/assets/25384ebc-65cd-45ae-a798-d4be446a1fa7)
- ![image](https://github.com/user-attachments/assets/49f8ec48-91f1-4c40-bb06-a6bf3f1a9516)
- ![image](https://github.com/user-attachments/assets/b29c3346-281d-4ef3-be7d-2f8842565d34)

### Notes

- **Input Requirement:**  
  The input must be in capital letters.

- **Linear Regression Accuracy:**  
  The result of the linear regression is not perfect because the program processes only decimal numbers. To address this issue partially, we applied a scaling technique to the theta values by scaling the `y` values. Specifically, the `y` values are multiplied by $2^6$, which directly scales the theta values during the gradient descent process.

The scaling is illustrated as follows:

$$
\theta_1 := \theta_0 - \frac{1}{\alpha \cdot n} \cdot ([x \cdot \theta_0 - y] \cdot x)
$$

When scaling theta:

$$
2^6 \cdot \theta_1 := 2^6 \cdot \theta_0 - \frac{1}{\alpha \cdot n} \cdot ([x \cdot 2^6 \cdot \theta_0 - 2^6 \cdot y] \cdot x)
$$

$$
2^6 \cdot \theta_2 := 2^6 \cdot \theta_1 - \frac{1}{\alpha \cdot n} \cdot ([x \cdot 2^6 \cdot \theta_1 - 2^6 \cdot y] \cdot x)
$$

$$
\dots\dots
$$

$$
2^6 \cdot \theta_m := 2^6 \cdot \theta_{(m-1)} - \frac{1}{\alpha \cdot n} \cdot ([x \cdot 2^6 \cdot \theta_{(m-1)} - 2^6 \cdot y] \cdot x)
$$

Since the initial value is $\theta_0 = 0$, scaling y automatically scales $\theta_1$, and this scaled $\theta_1$ propagates to scale $\theta_2$, $\theta_3$, and so on.

When drawing the regression line, we account for the scaling by dividing the `y` values by $2^6$, and this ensures the output remains consistent and accurate after scaling adjustments.

