library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;

entity logic_gates is
    port(
        a_i: in std_logic;
        b_i: in std_logic;
        and_o: out std_logic;
		or_o: out std_logic;
		xor_o: out std_logic
    );
end;

architecture logic_gates_arq of logic_gates is
    --parte declarativa
begin
    --parte descriptiva
    and_o <= a_i and b_i;
	or_o <= a_i or b_i;
	xor_o <= a_i xor b_i;
end logic_gates_arq;