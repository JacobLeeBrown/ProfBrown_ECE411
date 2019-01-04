
module vc_control #(parameter entries = 8)
(
    input clk,

    // Datapath
    input  logic full,
    input  logic hit,
    input  logic [$clog2(entries)-1:0] hit_idx,
    input  logic [$clog2(entries)-1:0] circular_idx,
    output logic [$clog2(entries)-1:0] idx,
    output logic load,
    output logic circular_inc,
    output logic read_sel,
    output logic out_sel,

    // Higher level memory
    input  logic mem_read,
    input  logic mem_write,
    output logic mem_resp,

    // Lower level memory
    output logic pmem_read,
    output logic pmem_write,
    input  logic pmem_resp
);

initial
begin // Bit magic to ensure entries is a power of 2
    pow2: assert(entries && ((entries & (entries-1)) == 0));
end

// List of states
enum int unsigned {
    idle_write_hit,
    resp,
    buffer,
    writeback,
    read_hit,
    read_miss
} state, next_state;

always_comb
begin : state_actions
    // Default control signal assignments
    idx = circular_idx;
    load = 0;
    circular_inc = 0;
    read_sel = 0;
    out_sel = 0;
    mem_resp = 0;
    pmem_read = 0;
    pmem_write = 0;

    case(state)

        idle_write_hit: begin
            if(mem_write & hit) begin
                idx = hit_idx;
                load = 1;
            end
        end

        resp: begin
            mem_resp = 1;
        end

        buffer: begin
            idx = circular_idx;
            load = 1;
            circular_inc = 1;
        end

        writeback: begin
            idx = circular_idx;
            out_sel = 1;
            pmem_write = 1;
        end

        read_hit: begin
            idx = hit_idx;
            read_sel = 1;
            mem_resp = 1;
        end

        read_miss: begin
            pmem_read = 1;
            read_sel = 0;
            out_sel = 0;
            if(pmem_resp) mem_resp = 1;
        end

        default: /* Do nothing */;
        
    endcase

end : state_actions

always_comb
begin : next_state_logic

    next_state = state;

    case(state)
        
        idle_write_hit: begin
            if      ( mem_write &  hit         ) next_state = resp;
            else if ( mem_write & ~hit & ~full ) next_state = buffer;
            else if ( mem_write & ~hit &  full ) next_state = writeback;
            else if ( mem_read  &  hit         ) next_state = read_hit;
            else if ( mem_read  & ~hit         ) next_state = read_miss;
        end

        resp:                    next_state = idle_write_hit;

        buffer:                  next_state = resp;

        writeback: if(pmem_resp) next_state = buffer;

        read_hit:                next_state = idle_write_hit;

        read_miss: if(pmem_resp) next_state = idle_write_hit;

    endcase
end : next_state_logic

// Next state assignment.
always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : vc_control
