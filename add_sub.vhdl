library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
generic(
    N: integer:= 4
    );
port(
    A:  in std_logic_vector (N-1 downto 0); -- for loading
    B:   in std_logic_vector (N-1 downto 0); -- for loadin
    sel: in std_logic; -- 0 Add 1 Subtract
    clock:    in std_logic; -- positive level triggering in problem 3
    O:  out std_logic_vector(N-1 downto 0); -- output the current register content
    over_flow: out std_logic;
    under_flow: out std_logic
    );
end add_sub;

architecture behav of add_sub is
signal carry: std_logic_vector (N downto 0);
signal output: std_logic_vector(N-1 downto 0);
signal mux: std_logic_vector(N-1 downto 0);
begin

  adder_gen:
  for i in 0 to N-1 generate
    adder: entity work.full_adder
    port map(
      A => A(i),
      B => mux(i),
      carry_in => carry(i),
      carry_out => carry(i+1),
      O => output(i)
      );
  end generate adder_gen;

  carry(0) <= sel;
  mux(3) <= B(3) xor sel;
  mux(2) <= B(2) xor sel;
  mux(1) <= B(1) xor sel;
  mux(0) <= B(0) xor sel;
  process is
  begin
    wait until (rising_edge(clock));
      O <= output;
      if (sel = '0') then
        over_flow <= carry(N) xor carry(N-1);
        under_flow <= '0';
      else
        over_flow <= '0';
        under_flow <= carry(N) xor carry(N-1);
      end if;
  end process;
end behav;

