import rv32i_types::*;

module arb_datapath (
    input  logic clk,
    input  logic arb_mux_sel,
    input  logic load_arb,

    // I-Cache
    input  rv32i_word ipmem_address,
    input  rv32i_cache_line ipmem_wdata,
    output rv32i_cache_line ipmem_rdata,
    input  logic ipmem_read,
    input  logic ipmem_write,
    output logic ipmem_resp,

    // D-Cache
    input  rv32i_word dpmem_address,
    input  rv32i_cache_line dpmem_wdata,
    output rv32i_cache_line dpmem_rdata,
    input  logic dpmem_read,
    input  logic dpmem_write,
    output logic dpmem_resp,

    // L2 Cache
    output rv32i_word l2mem_address,
    output rv32i_cache_line l2mem_wdata,
    input  rv32i_cache_line l2mem_rdata,
    output logic l2mem_read,
    output logic l2mem_write,
    input  logic l2mem_resp
);

initial
begin
    ipmem_resp = 0;
    dpmem_resp = 0;
    ipmem_rdata = 0;
    dpmem_rdata = 0;
    l2mem_address = 0;
end

// if 1, from_dcache. if 0, from_icache.
// this is a register
always_ff @(posedge clk)
begin
    if (load_arb)
    begin
        if (~arb_mux_sel)
        begin // 0
            l2mem_address <= ipmem_address;
            l2mem_wdata   <= ipmem_wdata;
            ipmem_rdata   <= l2mem_rdata;
            l2mem_read    <= ipmem_read;
            l2mem_write   <= ipmem_write;
        end // 1
        else begin
            l2mem_address <= dpmem_address;
            l2mem_wdata   <= dpmem_wdata;
            dpmem_rdata   <= l2mem_rdata;
            l2mem_read    <= dpmem_read;
            l2mem_write   <= dpmem_write;
        end
    end

    // always do this (ie not on load_arb)
    if (~arb_mux_sel)
    begin
        ipmem_resp <= l2mem_resp;
        dpmem_resp <= 0;
    end
    else begin
        ipmem_resp <= 0;
        dpmem_resp <= l2mem_resp;
    end

end

endmodule : arb_datapath
