# svunit_uvm_demo
Simple Unit test for UVM components

## Demo Description:
The Adder Model is a uvm_component that gets a tlm transaction through input_port, performs the sum of a + b (and predicts ovf) stores it in result field and sends it through output_port.



The Unit test Wrapper for this Adder Model was generated with this command:
- create_unit_test.pl -uvm adder_model.sv

The adder_model_uvm_wrapper `adder_model\adder_model_unit_test.sv` extend of the adder_model and there we perform the ports connection.
Later in the module `adder_model_unit_test` we describe the tests `SVTEST()

In this example, there are threee test:
- `SVTEST(adder_Test)
- `SVTEST(ovf_Test)
- `SVTEST(rand_Test)

## How to run it (QuestaSim):

- Download SVUnit from [GitHub](https://github.com/svunit/svunit/archive/master.zip)
- Unzip master.zip
- cd svunit-master
- Run ./Setup.bsh 
- Go to the adder_model folder
- Run: runSVUnit -uvm -s questa

![image](https://github.com/user-attachments/assets/8a9c650c-0e73-4b39-851b-0fc1762e3c2c)

More info in SVUnit [Doc](https://docs.svunit.org/en/latest/)


