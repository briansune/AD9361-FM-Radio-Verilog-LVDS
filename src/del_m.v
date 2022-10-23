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

module del_m(
	
	input aclk,
	input aresetn,
	
	input 	[15 : 0]	tap_i,
	input 	[15 : 0]	tap_q,
	
	output	[31 : 0]	out0,
	output	[31 : 0]	out1,
	
	output					valid
);
	
	
	reg signed		[15 : 0]	delay_i0;
	reg signed		[15 : 0]	delay_q0;
	
	reg signed		[15 : 0]	delay_i1;
	reg signed		[15 : 0]	delay_q1;
	
	always@(posedge aclk or negedge aresetn)begin
		if(!aresetn)begin
			delay_i0 <= 16'd0;
			delay_i1 <= 16'd0;
			delay_q0 <= 16'd0;
			delay_q1 <= 16'd0;
		end else begin
			delay_i0 <= tap_i;
			delay_i1 <= delay_i0;
			
			delay_q0 <= tap_q;
			delay_q1 <= -delay_q0;
		end
	end
	
	assign out0 = {delay_q0, delay_i0};
	assign out1 = {delay_q1, delay_i1};
	assign valid = 1'b1;
	
endmodule
