library IEEE;
use IEEE.std_logic_1164.all;

entity ffd is
	port(
		D_i:	in	std_logic;
		rst_i:	in 	std_logic;
		clk_i:	in	std_logic;
		Q_o:	out	std_logic
	);
end;

--flip-flop D con reset asincronico.
architecture ffd_arq of ffd is
begin
	process(clk_i,rst_i) is
	begin
		if rst_i = '1' then
			Q_o <= '0';
		elsif rising_edge(clk_i) then
			Q_o <= D_i;
		end if;
	end process;
end ffd_arq;