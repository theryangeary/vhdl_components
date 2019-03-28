library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
port(
    A:  in std_logic;
    B:   in std_logic;
    carry_in: in std_logic; -- 0 Add 1 Subtract
    O:  out std_logic;
    carry_out: out std_logic
    );
end full_adder;

architecture behav of full_adder is
  signal sum: std_logic;
  begin
    sum <= A xor B;
    O <= sum xor carry_in; 
    carry_out <= (A and B) or (sum and carry_in);

end behav;

