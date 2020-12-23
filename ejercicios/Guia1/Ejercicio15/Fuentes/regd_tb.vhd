library IEEE;
use IEEE.std_logic_1164.all;

entity regd_tb is
end;

architecture regd_tb_arq of regd_tb is
	component regd is
		generic( N: natural := 4);
		port(
			rst_i:		in 	std_logic;
			clk_i:		in	std_logic;
			D_i:		in 	std_logic;
			load_i:		in	std_logic;
			value_i:	in	std_logic_vector(N-1 downto 0);
			Q_o:		out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	constant N_tb: natural := 4;
	
	signal clk_tb:		std_logic := '0';
	signal rst_tb:		std_logic := '0';
	signal D_tb:		std_logic := '0';
	signal load_tb:		std_logic := '0';
	signal value_tb: 	std_logic_vector(N_tb-1 downto 0) := "0010";
	signal Q_tb: 		std_logic_vector(N_tb-1 downto 0);
begin
	D_tb 	<=	not D_tb after 20 ns;
	rst_tb 	<= 	'1', '0' after 10 ns;
	clk_tb 	<=	not clk_tb after 5 ns;
	load_tb	<=	'0', '1' after 60 ns, '0' after 70 ns;
	
	DUT: regd
		generic map(
			N => N_tb
		)
		port map(
			rst_i	=> 	rst_tb,
			clk_i	=> 	clk_tb,
			D_i		=>	D_tb,
			load_i 	=> 	load_tb,
			value_i	=> 	value_tb,
			Q_o		=> 	Q_tb
		);
end regd_tb_arq;