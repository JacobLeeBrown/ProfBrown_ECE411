module cache_control #(parameter ways = 2)
(
    input clk,

    /* Inputs */
    // CPU
    input logic mem_read,
    input logic mem_write,
    // Memory
    input logic pmem_resp,
    // Cache Datapath
    input logic [ways-1:0] hits,
    input logic dirty,
    input logic [$clog2(ways)-1:0] lru_out,

    /* Outputs */
    // CPU
    output logic mem_resp,
    // Memory
    output logic pmem_read,
    output logic pmem_write,
    // Cache Datapath
    output logic load_lru,
    output logic [$clog2(ways)-1:0] way_sel,
    output logic load_word,
    output logic load_line,
    output logic tag_sel

);

logic mem_action, hit_sig;

assign mem_action = mem_write | mem_read;
assign hit_sig = |hits;

enum int unsigned {
    /* List of states */
    idle_hit,
    write_back,
    write_back2,
    read
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    way_sel = 1'b0;
    tag_sel = 1'b0;
    load_word = 1'b0;
    load_line = 1'b0;
    load_lru = 1'b0;
    pmem_write = 1'b0;
    pmem_read = 1'b0;
    mem_resp = 1'b0;

    /* Actions for each state */
    case(state)

        idle_hit: begin
            if(hit_sig & mem_action) begin
                // We had a hit!
                for(int i = 0; i < ways; i++) begin
                    if(hits[i]) way_sel = i[$clog2(ways)-1:0];
                end
                // Only load a word if we're writing
                load_word = mem_write;
                // Update LRU
                load_lru = 1;
                // lru_in logic handled in datapath now
                // We did it! Let CPU know we're all done
                mem_resp = 1;
            end
        end

        write_back: begin
            // Tell memory we need to write the LRU line
            tag_sel = 1;
            way_sel = lru_out;
            pmem_write = 1;
        end

        write_back2: begin
            tag_sel = 1;
            way_sel = lru_out;
        end

        read: begin
            // Read physical memory into LRU line
            // tag_sel = 0;
            pmem_read = 1;

            // read2
            if(pmem_resp) begin
                way_sel = lru_out;
                load_line = 1;
            end
        end

        /*********************/

        default: /* Do nothing */;
    endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
    next_state = state;
    case(state)
        
        idle_hit: begin
            if(mem_action & (dirty & !hit_sig)) next_state = write_back;
            else if(mem_action & (!dirty & !hit_sig)) next_state = read;
        end

        write_back: if(pmem_resp) next_state = write_back2;

        write_back2: next_state = read;

        read: if(pmem_resp) next_state = idle_hit;

    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control
