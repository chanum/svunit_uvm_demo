`ifndef __ADDER_MODEL_SV__
`define __ADDER_MODEL_SV__

`include "uvm_macros.svh"
`include "adder_seq_item.sv"

import uvm_pkg::*;

class adder_model extends uvm_component;
  `uvm_component_utils(adder_model)

  uvm_blocking_get_port #(adder_seq_item) input_port;

  uvm_blocking_put_port #(adder_seq_item) output_port;

  function new(string name = "adder_model", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    input_port = new("input_port", this);
    output_port = new("output_port", this);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    adder_seq_item tr_item;


    forever begin
      adder_seq_item predicted_item = new();

      input_port.get(tr_item);

      predicted_item.result = tr_item.a + tr_item.b;
      if ((tr_item.a + tr_item.b) > 3'b111) begin
        predicted_item.ovf = 1'b1;
      end

      `uvm_info(get_full_name(), $sformatf("Recieve item: a: %0d  b: %0d - Result: %0d - OVF %b",
                                  tr_item.a, tr_item.b, predicted_item.result, predicted_item.ovf), UVM_NONE)

      output_port.put(predicted_item);
    end

  endtask : run_phase

endclass : adder_model

`endif // __ADDER_MODEL_SV__
