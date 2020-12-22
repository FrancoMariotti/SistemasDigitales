library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador is
	generic( N: natural := 4);
	port(
		rst_i:		in	std_logic;
		clk_i:		in	std_logic;
		ena_i:		in 	std_logic;
		load_i:		in 	std_logic;
		value_i:	in 	std_logic_vector(N-1 downto 0);
		s_o:		out std_logic_vector(N-1 downto 0)
	);
end;


architecture contador_arq of contador is
	signal count: unsigned(N-1 downto 0);	
begin
	process(clk_i,rst_i,load_i,ena_i) is
	begin
		if rst_i = '1' then
			count <= (others => '0');
		elsif rising_edge(clk_i) and ena_i = '1' then
			if	load_i = '1' then 
				count <= unsigned(value_i);
			else
				count <= count + 1;	
			end if;
		end if;
	end process;
	
	s_o <= std_logic_vector(count);
end contador_arq;