library IEEE;
use IEEE.std_logic_1164.all;

entity regNb is
	generic(
		N: natural := 4
	);
	port(
		D_i:	in	std_logic_vector(N-1 downto 0);
		rst_i:	in	std_logic;
		clk_i:	in	std_logic;
		Q_o:	out	std_logic_vector(N-1 downto 0)
	);
end entity regNb;


architecture regNb_arq of regNb is
	component ffd is
		port(
			D_i:	in	std_logic;
			rst_i:	in 	std_logic;
			clk_i:	in	std_logic;
			Q_o:	out	std_logic
		);
	end component;
begin
	regNb_generator: 
		for i in 0 to N-1 generate
			reg1b_inst:	ffd
				port map(
					D_i	=>	D_i(i),
					rst_i 	=>	rst_i,
					clk_i 	=>	clk_i,
					Q_o	=>	Q_o(i)
				);
		end generate;
end regNb_arq;
