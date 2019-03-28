library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity full_adder_tb is
  end full_adder_tb;

architecture behav of full_adder_tb is
  --  Declaration of the component that will be instantiated.
component full_adder is
port(
    A:  in std_logic;
    B:   in std_logic;
    carry_in: in std_logic; -- 0 Add 1 Subtract
    O:  out std_logic;
    carry_out: out std_logic
    );
end component;
  --  Specifies which entity is bound with the component.
  -- for shift_reg_0: full_adder use entity work.mux(rtl);
  signal a, b, cin, cout, o : std_logic;
begin
  --  Component instantiation.
  full_adder_0: full_adder
  port map (
             A => a,
             B => b,
             carry_in => cin,
             carry_out => cout,
             O => o);

  --  This process does the real job.
  process
  type pattern_type is record
    --  The inputs and output of the full_adder.
    a, b, cin, cout, o: std_logic;
  end record;
  --  The patterns to apply.
  type pattern_array is array (natural range <>) of pattern_type;
  constant patterns : pattern_array := (
  ('0', '0', '0', '0', '0' ),
  ('0', '0', '1', '0', '1' ),
  ('0', '1', '0', '0', '1' ),
  ('0', '1', '1', '1', '0' ),
  ('1', '0', '0', '0', '1' ),
  ('1', '0', '1', '1', '0' ),
  ('1', '1', '0', '1', '0' ),
  ('1', '1', '1', '1', '1' )
);
  begin
    --  Check each pattern.
    for n in patterns'range loop
      --  Set the inputs.
      a <= patterns(n).a;
      b <= patterns(n).b;
      cin <= patterns(n).cin;
      cout <= patterns(n).cout;
      --  Wait for the results.
      wait for 1 ns;
      --  Check the outputs.
      assert o = patterns(n).o
      report "bad output value" severity error;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
