library IEEE;
use IEEE.std_logic_1164.all;

entity regd_tb is
end;

architecture regd_tb_arq of regd_tb is
	component regd is
		generic( N: natural := 4);
		port(
			rst:	in 	std_logic;
			clk:	in	std_logic;	
			D:		in 	std_logic;
			Q:		out std_logic
		);
	end component;
	
	constant N_tb: natural := 4;
	
	signal clk_tb:		std_logic := '0';
	signal rst_tb:		std_logic := '0';
	signal D_tb:		std_logic := '0';
	signal Q_tb: 		std_logic;
begin
	D_tb 	<=	not D_tb after 20 ns;
	rst_tb 	<= '1', '0' after 10 ns;
	clk_tb 	<=	not clk_tb after 5 ns;
	
	DUT: regd
		generic map(
			N => N_tb
		)
		port map(
			rst	=> 	rst_tb,
			clk	=> 	clk_tb,
			D	=>	D_tb,
			Q 	=> 	Q_tb
		);
end regd_tb_arq;