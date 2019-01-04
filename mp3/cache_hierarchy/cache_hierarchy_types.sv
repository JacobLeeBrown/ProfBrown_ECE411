package cache_hierarchy_types;

import rv32i_types::*;

// typedef struct packed
// {
//     logic [23:0] tag;
//     rv32i_word word;
//     rv32i_cache_line line;
//     logic dirty;
// } l1_t;

// typedef struct packed
// {
//     logic [23:0] tag;
//     rv32i_cache_line line;
//     logic dirty;
// } l2_t;

typedef struct packed
{
    rv32i_word address;
    rv32i_cache_line data;
} vc_t;

endpackage : cache_hierarchy_types