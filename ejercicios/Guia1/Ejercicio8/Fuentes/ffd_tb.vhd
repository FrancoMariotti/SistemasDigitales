library IEEE;
use IEEE.std_logic_1164.all;

entity ffd_tb is
end;

architecture ffd_tb_arq of ffd_tb is
	component ffd is
		port(
			D_i:	in	std_logic;
			rst_i:	in 	std_logic;
			clk_i:	in	std_logic;
			set_i:	in	std_logic;
			Q_o:	out	std_logic
		);
	end component;
	
	signal d_tb:	std_logic;
	signal rst_tb:	std_logic;
	signal clk_tb:	std_logic;
	signal q_tb:	std_logic;
	
	
begin
	d_tb <= '1', '0' after 10 ns, '1' after 20 ns;
	clk_tb <= '0', '1' after 5 ns, '0' after 10 ns, 
	'1' after 15 ns, '0' after 20 ns,'1' after 25 ns, '0' after 30 ns,'1' after 35 ns;
	rst_tb <= '0', '1' after 27 ns;
	
	DUT: entity work.ffd(ffd_arq_2)
	port map(
		D_i		=>	d_tb,
		rst_i	=>	rst_tb,
		clk_i	=>	clk_tb,
		Q_o		=>	q_tb
	);
end ffd_tb_arq;