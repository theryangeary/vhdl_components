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
--signal input1, input2, D1, D2, Q1, Q2, left1, left2, right1, right2: std_logic_vector(3 downto 0);
  signal in_left, in_right, out_left, out_right: std_logic_vector(3 downto 0);
  signal ishr, ishl: std_logic;
begin

  left_shifter: entity work.shift_reg
    port map(
        I => I(7 downto 4),
        I_SHIFT_IN => ishl,
        sel => sel,
        clock => clock,
        enable => enable,
        O => out_left
      );

  right_shifter: entity work.shift_reg
    port map(
        I => I(3 downto 0),
        I_SHIFT_IN => ishr,
        sel => sel,
        clock => clock,
        enable => enable,
        O => out_right
      );

    process (sel, out_right, out_left, I_SHIFT_IN)
    begin
      if (sel(1) = '0') then
        ishl <= out_right(3);
        ishr <= I_SHIFT_IN;
      else
        ishl <= I_SHIFT_IN;
        ishr <= out_left(0);
      end if;
    end process;

  O <= out_left & out_right;

end behav;

