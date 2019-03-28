library ieee;
use ieee.std_logic_1164.all;

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
  over_flow <= carry(N);
  carry(0) <= '0';
  process(B, sel)
    begin
    if sel = '0' then
      mux <= B;
    else 
      mux <= not B;
    end if;
  end process;
  process is
  begin
    wait until (rising_edge(clock));
      O <= output;
  end process;
end behav;

