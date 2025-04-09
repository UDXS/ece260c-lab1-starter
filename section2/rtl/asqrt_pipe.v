module asqrt_pipe
#(parameter N_DEPTH=32, parameter N_CYCLES=1)
(
    input reset,
    input clk,

    input ready,
    input [31:0] query,

    output reg valid,
    output reg [31:0] result
);

    reg [31:0] this_query;
    wire [31:0] att [0:N_DEPTH];
    wire [31:0] res [0:N_DEPTH];
    wire [31:0] eps [0:N_DEPTH];

    assign att[0] = 65536;
    assign res[0] = 0;
    assign eps[0] = this_query;

    genvar i;

    generate
        for(i=1; i <= N_DEPTH; i = i + 1) begin
            asqrt_iu unit(.prev_att(att[i-1]),
                                .prev_eps(eps[i-1]), 
                                .prev_res(res[i-1]),
                                .this_att(att[i]),
                                .this_eps(eps[i]),
                                .this_res(res[i])
                                );
        end
    endgenerate

    localparam FSM_RESET = 2'b00;
    localparam FSM_RUNNING = 2'b01;
    localparam FSM_DONE = 2'b01;

    reg [1:0] state;
    reg [4:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= FSM_RESET;
            valid <= 1'b0;
            this_query <= 0;
            counter <= 0;
        end else begin
            if (state == FSM_RESET && ready) begin
                state <= FSM_RUNNING;
                this_query <= query;
                counter <= N_CYCLES - 1;
            end else if (state == FSM_RUNNING) begin
                if(counter == 5'b0) begin
                    state <= FSM_DONE;
                    result <= res[N_DEPTH];
                    valid <= 1'b1;
                end else begin
                    counter <= counter - 5'b1;
                    this_query <= res[N_DEPTH];
                end
            end
            else if(state == FSM_DONE) begin
                state <= FSM_RESET;
                valid <= 1'b0;
            end
        end
    end

endmodule