library IEEE;
use IEEE.std_logic_1164.all;

entity contador_tb is
end;


architecture contador_tb_arq of contador_tb is
	component contador is
		generic( N: natural := 4);
		port(
			load_i:		in std_logic;
			count_i:	in	std_logic_vector(N-1 downto 0);
			rst_i:		in	std_logic;
			clk_i:		in	std_logic;
			s_o:		out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	constant N_tb: natural := 4;
	
	signal clk_tb:		std_logic := '0';
	signal rst_tb:		std_logic;
	signal load_tb:		std_logic;
	signal count_tb:	std_logic_vector(N_tb-1 downto 0) := "1000";
	signal s_tb: 		std_logic_vector(N_tb-1 downto 0);
begin
	rst_tb 	<= '1', '0' after 10 ns;
	clk_tb 	<= not clk_tb after 10 ns;
	load_tb <= '0','1' after 60 ns, '0' after 80 ns;
	
	DUT: contador
		generic map(
			N => N_tb
		)
		port map(
			load_i 	=> load_tb,
			count_i => count_tb,
			rst_i	=> rst_tb,
			clk_i	=> clk_tb,
			s_o		=> s_tb
		);
end contador_tb_arq;