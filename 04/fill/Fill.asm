// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

@color                   // current color (0 => white, -1 => black)
M=0                      // white as default

// Listen to the keyboard input
(LISTEN)
        @i               // index to traverse screen memory map
        M=0
        @KBD
        D=M              // D = keycode
        @SETWHITECOLOR
        D;JEQ            // Go to SETWHITECOLOR if keycode = 0
        @SETBLACKCOLOR
        0;JMP            // Go to SETBLACKCOLOR otherwise

(SETWHITECOLOR)
        @nextcolor
        M=0              // next color will be white
        @CHECKCOLOR
        0;JMP

(SETBLACKCOLOR)
        @nextcolor
        M=-1             // next color will be black

(CHECKCOLOR)
        @color
        D=M
        @nextcolor
        D=D-M
        @LISTEN
        D;JEQ            // if next color is same as current color, just keep it (no need to re-colorize)
        @nextcolor
        D=M
        @color
        M=D              // set next color to color
        @COLORIZE        // start to colorize screen
        0;JMP

(COLORIZE)
        @i
        D=M              // D = i
        @8192            // numbers of words of screen memory map = (512 x 256) / 16
        D=D-A            // D = i - 8192
        @LISTEN
        D;JGE            // finish colorizing if D >= 0
        @SCREEN
        D=A              // D = SCREEN (= 16384)
        @i
        D=D+M            // D = SCREEN + i
        @word            // the address of current word of screen memory map
        M=D              // word = SCREEN + i
        @nextcolor
        D=M              // D = next color
        @word
        A=M              // A = SCREEN + i
        M=D              // set next color for current word
        @i
        M=M+1            // i = i + 1
        @COLORIZE
        0;JMP            // continue for next word
