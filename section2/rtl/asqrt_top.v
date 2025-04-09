module asqrt_top
#(parameter N_PIPES=1, parameter N_DEPTH=32, parameter N_CYCLES=1)
(
    input reset,
    input clk,

    input ready,
    output valid,

    input [N_PIPES*32-1:0] queries,
    output [N_PIPES*32-1:0] results
);

    wire [N_PIPES-1:0] valids;

    genvar i;
    generate
        for(i=0; i < N_PIPES; i = i + 1) begin
            asqrt_pipe #(.N_DEPTH(N_DEPTH), .N_CYCLES(N_CYCLES)) pipe (
                .clk,
                .reset,
                .ready,
                .valid(valids[i]),
                .query(queries[i * 32 +: 32]),
                .result(results[i * 32 +: 32])
            );
        end
    endgenerate

    assign valid = | {valids};

endmodule