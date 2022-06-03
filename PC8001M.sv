//============================================================================
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
//============================================================================

module emu
(
	//Master input clock
	input         CLK_50M,

	//Async reset from top-level module.
	//Can be used as initial reset.
	input         RESET,

	//Must be passed to hps_io module
	inout  [48:0] HPS_BUS,

	//Base video clock. Usually equals to CLK_SYS.
	output        CLK_VIDEO,

	//Multiple resolutions are supported using different CE_PIXEL rates.
	//Must be based on CLK_VIDEO
	output        CE_PIXEL,

	//Video aspect ratio for HDMI. Most retro systems have ratio 4:3.
	//if VIDEO_ARX[12] or VIDEO_ARY[12] is set then [11:0] contains scaled size instead of aspect ratio.
	output [12:0] VIDEO_ARX,
	output [12:0] VIDEO_ARY,

	output  [7:0] VGA_R,
	output  [7:0] VGA_G,
	output  [7:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,
	output        VGA_DE,    // = ~(VBlank | HBlank)
	output        VGA_F1,
	output [1:0]  VGA_SL,
	output        VGA_SCALER, // Force VGA scaler

	input  [11:0] HDMI_WIDTH,
	input  [11:0] HDMI_HEIGHT,
	output        HDMI_FREEZE,

`ifdef MISTER_FB
	// Use framebuffer in DDRAM (USE_FB=1 in qsf)
	// FB_FORMAT:
	//    [2:0] : 011=8bpp(palette) 100=16bpp 101=24bpp 110=32bpp
	//    [3]   : 0=16bits 565 1=16bits 1555
	//    [4]   : 0=RGB  1=BGR (for 16/24/32 modes)
	//
	// FB_STRIDE either 0 (rounded to 256 bytes) or multiple of pixel size (in bytes)
	output        FB_EN,
	output  [4:0] FB_FORMAT,
	output [11:0] FB_WIDTH,
	output [11:0] FB_HEIGHT,
	output [31:0] FB_BASE,
	output [13:0] FB_STRIDE,
	input         FB_VBL,
	input         FB_LL,
	output        FB_FORCE_BLANK,

`ifdef MISTER_FB_PALETTE
	// Palette control for 8bit modes.
	// Ignored for other video modes.
	output        FB_PAL_CLK,
	output  [7:0] FB_PAL_ADDR,
	output [23:0] FB_PAL_DOUT,
	input  [23:0] FB_PAL_DIN,
	output        FB_PAL_WR,
`endif
`endif

	output        LED_USER,  // 1 - ON, 0 - OFF.

	// b[1]: 0 - LED status is system status OR'd with b[0]
	//       1 - LED status is controled solely by b[0]
	// hint: supply 2'b00 to let the system control the LED.
	output  [1:0] LED_POWER,
	output  [1:0] LED_DISK,

	// I/O board button press simulation (active high)
	// b[1]: user button
	// b[0]: osd button
	output  [1:0] BUTTONS,

	input         CLK_AUDIO, // 24.576 MHz
	output [15:0] AUDIO_L,
	output [15:0] AUDIO_R,
	output        AUDIO_S,   // 1 - signed audio samples, 0 - unsigned
	output  [1:0] AUDIO_MIX, // 0 - no mix, 1 - 25%, 2 - 50%, 3 - 100% (mono)

	//ADC
	inout   [3:0] ADC_BUS,

	//SD-SPI
	output        SD_SCK,
	output        SD_MOSI,
	input         SD_MISO,
	output        SD_CS,
	input         SD_CD,

	//High latency DDR3 RAM interface
	//Use for non-critical time purposes
	output        DDRAM_CLK,
	input         DDRAM_BUSY,
	output  [7:0] DDRAM_BURSTCNT,
	output [28:0] DDRAM_ADDR,
	input  [63:0] DDRAM_DOUT,
	input         DDRAM_DOUT_READY,
	output        DDRAM_RD,
	output [63:0] DDRAM_DIN,
	output  [7:0] DDRAM_BE,
	output        DDRAM_WE,

	//SDRAM interface with lower latency
	output        SDRAM_CLK,
	output        SDRAM_CKE,
	output [12:0] SDRAM_A,
	output  [1:0] SDRAM_BA,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nCS,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nWE,

`ifdef MISTER_DUAL_SDRAM
	//Secondary SDRAM
	//Set all output SDRAM_* signals to Z ASAP if SDRAM2_EN is 0
	input         SDRAM2_EN,
	output        SDRAM2_CLK,
	output [12:0] SDRAM2_A,
	output  [1:0] SDRAM2_BA,
	inout  [15:0] SDRAM2_DQ,
	output        SDRAM2_nCS,
	output        SDRAM2_nCAS,
	output        SDRAM2_nRAS,
	output        SDRAM2_nWE,
`endif

	input         UART_CTS,
	output        UART_RTS,
	input         UART_RXD,
	output        UART_TXD,
	output        UART_DTR,
	input         UART_DSR,

	// Open-drain User port.
	// 0 - D+/RX
	// 1 - D-/TX
	// 2..6 - USR2..USR6
	// Set USER_OUT to 1 to read from USER_IN.
	input   [6:0] USER_IN,
	output  [6:0] USER_OUT,

	input         OSD_STATUS
);

///////// Default values for ports not used in this core /////////

assign ADC_BUS  = 'Z;
assign USER_OUT = '1;
assign {UART_RTS, UART_TXD, UART_DTR} = 0;
assign {SD_SCK, SD_MOSI, SD_CS} = 'Z;
assign {SDRAM_DQ, SDRAM_A, SDRAM_BA, SDRAM_CLK, SDRAM_CKE, SDRAM_DQML, SDRAM_DQMH, SDRAM_nWE, SDRAM_nCAS, SDRAM_nRAS, SDRAM_nCS} = 'Z;
assign {DDRAM_CLK, DDRAM_BURSTCNT, DDRAM_ADDR, DDRAM_DIN, DDRAM_BE, DDRAM_RD, DDRAM_WE} = '0;  

assign VGA_SL = 0;
assign VGA_F1 = 0;
assign VGA_SCALER = 0;
assign HDMI_FREEZE = 0;

assign LED_DISK = 0;
assign LED_POWER = 0;
assign BUTTONS = 0;

//////////////////////////////////////////////////////////////////

wire [1:0] ar = status[122:121];

assign VIDEO_ARX = (!ar) ? 12'd4 : (ar - 1'd1);
assign VIDEO_ARY = (!ar) ? 12'd3 : 12'd0;

`include "build_id.v" 
localparam CONF_STR = {
	"PC8001M;;",
	"-;",
	"F,BIND88,Load ROM;",
	"-;",
	"O[122:121],Aspect ratio,Original,Full Screen,[ARC1],[ARC2];",
	"-;",
	"O[1],Green Display,Off,On;",
	"O[3],Full Dot Color,Off,On;",
	"-;",
	"O[4],CPU Mode,PCG8100,PCG8200;",
	"O[5],PCG,Off,On;",
	"O[6],Expansion ROM,Off,On;",
	"O[7],High-speed mode,Off,On;",
	"-;",
	"O[2],Motor Beep,Off,On;",
	"-;",
	"R[0],Reset and close OSD;",
	"V,v",`BUILD_DATE 
};

wire [127:0] status;

wire green_display = status[1];
wire motor_beep = status[2];
wire fdc = status[3];
wire cpu_mode = status[4];
wire pcg = status[5];
wire exp_rom = status[6];
wire high_speed = status[7];
wire [9:0] switch = {high_speed, 1'b0, exp_rom, 1'b0, pcg, cpu_mode, fdc, motor_beep, 1'b0, green_display};

wire forced_scandoubler;
wire [21:0] gamma_bus;

wire        ioctl_download;
wire  [7:0] ioctl_index;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;

wire  [1:0] buttons;
wire  [10:0] ps2_key;

hps_io #(.CONF_STR(CONF_STR)) hps_io
(
	.clk_sys(clk_sys),
	.HPS_BUS(HPS_BUS),
	.EXT_BUS(),
	.gamma_bus(gamma_bus),

	.forced_scandoubler(forced_scandoubler),

	.buttons(buttons),
	.status(status),
	.status_menumask({status[5]}),

	.ioctl_download(ioctl_download),
	.ioctl_index(ioctl_index),
	.ioctl_wr(ioctl_wr),
	.ioctl_addr(ioctl_addr),
	.ioctl_dout(ioctl_dout),
	
	.ps2_key(ps2_key)
);

///////////////////////   CLOCKS   ///////////////////////////////

wire clk_sys,clk48;
wire clk50 = CLK_50M;
pll pll
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_sys),
	.outclk_1(clk48)
);

wire reset = RESET | status[0] | buttons[1];

//////////////////////////////////////////////////////////////////

assign CLK_VIDEO = clk_sys;
wire [3:0] R,G,B;
wire ce_pix;
wire hsync, vsync;

always @(posedge clk48) begin
	reg [2:0] div;
	div <= div + 1'd1;
	ce_pix <= !div;
end

video_mixer #(.LINE_LENGTH(320), .GAMMA(1)) video_mixer
(
        .*,

		.ce_pix(ce_pix),

        .freeze_sync(),

        .scandoubler(scale || forced_scandoubler),
        .hq2x(scale==1),

        .VGA_DE(VGA_DE),
        .R(R),
        .G(G),
        .B(B),

        // Positive pulses.
        .HSync(hsync),
        .VSync(vsync)
);

wire [3:0] audio;
assign AUDIO_L = audio;
assign AUDIO_R = AUDIO_L;
assign AUDIO_S = 0;
assign AUDIO_MIX = 0;

pc8001m pc8001m
(
	.clk50(CLK_50M),		// input wire			clk50,
	.clk2(clk_sys),			// input wire			clk2,	//outclk_0 = 28.63636MHz - ref clk
	.clk48(clk48),			// input wire			clk48,	//outclk_3 = 48.00000MHz - 2nd ref clk for video?
	.reset_n(~RESET),		// input wire			reset_n,
	.ps2_clk(),				// input wire			ps2_clk,
	.ps2_data(),			// input wire			ps2_data,
	.rxd(),					// input wire			rxd, // rxd input JP2-9 PIN_G18 SIO input ・ 
	.cmt_in(),				// input wire			cmt_in, // ○ CMT / SIO input / output ・ cmt_in input JP2-7 PIN_C13 External comparator circuit required) 
	.txd(),					// output wire			txd, // txd output JP2-10 PIN_G17 SIO output <DE10-Lite> 
	// These were commented out as they are for an ext. piezo device. should add them in later mixed into the audio
	// .beep_out(),			// output wire			beep_out,
	// .motor_out(),		// output wire			motor_out,
	.bw_out(),				// output wire [1:0]	bw_out,
	.vga_hs(hsync),			// output wire			vga_hs,
	.vga_vs(vsync),			// output wire			vga_vs,
	.vga_hblank(hblank),	// output wire			vga_hblank,
	.vga_vblank(vblank),	// output wire			vga_vblank,
	.vga_r(R),				// output wire [3:0]	vga_r,
	.vga_g(G),				// output wire [3:0]	vga_g,
	.vga_b(B),				// output wire [3:0]	vga_b,
	// The following were commented out because they are solely for a seven seg display
	// .HEX0(),				// output wire [6:0]	HEX0,
	// .HEX1(),				// output wire [6:0]	HEX1,
	// .HEX2(),				// output wire [6:0]	HEX2,
	// .HEX3(),				// output wire [6:0]	HEX3,
	// .HEX4(),				// output wire [6:0]	HEX4,
	// .HEX5(),				// output wire [6:0]	HEX5,
	// .LEDR(),				// output wire [9:0]	LEDR,

// 	○ Slide SW OFF ON 
//  ・ SW0 color monitor display Green monitor display ・ SW1 unused ・ SW2 BEEP CMT output (linked with motor) 
//  ・ SW3 FDC OFF FDC ON (FDC: PCG full dot color) 
//  ・ SW4 PCG8100 mode PCG8200 mode ・ SW5 PCG OFF PCG ON 
//  ・ SW6 unused ・ SW7 without expansion ROM Expansion ROM (SD-DOS) available ・ SW8 unused 		
//  ・ SW9 Normal mode High-speed mode (WAIT reduced) 
//  * If you move SW9, the operation may freeze. ○ Push button ・ KEY0 reset (STOP + reset possible) 
//  ・ KEY1 unused ・ KEY2 (DE0-CV) unused ・ KEY3 (DE0-CV) unused ○ LED 
	.SW(switch),			// input wire  [9:0]	SW,

	.sd_dat(),				// input wire			sd_dat,
	.sd_clk(),				// output wire			sd_clk,
	.sd_cmd(),				// output wire			sd_cmd,
	.sd_res(),				// output wire			sd_res,
	.audio_out(audio),		// output wire [3:0]	audio_out,
	.dac_out()				// output wire			dac_out
);


reg  [26:0] act_cnt;
always @(posedge clk_sys) act_cnt <= act_cnt + 1'd1; 
assign LED_USER    = act_cnt[26]  ? act_cnt[25:18]  > act_cnt[7:0]  : act_cnt[25:18]  <= act_cnt[7:0];

endmodule
