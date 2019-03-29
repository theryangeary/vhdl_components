library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity add_sub_tb is
  end add_sub_tb;

architecture behav of add_sub_tb is
  --  Declaration of the component that will be instantiated.
component add_sub is
port(
    A:  in std_logic_vector(3 downto 0);
    B:   in std_logic_vector(3 downto 0);
    sel: in std_logic;
    over_flow: out std_logic;
    under_flow: out std_logic;
    clock: in std_logic;
    O:  out std_logic_vector(3 downto 0)
    );
end component;
  --  Specifies which entity is bound with the component.
  -- for shift_reg_0: add_sub use entity work.mux(rtl);
  signal a, b, o :std_logic_vector(3 downto 0);
  signal sel, over, under, clock: std_logic;
begin
  --  Component instantiation.
  add_sub_0: add_sub
  port map (
  A => a,
  B => b,
  sel => sel ,
  over_flow => over,
  under_flow  => under,
  clock => clock,
  O => o
  );

  --  This process does the real job.
  process
  type pattern_type is record
    --  The inputs and output of the add_sub.
    a: std_logic_vector(3 downto 0);
    b: std_logic_vector(3 downto 0);
    sel, clock, over, under: std_logic;
    o: std_logic_vector(3 downto 0);
  end record;
  --  The patterns to apply.
  type pattern_array is array (natural range <>) of pattern_type;
  constant patterns : pattern_array := (
  ("0000", "0000", '0', '0', 'U', 'U', "UUUU" ),
  ("0001", "0000", '0', '1', '0', '0', "0001" ),
  ("0001", "0001", '0', '1', '0', '0', "0010" ),
  ("0010", "0001", '0', '1', '0', '0', "0011" ),
  ("0010", "0010", '0', '1', '0', '0', "0100" ),
  ("0011", "0011", '0', '1', '0', '0', "0110" ),
  ("0100", "0011", '0', '1', '0', '0', "0111" ),
  ("0100", "0100", '0', '1', '1', '0', "1000" ),
  ("0101", "0011", '0', '1', '1', '0', "1000" ),
  ("0101", "0111", '0', '1', '1', '0', "1100" ),
  ("0110", "0100", '0', '1', '1', '0', "1010" ),
  ("0110", "0110", '0', '1', '1', '0', "1100" ),
  ("0111", "0000", '0', '1', '0', '0', "0111" ),
  ("0111", "0001", '0', '1', '1', '0', "1000" ),
  ("1001", "0001", '0', '1', '0', '0', "1010" ),
  ("1001", "1001", '0', '1', '1', '0', "0010" ),
  ("1010", "0001", '0', '1', '0', '0', "1011" ),
  ("1010", "1010", '0', '1', '1', '0', "0100" ),
  ("1011", "0100", '0', '1', '0', '0', "1111" ),
  ("1011", "1001", '0', '1', '1', '0', "0100" ),
  ("1100", "0011", '0', '1', '0', '0', "1111" ),
  ("1100", "1100", '0', '1', '0', '0', "1000" ),
  ("1101", "0010", '0', '1', '0', '0', "1111" ),
  ("1101", "1000", '0', '1', '1', '0', "0101" ),
  ("1110", "0001", '0', '1', '0', '0', "1111" ),
  ("1110", "1110", '0', '1', '0', '0', "1100" ),
  ("1111", "0001", '0', '1', '0', '0', "0000" ),
  ("1111", "1111", '0', '1', '0', '0', "1110" ),
  ("0000", "0000", '0', '1', '0', '0', "0000" ),
  ("1000", "0001", '0', '0', '0', '0', "0000" ),
  ("1000", "1000", '0', '0', '0', '0', "0000" ),
  ("0001", "0001", '0', '0', '0', '0', "0000" ),
  -- Output
  ("0000", "0000", '1', '0', '0', '0', "0000" ),
  ("0001", "0000", '1', '1', '0', '0', "0001" ),
  ("0001", "0001", '1', '1', '0', '0', "0000" ),
  ("0010", "0001", '1', '1', '0', '0', "0001" ),
  ("0010", "0010", '1', '1', '0', '0', "0000" ),
  ("0011", "0011", '1', '1', '0', '0', "0000" ),
  ("0100", "0011", '1', '1', '0', '0', "0001" ),
  ("0100", "0100", '1', '1', '0', '0', "0000" ),
  ("0101", "0011", '1', '1', '0', '0', "0010" ),
  ("0101", "0111", '1', '1', '0', '0', "1110" ),
  ("0110", "0100", '1', '1', '0', '0', "0010" ),
  ("0110", "0110", '1', '1', '0', '0', "0000" ),
  ("0111", "0000", '1', '1', '0', '0', "0111" ),
  ("0111", "0001", '1', '1', '0', '0', "0110" ),
  ("1001", "0001", '1', '1', '0', '0', "1000" ),
  ("1001", "1001", '1', '1', '0', '0', "0000" ),
  ("1010", "0001", '1', '1', '0', '0', "1001" ),
  ("1010", "1010", '1', '1', '0', '0', "0000" ),
  ("1011", "0100", '1', '1', '0', '1', "0111" ),
  ("1011", "1001", '1', '1', '0', '0', "0010" ),
  ("1100", "0011", '1', '1', '0', '0', "1001" ),
  ("1100", "1100", '1', '1', '0', '0', "0000" ),
  ("1101", "0010", '1', '1', '0', '0', "1011" ),
  ("1101", "1000", '1', '1', '0', '0', "0101" ),
  ("1110", "0001", '1', '1', '0', '0', "1101" ),
  ("1110", "1110", '1', '1', '0', '0', "0000" ),
  ("1111", "0001", '1', '1', '0', '0', "1110" ),
  ("1111", "1111", '1', '1', '0', '0', "0000" ),
  ("0000", "0000", '1', '1', '0', '0', "0000" ),
  ("1000", "0001", '1', '0', '0', '0', "0000" ),
  ("1000", "1000", '1', '0', '0', '0', "0000" ),
  ("0001", "0001", '1', '0', '0', '0', "0000" )
);
  begin
    --  Check each pattern.
    for n in patterns'range loop
      --  Set the inputs.
      a <= patterns(n).a;
      b <= patterns(n).b;
      sel <= patterns(n).sel;
      --  Wait for the results.
      wait for 1 ps;
      clock <= patterns(n).clock;
      wait for 499 ps;
      --  Check the outputs.
      assert o = patterns(n).o report "bad output value" severity error;
      assert over = patterns(n).over report "bad over value" severity error;
      assert under = patterns(n).under report "bad under value" severity error;
      clock <= '0';
      wait for 500 ps;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
