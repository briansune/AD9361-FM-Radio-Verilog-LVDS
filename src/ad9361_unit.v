// ==================================================
//  ____         _                ____                      
// | __ )  _ __ (_)  __ _  _ __  / ___|  _   _  _ __    ___ 
// |  _ \ | '__|| | / _` || '_ \ \___ \ | | | || '_ \  / _ \
// | |_) || |   | || (_| || | | | ___) || |_| || | | ||  __/
// |____/ |_|   |_| \__,_||_| |_||____/  \__,_||_| |_| \___|
//                                                          
// Programed By: BrianSune
// Contact: briansune@gmail.com
// 

`timescale 1ns / 1ps

module ad9361_unit(
	// 200MHz LVDS differential clock and high-valid reset signal.
	input 					sys_clk,
	input 					sys_nrst,
	
	// AD9361 4-wire SPI interface.
	output 					ad9361_spi_cs,		// SPI_ENB
	output 					ad9361_spi_sclk,	// SPI_CLK
	output 					ad9361_spi_mosi,	// SPI_DI
	input 					ad9361_spi_miso,	// SPI_DO
	
	// AD9361 control signal.
	output 					en_agc,				// EN_AGC
	output 					enable,				// ENABLE
	output 					resetb,				// RESETB
	output 					txnrx,				// TXNRX
	output 					sync_in,			// SYNC_IN
	output 		[3 : 0]  	ctrl_in,			// CTRL_IN
	input  		[7 : 0]		ctrl_out,			// CTRL_OUT
	
	input					ad9361_dclk,
	input		[13 : 0]	ad9361_din,
	output		[13 : 0]	ad9361_dout,
	
	output 		 [7 : 0]  	led,
	
	output signed [15 : 0]	rx_q,
	output signed [15 : 0]	rx_i
);
	
	ad9361_init uut_ad9361_init (
		.sys_clk(sys_clk),
		.sys_rst(~sys_nrst),
		.ad9361_spi_cs(ad9361_spi_cs),
		.ad9361_spi_sclk(ad9361_spi_sclk),
		.ad9361_spi_mosi(ad9361_spi_mosi),
		.ad9361_spi_miso(ad9361_spi_miso),
		.en_agc(en_agc),
		.enable(enable),
		.resetb(resetb),
		.txnrx(txnrx),
		.sync_in(sync_in),
		.ctrl_in(ctrl_in),
		.ctrl_out(ctrl_out),
		.led(led)
	);
	
	assign ad9361_dout = {1'b1,6'b000_000,1'b0,6'b000_000};
	
	reg [5:0] 	i_path_r, q_path_r;
	reg [11:0] 	i_path_ro, q_path_ro;
	
	wire [5:0]	a, b;
	
	assign a = ad9361_din[12 : 7];
	assign b = ad9361_din[5 : 0];
	
	always @(posedge ad9361_dclk or negedge sys_nrst) begin
		if(!sys_nrst) begin
			i_path_r <= 6'd0;
			q_path_r <= 6'd0;
			
			i_path_ro <= 12'd0;
			q_path_ro <= 12'd0;
		end else begin
			
			if(ad9361_din[13])begin
				i_path_r <= a;
				q_path_r <= b;
			end else begin
				i_path_ro <= {i_path_r, a};
				q_path_ro <= {q_path_r, b};
			end
		end
	end
	
	assign rx_q = {4'd0, q_path_ro};
	assign rx_i = {4'd0, i_path_ro};
	
endmodule
