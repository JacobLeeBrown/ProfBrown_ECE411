module arb_control (
    input clk,

    // inputs
    input  logic icache_read, dcache_read, dcache_write,

    // outputs
    output logic [1:0] arb_mux_sel
);

// List of states
enum int unsigned {
    idle,
    d_read,
    d_write,
    i_read
} state, next_state;

always_comb
begin : state_actions
    // Default control signal assignments
    arb_mux_sel = 1'b0;

    case(next_state)

        idle:    /* Do nothing */;

        d_read:  arb_mux_sel = 1;

        d_write: arb_mux_sel = 2;

        i_read:  arb_mux_sel = 3;

        default: /* Do nothing */;
        
    endcase

end : state_actions

always_comb
begin : next_state_logic

    next_state = state;

    // See draw.io, "Arbiter" page.
    case(state)
        
        idle: begin
            // This prioritizes D-cache.
            if      ( dcache_read  ) next_state = d_read;
            else if ( dcache_write ) next_state = d_write;
            else if ( icache_read  ) next_state = i_read;
        end

        d_read: begin
            if ( ~dcache_read ) next_state = idle;
        end

        d_write: begin
            if ( ~dcache_write ) next_state = idle;
        end

        i_read: begin
            if ( ~icache_read ) next_state = idle;
        end

    endcase
end : next_state_logic

// Next state assignment.
always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : arb_control
