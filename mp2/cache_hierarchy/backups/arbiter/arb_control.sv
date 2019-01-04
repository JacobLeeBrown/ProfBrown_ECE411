module arb_control (
	input clk,

	// inputs
	input  logic icache_read, dcache_read, dcache_write,
	input  logic l2_resp,

	// outputs
	output logic l2_read, l2_write,
	output logic arb_mux_sel
);

// Internal Signals

// List of states
enum int unsigned {
    idle,
    i_read,
    d_read,
    d_write
} state, next_state;

always_comb
begin : state_actions
    // Default control signal assignments
	arb_mux_sel = 1'b0;
	l2_read = 1'b0;
	l2_write = 1'b0;

    case(state)

        idle: begin
        end

        i_read: begin
            arb_mux_sel = 0;
            l2_read = 1;
        end // i_read:

        d_read: begin
            arb_mux_sel = 1;
            l2_read = 1;
        end

        d_write: begin
            arb_mux_sel = 1;
            l2_write = 1;
        end

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
            if ( dcache_read ) next_state = d_read;

            if ( dcache_write ) next_state = d_write;
            else if ( icache_read ) next_state = i_read;
        end

        i_read: begin
            if ( l2_resp ) next_state = idle;
        end

        d_read: begin
			if ( l2_resp ) next_state = idle;
		end

        d_write: begin
            if ( l2_resp ) next_state = idle;
        end

    endcase
end : next_state_logic

// Next state assignment.
always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : arb_control
