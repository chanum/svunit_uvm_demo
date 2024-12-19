`include "svunit_defines.svh"
import uvm_pkg::*;
`include "adder_model.sv"
import svunit_uvm_mock_pkg::*;

//===================================
// Component Wrapper
//====================================
class adder_model_uvm_wrapper extends adder_model;
  `uvm_component_utils(adder_model_uvm_wrapper)

  uvm_blocking_put_port #(adder_seq_item) in_put_port;
  uvm_blocking_get_port #(adder_seq_item) out_get_port;

  uvm_tlm_fifo #(adder_seq_item) in_put_fifo, out_get_fifo;

  function new(string name = "adder_model_uvm_wrapper", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_put_port = new("in_put_port", null);
    in_put_fifo = new("in_put_fifo", null);

    out_get_fifo = new("out_get_fifo", null);
    out_get_port = new("out_get_port", null);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    input_port.connect(in_put_fifo.get_export);
    in_put_port.connect(in_put_fifo.put_export);

    out_get_port.connect(out_get_fifo.get_export);
    output_port.connect(out_get_fifo.put_export);
  endfunction : connect_phase
endclass : adder_model_uvm_wrapper

//===================================
// Unit Test Module
//====================================
module adder_model_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "adder_model_ut";
  svunit_testcase svunit_ut;
  //===================================
  // This is the UUT that we're
  // running the Unit Tests on
  //===================================
  adder_model_uvm_wrapper my_adder_model;

  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
    my_adder_model = adder_model_uvm_wrapper::type_id::create("", null);
    svunit_deactivate_uvm_component(my_adder_model);
  endfunction : build

  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

    svunit_activate_uvm_component(my_adder_model);

    //-----------------------------
    // start the testing phase
    //-----------------------------
    svunit_uvm_test_start();

  endtask : setup

  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    //-----------------------------
    // terminate the testing phase 
    //-----------------------------
    svunit_uvm_test_finish();

    /* Place Teardown Code Here */

    svunit_deactivate_uvm_component(my_adder_model);
  endtask : teardown

  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

    // Sanity Test
    `SVTEST(adder_Test)
      adder_seq_item in_tr, out_tr;
      in_tr = new();
      in_tr.a = 3'b000;
      in_tr.b = 3'b001;
      my_adder_model.in_put_port.put(in_tr);
      my_adder_model.out_get_port.get(out_tr);

      `FAIL_IF(out_tr.result != in_tr.a + in_tr.b)
      `FAIL_IF(out_tr.ovf != 1'b0)

    `SVTEST_END

    // Overflow Test
    `SVTEST(ovf_Test)
      adder_seq_item in_tr, out_tr;
      in_tr = new();
      in_tr.a = 3'b110; //$urandom();
      in_tr.b = 3'b010; //$urandom();
      my_adder_model.in_put_port.put(in_tr);
      my_adder_model.out_get_port.get(out_tr);

      `FAIL_IF(out_tr.result != in_tr.a + in_tr.b)
      if ((in_tr.a + in_tr.b) > 3'b111) begin
        `FAIL_IF(out_tr.ovf != 1'b1)
      end
      else begin
        `FAIL_IF(out_tr.ovf != 1'b0)
      end

    `SVTEST_END

    // Random Test
    `SVTEST(rand_Test)
      int iteractions = 5;
      adder_seq_item in_tr, out_tr;

      for (int i=0; i<iteractions; i++) begin
        in_tr = new();
        in_tr.a = $urandom();
        in_tr.b = $urandom();
        my_adder_model.in_put_port.put(in_tr);
        my_adder_model.out_get_port.get(out_tr);

        `FAIL_IF(out_tr.result != in_tr.a + in_tr.b)
        if ((in_tr.a + in_tr.b) > 3'b111) begin
          `FAIL_IF(out_tr.ovf != 1'b1)
        end
        else begin
          `FAIL_IF(out_tr.ovf != 1'b0)
        end
      end

    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule : adder_model_unit_test
