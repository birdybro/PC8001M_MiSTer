Translated by google translate, so not perfect ~birdybro

PC-8001 on DE10-Lite
 PC-8001 on DE0-CV

 Simple document 
 RJB (@RadioJunkBox)

 ■ History ・ 2020/6/14 First Edition ・ 2020/6/27 Version 1.11 PCG8200 mode, PCG full dot color function added ・ 2020/7/12 Version 1.12 PSG function added, PCG8200, FDC mode bug fix (@Chiqlappe)


 ■ Overview This project respects the project published by kwhr0 in "Plan to make PC-8001 with FPGA" in 2004, and has been modified to work with DE10-Lite and DE0-CV equipped with Intel FPGA. It is the one that was done.  As for PC-8001, I own a real machine and PC-8001mini, and I also have a wonderful emulator such as j80, but I saw the project 15 years ago and I just wanted to run it on FPGA someday for experimental reasons. is.
 Basically, I am using the code of kwhr0 as it is, and I am adding functions such as VGA, PCG, PS / 2 keyboard support. In the original, a USB keyboard by UKP could be used, but there are some places where it cannot be repaired due to lack of power and some functions are down. For the Z80 core, the fz80 core written by kwhr0 is used as it is.
 We would like to express our deep gratitude to kwhr0 for publishing "Plan to make PC-8001 with FPGA" and Tachikurappe (@chiqlappe) for publishing SD-DOS.


 ■ Necessary items ○ Required ・ Terasic DE10-Lite or DE0-CV
 -Quartus Prime Version 18.1.0 Lite Edition (not confirmed except)
 ・ PS / 2 keyboard (PS / 2 interface circuit is also required for DE10-Lite)
 -PC-8001 ROM data (BASIC BIOS, FONT)

 ○ If necessary ・ SD-DOS (Chikurappe-san), microSD card (capacity up to 2GB)
 ・ Sound, interface for BEEP circuit, etc. ○ DE10-Lite only ・ SD card interface ■ How to use (installation method)
 1. Extract pc8001m.zip, which is a set of DE10-Lite or DE0-CV projects, to any working folder.
 2. Convert the BIOS ROM data and FONT (CG) ROM data extracted from the actual PC-8001 to the mif format, and change the file names to bios.mif and font.mif, respectively.
 3. Replace bios.mif and font.mif in the pc8001m / ROM folder.  (The original ROM folder is sample dummy data)
 4. When using SD-DOS, replace extram.mif in the ROM folder with the data in mif format from the SD-DOS binary.  (File name remains extram.mif)
 5. Launch Quartus Prime and select pc8001m.qpf in the pc8001m folder from Open Project in the File menu to open the project.
 6. Compile with Start Compilation. It takes a few minutes to compile, and it is OK if the compilation is completed without any error.  (There are a lot of warnings, but basically there is no effect. If you are interested, please fix it as appropriate)
 7. After compiling, connect DE10-Lite or DE0-CV and write the program.  (Select sof or pof as appropriate)
 8. After writing is completed, if the startup message of PC-8001 appears, it is completed.  (Of course, VGA monitor, PS / 2 keyboard, etc. must be connected in advance)
 For details on how to convert to mif format and how to use Quartus Prime, refer to other sites and books on the market.


 ■ Functions, etc. ○ Memory ・ ROM BASIC BIOS 24kB, expansion ROM 8kB (SD-DOS, etc.)
 ・ RAM 64kB (Lower 32kB is treated as extended RAM)
 ・ Memory switching equivalent to 8012 is possible (bank 0 only)
 E2h bit7-5 Unused bit4 Extended RAM write 0: Impossible 1: Possible (0-7FFFh)
	 bit3-1 Unused bit0 Read extended RAM 0: ROM 1: RAM (can be set for each address with E8h)
 E7h bit7 6000-7FFFh 0: ROM 1: RAM read switching (original function)
         bit6 4000-5FFFh 0: ROM 1: RAM read switching bit5 2000-3FFFh 0: ROM 1: RAM read switching bit4 0000-1FFFh 0: ROM 1: RAM read switching bit3-0 unused * When using SD-DOS , Copy the extended ROM data to the extended RAM (6000-7FFFh), and after OUT & HE7, & H80, OUT & HE2, & H11, restart with * G0000.

 ○ PS / 2 keyboard layout ・ Example GPAPH: Alt
 STOP: End
 DEL: Backsapce
 * For details, refer to the ps2keymap in ps2key.v (change it to your liking).

 ○ VGA output ・ Original was a color composite signal, but it is now compatible with VGA output for convenience such as conversion to HDMI.
 -The CTRC code driven at 14.318MHz is used as it is, and it is forcibly converted to VGA with a double 28.636MHz clock and a 2-line buffer, so there are some parts that do not meet the standard.
 -When using a color composite signal, output y_out and c_out from crtc.v and convert them separately with a DAC circuit to generate them. ○ SD-D0S
 -File input / output is SD-DOS published by Chikurappe ( https://github.com/chiqlappe ) is extremely convenient, so we strongly recommend using it. 
 -Since SD-DOS binaries are not provided, please convert from wav or cmt format files. 
 -It is convenient to place the SD-DOS binary from 6010h in the expansion ROM and load the following transfer program around 7F00h. 
 Example of transfer program 0000h (6000h): 41 42 CD 00 7F ・ ・ ・ ・ 
 0010h (6010h): SD-DOS binary ... 
 1F00h (7F00h): 21 10 60 01 F0 1F 11 00 60 ED B0 3E 80 D3 E7 3E 
 1F10h (7F10h): 11 D3 E2 00 00 00 00 00 00 00 00 00 00 00 00 00 
 1F20h (7F20h): 00 00 00 00 00 00 00 00 00 00 00 C9 00 00 ・ ・ ・ ← C9 00 00 is placed here ○ PCG 
 -Implements functions equivalent to PCG8100 or PCG8200 (mode switching with SW) 
 -The transfer function from CGROM to RAM is not implemented. 
 -The sound can be played back in 3 sounds by 8253. 
 -Pcgrom.mif in the ROM folder is data that reproduces a random pattern. 
 ・ Implemented the PCG full dot color (I / O magazine December 1983 issue) I / O address is different from the original article, and is based on the tweet circuit of Mr. Chiqlappe (@chiqlappe) 90-97h Color palette ex. OUT & H91,2 → Register palette 1 (blue) in red 98-9Fh RAM selection bit1: Red bit0: Green ex. OUT & H98,2 → Write RAM: Red (blue is always selected) 
 * The operation of PCG8200 mode and full dot color function has not been confirmed sufficiently. ○ PSG 
 ・ You can generate PSG sound (890x 2 pieces, 6Voice) by PSG (equivalent to AY-3-891x). 
 -The I / O port is equivalent to PC-8801-10. 
 -The clock supplied to PSG is 3.58MHz, but if you want to set it to 4MHz, rewrite pc8001m.v. 
 ・ PSG output is output from 1bit DAC A0h: PSG1 register selection A1h: PSG1 data input / output  
    A2h: PSG2 register selection A3h: PSG2 data input / output ・ Behavior may differ because the operation is not compared with the actual 891x chip ○ CMT (cassette tape I / F) / SIO 
 -It is unstable, and at the moment it is a bonus function. (It can be read, but the contents may be an error) 
 -For the CMT output (FSK) signal, the BEEP output can be switched with SW2. 
 -To read the CMT audio (FSK) signal, it is necessary to manufacture a comparator circuit using uPC271 (LM311) or the like. 
 -SIO is 8251 with a fixed mode. 

 ○ Slide SW OFF ON 
 ・ SW0 color monitor display Green monitor display ・ SW1 unused ・ SW2 BEEP CMT output (linked with motor) 
 ・ SW3 FDC OFF FDC ON (FDC: PCG full dot color) 
 ・ SW4 PCG8100 mode PCG8200 mode ・ SW5 PCG OFF PCG ON 
 ・ SW6 unused ・ SW7 without expansion ROM Expansion ROM (SD-DOS) available ・ SW8 unused 		
 ・ SW9 Normal mode High-speed mode (WAIT reduced) 
 * If you move SW9, the operation may freeze. ○ Push button ・ KEY0 reset (STOP + reset possible) 
 ・ KEY1 unused ・ KEY2 (DE0-CV) unused ・ KEY3 (DE0-CV) unused ○ LED 
 -LED0-7 CPU data bus (CPU input data) 
 ・ LED8 SD access ・ LED9 expansion RAM used ○ 7-segment LED 
 ・ 7SEG0-3 CPU address ・ 7SEG4-5 unused ■ External I / O connection * Caution! !! 
 -The I / O voltage of the FPGA board is all 3.3V. Directly connecting a 5V circuit may damage the FPGA board. 
 -Also, if a heavy load such as a speaker or relay is directly connected to the FPGA board, it may be damaged. 

 <DE0-CV> 
 ○ Sound output (1bit DAC) * It is recommended to use this because the output circuit is simple. ・ Dac_out output JP2-32 PIN_F15 PSG / PCG / BEEP (CMT) 1bit DAC output ○ Sound output ・ audio_out [0] output JP2-37 PIN_G13 PCG Sound 0 
 -Audio_out [1] Output JP2-38 PIN_G12 PCG Sound 1 
 -Audio_out [2] Output JP2-39 PIN_J17 PCG Sound 2 
 ・ Audio_out [3] output JP2-40 PIN_K16 BEEP / CMT output ・ beep_out output JP2-31 PIN_F14 Connect to a piezoelectric buzzer with a resistor of about 1kΩ ○ Black and white composite video output (no color burst) 
 -Bw_out [0] output JP2-5 PIN_A13 SYNC 
 ・ Bw_out [1] Output JP2-6 PIN_B13 Y signal (2 values) 

 ○ CMT / SIO input / output ・ cmt_in input JP2-7 PIN_C13 External comparator circuit required) 
 ・ Motor_out output JP2-8 PIN_D13 3.3V output with motor 1 ・ rxd input JP2-9 PIN_G18 SIO input ・ txd output JP2-10 PIN_G17 SIO output <DE10-Lite> 

 ○ PS / 2 keyboard input ・ ps2_clk input Arduino_IO7 PIN_AA12 Convert to 3.3V ・ ps2_data input Arduino_IO6 PIN_AA11 Convert to 3.3V ○ SD card IF 
 ・ Sd_dat input JP1-31 PIN_AA7 DATA_0 
 -Sd_clk output JP1-32 PIN_Y6 CLK 
 -Sd_cmd output JP1-33 PIN_AA6 CMD 
 -Sd_res output JP1-34 PIN_Y5 DATA_3 / CD 

 ○ Sound output (1bit DAC) * It is recommended to use this because the output circuit is simple. ・ Dac_out output JP1-27 PIN_AA8 PSG / PCG / BEEP (CMT) 1bit DAC output ○ Sound output ・ audio_out [0] output JP1-37 PIN_AB3 PCG Sound 0 
 -Audio_out [1] Output JP1-38 PIN_Y3 PCG Sound 1 
 -Audio_out [2] Output JP1-39 PIN_AB2 PCG Sound 2 
 ・ Audio_out [3] output JP1-40 PIN_AA2 BEEP / CMT output ・ beep_out output Arduino_IO5 PIN_Y10 Connect to a piezoelectric buzzer with a resistor of about 1kΩ ○ CMT / SIO input / output ・ cmt_in input Arduino_IO2 PIN_AB7 External comparator circuit required ・ motor_out output Arduino_IO3 3.3V output with PIN_AB8 motor 1 ・ rxd input Arduino_IO0 PIN_AB5 SIO input ・ txd output Arduino_IO1 PIN_AB6 SIO output ○ Black and white composite video output (no color burst) 
 -Bw_out [0] output JP1-1 PIN_V10 SYNC 
 ・ Bw_out [1] Output JP1-2 PIN_W10 Y signal (2 values) 

   * Correct the pin layout of the external I / O as appropriate with a pin assigner, etc. <Reference circuit> * Since the GND on the FPGA board side is omitted, of course, connect it somewhere. ○ Sound output circuit (1bit DAC) 
    ・ Simple LPF by RC (fc ~ 16kHz) 
 -PSG outputs only this circuit. 
                                          10u 
        dac_out o-----1k ---- o ------ o ---- || ---- o ------ o  
                                     | + | PSG / PCG / BEEP (CMT) sound output | | o 
                                    --- 10k | 
                              0.01u --- | | 
                                     | | | 
                                    --- --- --- 
                              /// /// ///  


   ○ Sound output circuit 33u 
   audio_out [0] o ---- -10k ---- o ------ o ---- || ---- o --------  
                              | | + | PCG / BEEP (CMT) sound output audio_out [1] o ---- -10k ---- o | | o 
                              2.2k 10k | 
   audio_out [2] o ---- -10k ---- o | | | 
                              | | | | 
   audio_out [3] o ---- -10k ---- o --- --- --- 
                              /// /// ///  


   ○ Black and white video output circuit 10u 
   bw_out [0] o ---- 4.7k ---- o ------ o ---- || ---- o ------ o  
            | | + | Composite video output bw_out [1] o ---- 2.2k ---- o 1.2k 10k o 
                                     | | | 
   --- --- --- 
                              /// /// ///  


 ■ Notes ・ FPGA and HDL are completely amateurs, and I think they contain many bugs and incorrect codes. Please take responsibility for additional tests and use. 
 (We are not responsible for any damage to DE10-Lite or DE0-CV) 
 ・ We cannot accept inquiries regarding this project. Also, please do not make inquiries to kwhr0. 
 ・ There are no particular restrictions on the refurbishment and disclosure of the refurbished product, but the original is inherited and any commercial use is prohibited. 


 ■ Reference site ・ Plan to make PC-8001 with FPGA http://kwhr0.g2.xrea.com/hard/pc8001.html 
 ・ SD-DOS https://github.com/chiqlappe 
 ・ PC-8001 is converted into a game machine http://w01.tp1.jp/~a571632211/pc8001/index.html 
 ・ A page that misses PC-8001 https://bugfire2009.ojaru.jp/index.html 
 ・ Enri's Home PAGE http://www43.tok2.com/home/cmpslv/index.htm 

