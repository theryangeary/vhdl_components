GHDL=ghdl
FLAGS=""

all: mux shift_reg shift_reg_8 full_adder 

%: %.vhdl %_tb.vhdl
	$(GHDL) -a $@.vhdl $@_tb.vhdl
	$(GHDL) -e $@
	$(GHDL) -e $@_tb
	$(GHDL) -r $@_tb --vcd=$@.vcd
