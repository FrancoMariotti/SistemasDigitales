library IEEE;
use IEEE.std_logic_1164.all;

entity regd is
	generic( N: natural := 4);
	port(
		rst:	in 	std_logic;
		clk:	in	std_logic;	
		D:		in 	std_logic;
		Q:		out std_logic
	);
end;

architecture regd_arq of regd is
	component ffd is
		port(
			D_i:	in	std_logic;
			rst_i:	in 	std_logic;
			clk_i:	in	std_logic;
			Q_o:	out	std_logic
		);
	end component;
	
	signal aux:	std_logic_vector(N downto 0);
begin
	aux(0) <= D;
	
	regdNb_generator: 
		for i in 0 to N - 1 generate
			ffd_inst: ffd
				port map(
					D_i		=>	aux(i),
					rst_i 	=>	rst,
					clk_i 	=>	clk,
					Q_o		=>	aux(i+1)
				);
		end generate;
	
	Q <= aux(N);
end regd_arq;