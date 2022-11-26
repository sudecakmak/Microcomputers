# Microcomputers
Projects I made in Introduction to Microcomputers. I used MPLAB X IDE v5.20 for my projects.

I am going to use **PIC16F877A**.

I write my codes in *assembly*. The C coded version of my programs are showing in the pictures.

## Table of Contents

- [Microcomputer](#microcomputer)
- [Microcontroller](#microcontroller)
- [Arithmetic and Logical instructions](#arithmetic-and-logical-instructions)
- [Conditional expressions](#conditional-expressions)
- [Loops and Delay functions](#loops-and-delay-functions)
- [Function calls and Indirect addressing](#function-calls-and-indirect-addressing)


# Microcomputer
> A microcomputer is a complete computer on a small scale, designed for use by one person at a time. An antiquated term, a microcomputer is now primarily called a personal computer (PC), or a device based on a single-chip microprocessor. Common microcomputers include laptops and desktops. Beyond standard PCs, microcomputers also include some calculators, mobile phones, notebooks, workstations and embedded systems.

# Microcontroller
> A microcontroller (MCU) is an integrated circuit that combines CPU, program and data memory, EEPROM, Timers, several GPIO ports, communication interfaces such as UART, USB, I2C, SPI, CAN etc. into a single chip, and is programmed to do a specific task.


# Arithmetic and Logical instructions

The program shows below arithmetic expression how to write in assembly.

![Screenshot 2022-10-23 132934](https://user-images.githubusercontent.com/102357822/197387101-b85b6fdc-0fe2-48b4-b2d5-bbdb0364458b.png)


# Conditional expressions

The program shows which of the boxes shown in the figure will be in the region where the written x and y values are located.

![Screenshot 2022-10-29 135157](https://user-images.githubusercontent.com/102357822/198827363-ff7f8b6d-4ae9-48fe-a2f0-3a3dfd79fba6.png)

![Screenshot 2022-10-29 135217](https://user-images.githubusercontent.com/102357822/198827365-df3acbf9-7109-4f82-af9c-9dd9b3cafb60.png)


# Loops and Delay functions

Program display each and every Zibonacci number from 2 to 13 within the while loop on the LEDs, and waits for the user to press Button3 (RB3 on PICSIM) to move on to the next iteration of the loop. 
Also makes a 250ms delay before checking if the button is pressed and moves on to the next iteration of the loop.

![Screenshot 2022-11-10 153821](https://user-images.githubusercontent.com/102357822/201094028-4532e19b-734b-4564-9c78-83d1ba348d35.png)


# Function calls and Indirect addressing

Consider an arbitrary number generator function GenerateNumbers that takes 3 arguments, x, y and N, and generates some arbitrary numbers in a loop, and stores these numbers in an array.
It then returns the total number of elements generated and stored in the array. 
You then write another function AddNumbers that adds the numbers in the array and returns their sum.
You write a function DisplayNumbers that first displays the sum and then the first 5 numbers in the array one after the other as the user presses Button3 connected to PORTB3 (RB3 on PICSIM). 

![Screenshot 2022-11-25 014056](https://user-images.githubusercontent.com/102357822/203871179-9172e4eb-cdc8-45e8-a492-d68bdac4b80a.png)
