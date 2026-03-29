module Gelu #(parameter in_width=10,dataWidth=32)(
    input [in_width-1:0]in,
    input clk,
    output [dataWidth-1:0]out
);

// Memory Block;
reg [dataWidth-1:0]mem[2**in_width-1:0];
reg [in_width-1 : 0 ]y;

// initializing the .mif file;
initial begin 
    $readmemb("GELU_content.mif",mem,0,2**in_width-1);
end 

always @(posedge clk)
    begin
        if($signed(in) >= 0)// if input x is positive no.
            y <= in+(2**(in_width-1));
        else 
            y <= in-(2**(in_width-1));   // if input x is negative.  
    end

assign out = mem[y];
endmodule
