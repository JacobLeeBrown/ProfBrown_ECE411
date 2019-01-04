import rv32i_types::*;
import pipeline_types::*;

module forward_unit (

    input control_word cw_execute,
    input storage_t    st_execute,

    input control_word cw_memory,
    input storage_t    st_memory_forward,

    input control_word cw_writeback,
    input storage_t    st_writeback_forward,
    input rv32i_word   reg_wdata,

    /*
        select decoding
        2'b00: regular
        2'b01: memory forward
        2'b10: writeback forward
        2'b11: dead
    */
    output forward_info fi_execute

);

rv32i_word memory_val;
logic [1:0] aluforwardmux1_sel, aluforwardmux2_sel;
logic [1:0] cmpforwardmux1_sel, cmpforwardmux2_sel;

forward_val forward_val
(
    .*
);

forward_control forward_control
(
    .*
);

always_comb
begin
    fi_execute.aluforwardmux1_sel = aluforwardmux1_sel;
    fi_execute.aluforwardmux2_sel = aluforwardmux2_sel;
    fi_execute.cmpforwardmux1_sel = cmpforwardmux1_sel;
    fi_execute.cmpforwardmux2_sel = cmpforwardmux2_sel;
    fi_execute.memory_val = memory_val;
    fi_execute.writeback_val = reg_wdata;
end


endmodule
