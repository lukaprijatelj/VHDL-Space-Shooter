# VHDL-Space-Shooter
This is an end project for my college subject called "Digitalno načrtovanje". It represents famous online game "Space shooter". But this project is created in Verilog language instead of Flash or Javascript. Verilog is not programming language. It is (as initials say) hardware description language. For those that don't know this language - it is extremly hard to program in it.

## Support
I must warn you that this project was made for specific board. It works only with Digilent Nexys 4 Artix-7 board. Game is displayed via VGA protocol and only works in 640x480 resolution.

## Design components
Program is made with some very common components like: RAM, Gyro sensor, Negative edge founder, Prescaler, Timer, Counter, PS2 Controller, Shift register, VSYNC and HSYNC (for VGA display), Random generator, Barrel shifter.
There are also components I programmed, components like: Enemy, User ...

## Screenshot
![alt tag](https://raw.githubusercontent.com/mrLukas/VHDL-Space-Shooter/master/Pictures/Screenshot.jpg)

## Digilent Nexys 4 Artix-7 board
![alt tag](https://raw.githubusercontent.com/mrLukas/VHDL-Space-Shooter/master/Pictures/Nexys4_board.jpg)

## Scheme
![alt tag](https://raw.githubusercontent.com/mrLukas/VHDL-Space-Shooter/master/Pictures/scheme.png)
