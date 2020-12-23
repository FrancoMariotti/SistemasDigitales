library IEEE;
use IEEE.std_logic_1164.all;

entity regd is
	generic( N: natural := 4);
	port(
		rst_i:		in 	std_logic;
		clk_i:		in	std_logic;
		D_i:		in 	std_logic;
		load_i:		in	std_logic;
		value_i:	in	std_logic_vector(N-1 downto 0);
		Q_o:		out std_logic_vector(N-1 downto 0)
	);
end;

architecture regd_arq of regd is
begin
	process (clk_i,load_i) is
	begin 
		if rising_edge(clk_i) then
			if	rst_i = '1' then 
				Q_o <= (others => '0');
			else if load_i = '1' then
				Q_o <= value_i;
			else
				Q_o(N-1 downto 1) <= aux(N-2 downto 0);
				Q_o(0) <= D_i;
			end if;
		end if;
	end process;
end regd_arq;