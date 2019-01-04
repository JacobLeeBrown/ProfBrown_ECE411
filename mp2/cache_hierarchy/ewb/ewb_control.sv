
module ewb_control
(
    input clk,

    // Datapath
    input  logic valid_out,
    output logic valid_in,
    output logic out_sel,
    output logic load,

    // Higher level memory
    input  logic mem_read,
    input  logic mem_write,
    output logic mem_resp,

    // Lower level memory
    output logic pmem_read,
    output logic pmem_write,
    input  logic pmem_resp
);

// List of states
enum int unsigned {
    idle_buffer,
    buffer_resp,
    read,
    writeback
} state, next_state;

always_comb
begin : state_actions
    // Default control signal assignments
    valid_in = 1'b0;
    out_sel = 1'b0;
    load = 1'b0;
    mem_resp = 1'b0;
    pmem_write = 1'b0;
    pmem_read = 1'b0;

    case(state)

        idle_buffer: begin
            if(mem_write) begin
                valid_in = 1;
                load = 1;
            end
        end

        buffer_resp: begin
            mem_resp = 1;
        end

        read: begin
            out_sel = 0;
            pmem_read = 1;
            if(pmem_resp) mem_resp = 1;
        end

        writeback: begin
            out_sel = 1;
            pmem_write = 1;
            if(pmem_resp) begin
                valid_in = 0;
                load = 1;
            end
        end

        default: /* Do nothing */;
        
    endcase

end : state_actions

always_comb
begin : next_state_logic

    next_state = state;

    case(state)
        
        idle_buffer: begin
            if      ( mem_write ) next_state = buffer_resp;
            else if ( mem_read  ) next_state = read;
        end

        buffer_resp: next_state = idle_buffer;

        read: begin
            if      ( pmem_resp & ~valid_out ) next_state = idle_buffer;
            else if ( pmem_resp & valid_out  ) next_state = writeback;
        end

        writeback: begin
            if ( pmem_resp ) next_state = idle_buffer;
        end

    endcase
end : next_state_logic

// Next state assignment.
always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : ewb_control
