library IEEE;
use IEEE.std_logic_1164.all;

entity regd is
	generic( N: natural := 4);
	port(
		ena_i:		in std_logic;
		rst_i:		in 	std_logic;
		clk_i:		in	std_logic;
		D_i:		in 	std_logic;
		load_i:		in	std_logic;
		value_i:	in	std_logic_vector(N-1 downto 0);
		Q_o:		out std_logic_vector(N-1 downto 0)
	);
end;

architecture regd_arq of regd is
	signal aux: std_logic_vector(N-1 downto 0);
begin
	process (clk_i,rst_i,load_i) is	
	begin 
		if rst_i = '1' then 
			aux <= (others => '0');
		elsif rising_edge(clk_i) and ena_i = '1' then
			if load_i = '1' then
				aux <= value_i;
			else
				aux(N-1 downto 1) <= aux(N-2 downto 0);
				aux(0) <= D_i;
			end if;
		end if;
	end process;
	
	Q_o <= aux;
end regd_arq;