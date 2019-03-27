library ieee;
use ieee.std_logic_1164.all;

entity shift_reg_8 is
generic(
    N: integer:= 7
    );
port(
    I:  in std_logic_vector (N downto 0); -- for loading
    I_SHIFT_IN: in std_logic; -- shifted in bit for both left and right
    sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
    clock:    in std_logic; -- positive level triggering in problem 3
    enable:    in std_logic; -- 0: don't do anything; 1: shift_reg_8 is enabled
    O:  out std_logic_vector(N downto 0) -- output the current register content
    );
end shift_reg_8;

architecture behav of shift_reg_8 is
signal input1, input2, D1, D2, Q1, Q2, left1, left2, right1, right2: std_logic_vector(3 downto 0);
begin

  left1 <= Q1(2 downto 0) & I_SHIFT_IN;
  right1 <= Q2(0) & Q1(3 downto 1);
  left2 <= Q2(2 downto 0) & Q1(3);
  right2 <= I_SHIFT_IN & Q2(3 downto 1);
  O <= Q2 & Q1;
  input1 <= I(3 downto 0);
  input2 <= I(7 downto 4);

  mux1 : entity work.mux
    generic map(
        INLENGTH => 4)
    port map(
        A => Q1,
        B => left1,
        C => right1,
        D => input1,
        sel => sel,
        O => D1
      );

mux2 : entity work.mux
  generic map(
      INLENGTH => 4)
  port map(
      A => Q2,
      B => left2,
      C => right2,
      D => input2,
      sel => sel,
      O => D2
    );

  reg_process: process is
  begin
    wait until (rising_edge(clock));
    if (enable = '1') then
      if (sel = "11") then
        Q1 <= I(3 downto 0);
        Q2 <= I(7 downto 4);
      else
        Q1 <= D1;
        Q2 <= D2;
      end if;
    end if;
  end process;

end behav;

