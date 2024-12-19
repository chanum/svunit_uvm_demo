
`ifndef __ADDR_SEQ_ITEM_SV__
`define __ADDR_SEQ_ITEM_SV__

`include "uvm_macros.svh"
import uvm_pkg::*;

class adder_seq_item extends uvm_sequence_item;

  rand bit[2:0] a;
  rand bit[2:0] b;

  bit[2:0] result;
  bit ovf;

  `uvm_object_utils_begin(adder_seq_item)
    `uvm_field_int(a, UVM_ALL_ON)
    `uvm_field_int(b, UVM_ALL_ON)
    `uvm_field_int(result, UVM_ALL_ON)
    `uvm_field_int(ovf, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "adder_seq_item");
    super.new(name);
  endfunction : new

endclass : adder_seq_item

`endif // __ADDR_SEQ_ITEM_SV__
