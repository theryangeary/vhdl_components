library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity shift_reg_8_tb is
  end shift_reg_8_tb;

architecture behav of shift_reg_8_tb is
--  Declaration of the component that will be instantiated.
  component shift_reg_8
    port ( I:  in std_logic_vector (7 downto 0);
           I_SHIFT_IN: in std_logic;
           sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
           clock:    in std_logic;
           enable:    in std_logic;
           O:  out std_logic_vector(7 downto 0)
         );
  end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_8_0: shift_reg_8 use entity work.shift_reg_8(rtl);
  signal i, o : std_logic_vector(7 downto 0);
  signal i_shift_in, clk, enable : std_logic;
  signal sel : std_logic_vector(1 downto 0);
begin
--  Component instantiation.
  shift_reg_8_0: shift_reg_8 port map (I => i, I_SHIFT_IN => i_shift_in, sel => sel, clock => clk, enable => enable, O => o);

  --  This process does the real job.
  process
  type pattern_type is record
    i: std_logic_vector (7 downto 0);
    i_shift_in: std_logic;
    clock: std_logic;
    enable: std_logic;
    sel: std_logic_vector(1 downto 0);
    o: std_logic_vector (7 downto 0);
  end record;
  --  The patterns to apply.
  type pattern_array is array (natural range <>) of pattern_type;
  constant patterns : pattern_array :=
  (
  ("00000001", '1', '0', '0', "11", "UUUUUUUU"),
  ("00100001", '0', '1', '1', "11", "00100001"),
  ("00000011", '0', '1', '0', "11", "00100001"),
  ("00000011", '0', '0', '1', "11", "00100001"),

  ("00000000", '0', '0', '0', "00", "00100001"),
  ("00000001", '0', '1', '0', "00", "00100001"),
  ("00000001", '0', '0', '1', "00", "00100001"),
  ("00000010", '0', '1', '1', "00", "00100001"),
  ("00000010", '1', '0', '0', "00", "00100001"),
  ("00000100", '1', '1', '0', "00", "00100001"),
  ("00000100", '1', '0', '1', "00", "00100001"),
  ("00001000", '1', '1', '1', "00", "00100001"),
  ("00000000", '0', '0', '0', "01", "00100001"),
  ("00000000", '0', '1', '0', "01", "00100001"),
  ("00000000", '0', '0', '1', "01", "00100001"),
  ("00000101", '0', '1', '1', "01", "01000010"),
  ("00000011", '1', '0', '0', "01", "01000010"),
  ("00000011", '1', '1', '0', "01", "01000010"),
  ("00000011", '1', '0', '1', "01", "01000010"),
  ("00000011", '1', '1', '1', "01", "10000101"),
  ("00000000", '0', '0', '0', "10", "10000101"),
  ("00000000", '0', '1', '0', "10", "10000101"),
  ("00000000", '0', '0', '1', "10", "10000101"),
  ("00000000", '0', '1', '1', "10", "01000010"),
  ("00000000", '1', '0', '0', "10", "01000010"),
  ("00000000", '1', '1', '0', "10", "01000010"),
  ("00000000", '1', '0', '1', "10", "01000010"),
  ("00000000", '1', '1', '1', "10", "10100001"),
  ("00000000", '0', '0', '0', "11", "10100001"),
  ("00000000", '0', '1', '0', "11", "10100001"),
  ("00000000", '0', '0', '1', "11", "10100001"),
  ("00100011", '0', '1', '1', "11", "00100011"),
  ("00000000", '1', '0', '0', "11", "00100011"),
  ("00000000", '1', '1', '0', "11", "00100011"),
  ("00000000", '1', '0', '1', "11", "00100011"),
  ("01001010", '1', '1', '1', "11", "01001010")
  );
  begin
--  Check each pattern.
    for n in patterns'range loop
--  Set the inputs.
      i <= patterns(n).i;
      i_shift_in <= patterns(n).i_shift_in;
      clk <= patterns(n).clock;
      enable <= patterns(n).enable;
      sel <= patterns(n).sel;
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
