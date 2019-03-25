library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity mux_tb is
  end mux_tb;

architecture behav of mux_tb is
  --  Declaration of the component that will be instantiated.
  component mux
    generic (
              N : integer:= 2;
              INLENGTH : integer:= 8); --Number of bits in select
    port (
           A: in std_logic_vector(INLENGTH-1 downto 0);
           B: in std_logic_vector(INLENGTH-1 downto 0);
           C: in std_logic_vector(INLENGTH-1 downto 0);
           D: in std_logic_vector(INLENGTH-1 downto 0);
           --I:  in std_logic_vector (INLENGTH*2**N-1 downto 0); -- for loading
           sel: in std_logic_vector(N-1 downto 0); -- Choose input
           O:  out std_logic_vector(INLENGTH-1 downto 0)); -- output the current register content
  end component;
  --  Specifies which entity is bound with the component.
  -- for shift_reg_0: mux use entity work.mux(rtl);
  signal a, b, c, d, o : std_logic_vector(7 downto 0);
  signal sel : std_logic_vector(1 downto 0);
begin
  --  Component instantiation.
  mux_0: mux
  port map (
             A => a,
             B => b,
             C => c,
             D => d,
             sel => sel,
             O => o);

  --  This process does the real job.
  process
  type pattern_type is record
    --  The inputs of the mux.
    a, b, c, d: std_logic_vector (7 downto 0);
    sel: std_logic_vector(1 downto 0);
    --  The expected outputs of the mux.
    o: std_logic_vector (7 downto 0);
  end record;
  --  The patterns to apply.
  type pattern_array is array (natural range <>) of pattern_type;
  constant patterns : pattern_array := (
  ("00000000", "00000001", "00000010", "00000011", "00", "00000000"),
  ("00000000", "00000001", "00000010", "00000011", "01", "00000001"),
  ("00000000", "00000001", "00000010", "00000011", "10", "00000010"),
  ("00000000", "00000001", "00000010", "00000011", "11", "00000011")
);
  begin
    --  Check each pattern.
    for n in patterns'range loop
      --  Set the inputs.
      a <= patterns(n).a;
      b <= patterns(n).b;
      c <= patterns(n).c;
      d <= patterns(n).d;
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
