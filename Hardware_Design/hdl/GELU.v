module Gelu #(parameter in_width=10,dataWidth=32)(
    input [in_width-1:0]In,
    input clk,
    output [dataWidth-1:0]out
);

// Memory Block;
reg [dataWidth-1:0]mem[0:2**in_width-1];
reg [in_width-1 : 0 ]y;

// initializing the .mif file;
initial begin 
    $readmemb("float32_output.csv",mem);
end 

always @(posedge clk)
    begin
        if($signed(In) >= 0)// if input x is positive no.
            y <= In+(2**(in_width-1));
        else 
            y <= In-(2**(in_width-1));   // if input x is negative.  
    end

assign out = mem[y];
endmodule
