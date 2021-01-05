library IEEE;
use IEEE.std_logic_1164.all;

entity regNb is
	generic(
		N: natural := 4
	);
	port(
		D_i:	in	std_logic_vector(N-1 downto 0);
		rst_i:	in	std_logic;
		ena_i:	in 	std_logic;
		clk_i:	in	std_logic;
		Q_o:	out	std_logic_vector(N-1 downto 0)
	);
end entity;


architecture regNb_arq of regNb is

begin

	process(clk_i, rst_i)

	begin
	
		if rst_i = '1' then
			Q_o <= (others => '0');
		elsif rising_edge(clk_i) then
			if ena_i = '1' then
				Q_o <= D_i;
			end if;
		end if;
 	end process;

end architecture;
