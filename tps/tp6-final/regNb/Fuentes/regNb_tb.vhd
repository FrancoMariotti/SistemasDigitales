library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regNb_tb is
end entity ; -- regNb_tb

architecture regNb_tb_arq of regNb_tb is
	component regNb is
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
	end component;

	constant N_tb:	natural := 8;
	signal D_tb:	std_logic_vector(N_tb-1 downto 0) := std_logic_vector(to_unsigned(33,N_tb));
	signal Q_tb:	std_logic_vector(N_tb-1 downto 0);
	signal ena_tb:	std_logic := '1';
	signal clk_tb:	std_logic := '0';
	signal rst_tb:	std_logic;

begin
	rst_tb	<= '1', '0' after 20 ns;
	clk_tb	<= not clk_tb after 10 ns;
	ena_tb	<= not ena_tb after 65 ns;
	D_tb	<= std_logic_vector(to_unsigned(145,N_tb)) after 40 ns, 
				std_logic_vector(to_unsigned(200,N_tb)) after 70 ns;  

	DUT: regNb
		generic map(
			N => N_tb
		)
		port map(
			D_i		=> D_tb,
			rst_i	=> rst_tb,
			ena_i	=> ena_tb,
			clk_i	=> clk_tb,
			Q_o		=> Q_tb
		);

end architecture ; -- arch