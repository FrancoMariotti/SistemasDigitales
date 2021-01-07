library IEEE;
use IEEE.std_logic_1164.all;

entity genEna_tb is
end entity ; -- genEna_tb

architecture genEna_tb_arq of genEna_tb is
	component genEna is
		generic(
			N: natural := 5
		);
	 	port (
	 		clk_i: in std_logic;
	 		rst_i: in std_logic;
	 		ena_i: in std_logic;
	 		q_o: out std_logic
	 	) ;
	end component ; -- genEna

	constant N_tb: natural := 6;

	signal clk_tb: std_logic := '0';
	signal ena_tb: std_logic := '1';
	signal rst_tb: std_logic := '1';
	signal q_tb: std_logic;
begin

	clk_tb <= not(clk_tb) after 10 ns;
	rst_tb <= '0' after 50 ns;
	
	DUT: genEna
		generic map(
			N => N_tb
		)
		port map(
			clk_i	=> clk_tb,
	 		rst_i	=> rst_tb,
	 		ena_i	=> ena_tb,
	 		q_o		=> q_tb 
		);


end architecture ; -- genEna_tb_arq