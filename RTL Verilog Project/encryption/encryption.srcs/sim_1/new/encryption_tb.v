`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for AES Decryption Top Module (Final Output Only)
//////////////////////////////////////////////////////////////////////////////////

module encryption_tb();

    reg clk;
    reg rst;
    reg [31:0] key_in;
    reg [31:0] plain_text_in;
    wire [127:0] cipher_text;
    wire done_flag;

    // Instantiate DUT
    encryption_top dut (
        .clk(clk),
        .rst(rst),
        .done_flag(done_flag),
        .key_in(key_in),
        .plain_text_in(plain_text_in),
        .cipher_text(cipher_text)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Cycle counting
    integer cycle_count = 0;
    reg counting = 0;
    integer throughput_mbps;

    initial begin
        clk = 0;
        rst = 1;
        key_in = 32'h0;
        plain_text_in = 32'h0;

        // Apply reset
        #20 rst = 0;

        // Feed 128-bit key and ciphertext over 4 clock cycles (MSB to LSB)
        @(posedge clk); key_in = 32'h00000000; plain_text_in = 32'h11223344;
        @(posedge clk); key_in = 32'h00000000; plain_text_in = 32'h55667788;
        @(posedge clk); key_in = 32'h00000000; plain_text_in = 32'h9900aabb;
        @(posedge clk); key_in = 32'h00000000; plain_text_in = 32'hccddeeff;

        // Start counting cycles after input loaded
        counting = 1;

       while (!done_flag) begin
            @(posedge clk);
            if (counting) begin
                cycle_count = cycle_count + 1;
                if (dut.round_counter <= 9) begin
                    $display("==================== Round %0d ====================", dut.round_counter);
                    $display("shift_out : %h", dut.shift_out);
                    $display("sub_out   : %h", dut.sub_out);
                    $display("add_out   : %h", dut.add_out);
                    $display("mix_out   : %h", dut.mix_out);
                    $display("======================================================");
                end
            end
        end
        
        

        counting = 0;
        #20;

        // Calculate throughput: 128 bits in 'cycle_count' cycles at 100 MHz
        throughput_mbps = (128 * 100) / cycle_count;

        // Display results
        $display("\n==================== Final Result ====================");
        $display("Decrypted Plaintext : %h", cipher_text);
        $display("Latency             : %0d cycles", cycle_count);
        $display("Throughput          : %0d Mbps", throughput_mbps);
        $display("======================================================");

        $finish;
    end

endmodule
