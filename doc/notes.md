http://cd.textfiles.com/230/EMULATOR/NEC/PC8001/ - pc-8001 emulator apparently? here is the readme doc from it translated:

```
========================================
PC-8001 emulator for DOS / V
N80 Ver 1.02
Copyright (C) 1993-96 H.Kanemoto
========================================

      Introduction
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
It is an emulator that reproduces the famous machine "NEC PC-8001" of the past on a compatible machine.
He was Z80 with his 8bit model in the era when personal computers were still called microcomputers etc.
It is a pioneer of domestic machines equipped with CPU. People of a certain generation
Most of the time, it's the best-selling machine you know.
This is because my friend kept the cassette tape at that time carefully
It is this N80.EXE that was created to somehow revive / utilize the assets.


    feature
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
It embodies the Z80 CPU and the main devices of his PC-8001.
-Printer output is spit out to his PRINTER.DAT.
-Has a pseudo cassette interface.
-Compatible with his PCG-8100 at HAL Laboratory.
Also, he does not perfectly reproduce the attribute function of CRTC.
Not available (overline, underline functions are not supported, etc.). Infrequent specifications
His Z80 instruction is also omitted.


      Operating environment
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
A DOS / V machine with a 386+ CPU and he works on a VGA screen, but it's nice
He will need at least 486SX-33MHz or higher to run properly. ((
If it is a machine of this time, it will almost clear the conditions, but ^^)
I have confirmed that it works on MS-DOS / V 6.2 or PC-DOS / V 6.3,
Other than that, it may work (unconfirmed).


      ROM file
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
This emulator requires the actual ROM image file
	increase. The ROM that can be used is his N-BASIC part of PC-8001 or unbranded PC-8801.
Minutes (either Ver 1.0 / 1.1 / 1.2) The file name is
The former is PC-8001.ROM and the latter is 8801-N80.ROM. Details
Please refer to the separate document.


      RAM file
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
There are two ways to run the program for PC-8001 on N80.
	increase:
-Use a RAM image file (extension .N80)
-Use a cassette image file (extension .CMT)

The RAM image file (hereinafter referred to as N80 file) is the actual machine.
A binar that dumps the program loaded in the RAM almost as it is
This is a reformatted file with some additional information added.
What is a cassette image file (hereinafter referred to as CMT file)?
Drop the raw state stored on the tape into a binary file
It was. Details on how to create these file formats, etc.
See the separate documentation for more information.


How to move
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
N80.EXE, PC-8001.FON, PC-8001.ROM (or he is 8801-N80.ROM) or more 3
Keep the two files in the same directory. chev us command
Execute N80.EXE after setting DOS to English mode with a computer.
Adjust the speed by specifying an appropriate decimal number on the command line.
	I can. The range of values ​​that can be specified is 0 to 65536. Naturally, the value is large
The more weight it takes, the slower the overall speed.


Key operation
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
If his KEY on PC-8001 is not in 106 KEYBOARD, it will be assigned to another KEY.
Has been:

PC-8001 106 KEY
------- -----------------------------
GRAPH ALT
Kana Kata Kana
STOP BS
RESET F12
TEN "=" TENKEY "ENTER"

Also, N80's unique features are assigned to 106 KEYBOARD:

106 KEY function
------- -----------------------------
F7 RAM IMAGE dump file output
F8 BEEP sound ON / OFF switch
F9 N80 RAM IMAGE FILE selection mode
Exit the F10 emulator
F11 PCG ON / OFF switch


      File selection mode
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
This mode selects N80 files. Files displayed on the screen
Select the desired file from the list and execute it. Confirm selection with [RET] key
Press the [ESC] key to cancel and return to the emulator. Drive weird
Further is [SHIFT] + [←] or [→]. A :, B: FD drive
I can't move.


      Cassette interface
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
This is just a "bonus" feature, in the current directory
If there is a file called CASSET.CMT, CLOAD from BASIC,
It can be read from Nita with the L command. Naughty
The content of the CMT file must be the correct cassette image
I will.


      RAM dump output
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
Output the RAM area on the emulator to a file called DUMP.RAM
It is a function to do. This is a program mainly read by CMT file
It is used for the purpose of converting the file to an N80 file. The finished fa
Rename Il with an appropriate name and change the extension to .N80, and it will remain as it is.
It can be used as an N80 file. However, some autos
In the Tart program, the dumped file works correctly
It may not be. RAM dump is moved to monitor and prompt
Please go with the "*" displayed.


      lastly
    -------------------------------------------------- -------------------------------------------------- -------------------------------------
For the time being, most of the games I have are working fine.
Part of the screen may be distorted, but this is by design (^^; scary
It's a program that has been cut short, but it works well.
Well, this is the one. For better or for worse, step off the stairs of life
It was a machine that triggered (laughs), so the process of making the emulator
Was a fun task.


1996/12/28


   (Addition) This text was revised when N80 was released.
```