// Testbench for GELU module
`timescale 1ns/1ns
module tb_gelu;

    // Parameters
    localparam in_width  = 10;
    localparam dataWidth = 32;

    // Clock and signals
    reg                         clk;
    reg  [in_width-1:0]         in;
    wire [dataWidth-1:0]        out;

    // Reference memory (same as DUT)
    reg [dataWidth-1:0]         ref_mem [0:(1<<in_width)-1];

    // Instantiate DUT
    Gelu #(
        .in_width (in_width),
        .dataWidth(dataWidth)
    ) u_gelu (
        .in  (in),
        .clk (clk),
        .out (out)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    // Load the MIF file into reference memory
    initial begin
        $readmemb("GELU_content.mif", ref_mem);
    end

    // Main test procedure
    integer i;
    reg [in_width-1:0] y;          // computed address
    reg [dataWidth-1:0] expected;

    initial begin 
        $dumpfile("testbench.vcd");
        $dumpvars(0,tb_gelu);
    end

    initial begin
        // Initialize signals
        clk = 0;
        in  = 0;

        // Apply reset (optional – not used by DUT, but good practice)
        repeat (2) @(posedge clk);

        // Loop over all possible signed 10-bit inputs
        for (i = -512; i <= 511; i = i + 1) begin
            // Convert integer to 10-bit signed representation
            in = i[in_width-1:0];    // truncate to 10 bits (preserves sign)

            // Wait one clock cycle for the output to update (DUT has one cycle latency)
            @(posedge clk);

            // Compute the address that DUT would use (same logic as in DUT)
            if ($signed(in) >= 0)
                y = in + (1 << (in_width-1));
            else
                y = in - (1 << (in_width-1));

            // Fetch expected value from reference memory
            expected = ref_mem[y];

            // Compare with DUT output
            if (out === expected) begin
                $display("[PASS] in = %0d (0x%0h) -> y = 0x%0h, out = 0x%0h", 
                         $signed(in), in, y, out);
            end else begin
                $display("[FAIL] in = %0d (0x%0h) -> y = 0x%0h, out = 0x%0h, expected = 0x%0h",
                         $signed(in), in, y, out, expected);
            end
        end

        $display("Test completed.");
        $finish;
    end

endmodule
