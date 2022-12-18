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
- [Led](#led)
- [Seven Segment Display](#seven-segment-display)
- [LCD](#lcd)


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


# Led

The idea is to walk over the LEDs first from the right to the left lighting up one LED at a time. When we have reached the last LED, we change direction and start walking to the right until we reach the first LED. This completes a cycle. When the cycle is completed, we flash the LEDs twice.

![Screenshot 2022-12-06 121602](https://user-images.githubusercontent.com/102357822/205870407-8c2a0460-31d3-426a-a36e-cb32358879bf.png)

# Seven Segment Display


The goal of this lab is to make use of the Seven Segment Displays (SSD) connected to PORTD of PIC16F877A on PICSIM. Recall that the SSD to be lit up is first selected by making its selection bit A2-A5 HIGH. Thus, to display a value on the first SSD (DIS4 on PICSIM), we first set A5 to logical 1 (HIGH), and then write the appropriate value corresponding to the number to be displayed to PORTD. The bit sequence necessary to display each number was discussed in class.  

You are asked to implement a simple counter that starts at 0 and counts up to decimal 20. When your counter reaches 20, it goes back 0 and counts up again. You counter must increment every second.

The most important thing in implementing this project is to avoid flicker on the SSDs. Notice that you will be displaying a two digit number, i.e., you will be displaying a value on the first and second SSDs (DIS3 & DIS4 on PICSIM). To display the counter, make sure that you select and display the first digit on the first SSD (DIS4). Then wait for 5ms so that the LEDs on the first SSD light up completely. Then select the second SSD (DIS3) and display the second digit on the second SSD. Again wait for 5ms to make the LEDs on the second SSD to light up completely. 

So far you displayed the two digit number on both SSDs and spent about 10ms. Before you increment your counter, you need to wait for another 980ms. If you simply wait for 980ms in an idle loop now, your first SSD will turn off and you will not be able to see the first digit anymore! To avoid this problem, write a display loop that iterates for some number of iterations (NO_ITERATIONS). Within the loop, display the first digit and wait for 5ms. Then display the second digit and wait for 5ms. Thus, the two digit number will be visible on the SSDs all the time. When the loop terminates, you have spent about 1000ms, i.e., 1 second. You can increment your counter and go back to the beginning of the main loop to display this number. Make sure that after your counter reaches 20, it rolls back to 0 and counts up from there.


![Screenshot 2022-12-09 235906](https://user-images.githubusercontent.com/102357822/206802259-4f93d59c-4432-47e0-a53b-493f5897c689.png)


# LCD

Counter value starts at 0, increments every second by 1 up to 20 and then rolls over back to 0. On the first line of the LCD displays two digits. For example, if the counter value is 12, then the first line must show “Counter Val: 12”. The second line of the LCD will show the message “Counting up…” if the counter is less than or equal to 20. When the counter rolls over from 20 to 0, the counter value will display 00, and the second line will show “Rolled over to 0”. At the next increment, you then show “Counting up…” as usual.

![Screenshot 2022-12-18 144753](https://user-images.githubusercontent.com/102357822/208296669-1c80e477-f948-41d8-a86c-51149bbae837.png)

## Output

![Screenshot 2022-12-17 153718](https://user-images.githubusercontent.com/102357822/208296332-1ee9a359-c2f5-4666-8dbf-1d676b9dd1d0.png)

![Screenshot 2022-12-17 153653](https://user-images.githubusercontent.com/102357822/208296328-6e4e488b-eaf3-4aa4-bce8-6b7ee695102d.png)


