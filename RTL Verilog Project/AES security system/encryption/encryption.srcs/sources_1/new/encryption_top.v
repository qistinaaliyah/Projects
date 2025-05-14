`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// AES Encryption Top Module 
//
// Description:
// - Loads 128-bit plaintext and key over 4 clock cycles (32 bits-by-32 bits)
// - Uses a key expansion module to generate 11 round keys
// - Performs 10 rounds of AES encryption
// - Uses a pipeline register (round_output_reg) between rounds

//Pipeline Explanation:
// - round_output_reg is the main pipeline register.
// - Each AES encryption round is executed in one cycle, and its output is staged in round_output_reg.
// - Internally, the decryption round includes: SubBytes -> ShiftRows -> MixColumns-> AddRoundKey 
// - The pipeline register allows clean data separation between rounds and enhances throughput.
//////////////////////////////////////////////////////////////////////////////////

module encryption_top(
    input clk,
    input rst,
    input [31:0] key_in,
    input [31:0] plain_text_in,
    output wire [127:0] cipher_text,
    output reg done_flag
);

    // === Internal Registers ===
    reg [127:0] full_key;                // 128-bit AES key (loaded 32 bits at a time)
    reg [127:0] full_plain_text;         // 128-bit plaintext (loaded 32 bits at a time)
    reg [2:0] load_counter;              // Counts up to 4 for full key/plaintext loading
    reg data_ready, key_loaded;         // Flags to indicate when input and keys are ready

    reg [127:0] round_key_mem [0:10];    // Round key storage (0 to 10)
    wire [127:0] generated_round_keys [0:10]; // Output from key expansion
    wire done;                           // Key expansion complete signal

    reg [3:0] key_index;
    reg pipeline_valid;

    // === FSM and Output ===
    reg [3:0] round_counter;             // Counter for AES rounds (1 to 10)
    reg encrypting;                      // FSM state flag for active encryption
    reg [127:0] round_output_reg;        // <<<<<<<< PIPELINE REGISTER >>>>>>>>
                                         // This stages the output between AES rounds
    reg [127:0] cipher_text_reg;         // Final ciphertext result

    // === Round Processing Wires ===
    wire [127:0] sub_out, shift_out, mix_out, add_out;

    // === Step 1: Load Key and Plaintext ===
    // This block assembles the full 128-bit key and plaintext from four 32-bit inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            full_key <= 0;
            full_plain_text <= 0;
            load_counter <= 0;
            data_ready <= 0;
        end else if (load_counter < 4) begin
            case (load_counter)
                0: begin full_key[127:96] <= key_in; full_plain_text[127:96] <= plain_text_in; end
                1: begin full_key[95:64]  <= key_in; full_plain_text[95:64]  <= plain_text_in; end
                2: begin full_key[63:32]  <= key_in; full_plain_text[63:32]  <= plain_text_in; end
                3: begin full_key[31:0]   <= key_in; full_plain_text[31:0]   <= plain_text_in; data_ready <= 1; end
            endcase
            load_counter <= load_counter + 1;
        end
    end

    integer i;
    // === Step 2: Store Round Keys into Memory ===
    // Wait for key expansion to complete, then write each key one per cycle
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            key_loaded <= 0;
            key_index <= 0;
            pipeline_valid <= 0;
            for (i = 0; i <= 10; i = i + 1)
                round_key_mem[i] <= 0;
        end else begin
            if (done && !pipeline_valid) begin
                key_index <= 0;
                pipeline_valid <= 1;
            end
            if (pipeline_valid) begin
                round_key_mem[key_index] <= generated_round_keys[key_index];
                key_index <= key_index + 1;
                if (key_index == 10) begin
                    key_loaded <= 1;
                    pipeline_valid <= 0;
                end
            end
        end
    end

    // === Step 3: Key Expansion Module ===
    // Generates 11 round keys from 128-bit AES key
    keyexpansion_encrypt key_exp_inst (
        .clk(clk),
        .rst(rst),
        .input_key(full_key),
        .round_key_0(generated_round_keys[0]),
        .round_key_1(generated_round_keys[1]),
        .round_key_2(generated_round_keys[2]),
        .round_key_3(generated_round_keys[3]),
        .round_key_4(generated_round_keys[4]),
        .round_key_5(generated_round_keys[5]),
        .round_key_6(generated_round_keys[6]),
        .round_key_7(generated_round_keys[7]),
        .round_key_8(generated_round_keys[8]),
        .round_key_9(generated_round_keys[9]),
        .round_key_10(generated_round_keys[10]),
        .done(done)
    );

    // === Step 4: FSM and Pipeline Register Logic ===
    // Handles round progression and pipelined state between rounds
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round_counter <= 0;
            encrypting <= 0;
            round_output_reg <= 0;
            cipher_text_reg <= 0;
            done_flag <= 0;
        end else if (key_loaded && !encrypting) begin
            round_output_reg <= full_plain_text ^ round_key_mem[0]; // Initial AddRoundKey
            round_counter <= 1;
            encrypting <= 1;
        end else if (encrypting) begin
            if (round_counter < 10) begin
                round_output_reg <= add_out; // Pipeline forward output of AddRoundKey
                round_counter <= round_counter + 1;
            end else begin
                cipher_text_reg <= add_out; // Final round result
                encrypting <= 0;
                done_flag <= 1;
            end
        end
    end

    // === Step 5: AES Round Combinational Logic ===
    // AES round flow: SubBytes → ShiftRows → (MixColumns) → AddRoundKey
    subbyte u_sub (.in(round_output_reg), .out(sub_out));
    shiftrow u_shift (.state_in(sub_out), .state_out(shift_out));

    wire [127:0] mix_out_final;
    mixcol u_mix (.state_in(shift_out), .state_out(mix_out_final));

    assign mix_out = (round_counter < 10) ? mix_out_final : shift_out;

    addroundkey_encrypt u_add (
        .state_in(mix_out),
        .round_key(round_key_mem[round_counter]),
        .state_out(add_out)
    );

    // === Output Assignment ===
    assign cipher_text = cipher_text_reg;

endmodule
