library IEEE;
use IEEE.std_logic_1164.all;


entity contadorNbits_lento_tb is
end entity ; -- contadorNbits_lento_tb

architecture contadorNbits_lento_tb_arq of contadorNbits_lento_tb is
	--Contador de N bits generico
	component contador_Nbits_lento is
		generic(
			N: natural := 4;
			M: natural := 4
		);
		port(
			clk_i:	in std_logic;
				rst_i:	in std_logic;
			ena_i:	in std_logic;
			q_o  :	out std_logic_vector(N-1 downto 0)
		);
	end component;

	constant N_tb: natural := 5;	
	constant M_tb: natural := 8;	

	signal clk_tb: std_logic := '0';
	signal ena_tb: std_logic := '1';
	signal rst_tb: std_logic := '1';
	signal q_tb: std_logic_vector(N_tb-1 downto 0);
begin

	clk_tb <= not(clk_tb) after 10 ns;
	rst_tb <= '0' after 50 ns;
	ena_tb <= '0' after  135 ns, '1' after 200 ns;

	DUT: contador_Nbits_lento
		generic map(
			N => N_tb,
			M => M_tb
		)
		port map(
			clk_i	=> clk_tb,
			rst_i	=> rst_tb,
			ena_i	=> ena_tb,
			q_o  	=> q_tb
		);

end architecture ; -- arch