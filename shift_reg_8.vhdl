library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
generic(
    N: integer:= 3
    );
port(
    I:  in std_logic_vector (N downto 0); -- for loading
    I_SHIFT_IN: in std_logic; -- shifted in bit for both left and right
    sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
    clock:    in std_logic; -- positive level triggering in problem 3
    enable:    in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
    O:  out std_logic_vector(N downto 0) -- output the current register content
    );
end shift_reg;

architecture behav of shift_reg is
signal input, D, Q, left, right: std_logic_vector(N downto 0);
begin

  left <= Q(2 downto 0) & I_SHIFT_IN;
  right <= I_SHIFT_IN & Q(3 downto 1);
  O <= Q;
  input <= I;

  mux1 : entity work.mux
    generic map(
        INLENGTH => 4)
    port map(
        A => Q,
        B => left,
        C => right,
        D => input,
        sel => sel,
        O => D
      );

  reg_process: process is
  begin
    wait until (rising_edge(clock));
    if (enable = '1') then
      if (sel = "11") then
        Q <= I;
      else
        Q <= D;
      end if;
    end if;
  end process;

end behav;

