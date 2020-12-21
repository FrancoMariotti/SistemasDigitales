library IEEE;
use IEEE.std_logic_1164.all;

entity regNb_tb is
end;

architecture regNb_tb_arq of regNb_tb is
	component regNb is
		generic(
			N: natural := 4
		);
		port(
			D_i:	in	std_logic_vector(N-1 downto 0);
			rst_i:	in	std_logic;
			clk_i:	in	std_logic;
			Q_o:	out	std_logic_vector(N-1 downto 0)
		);
	end component;
	
	constant N_tb: natural := 4;
	
	signal D_tb : std_logic_vector(N_tb-1 downto 0);
	signal clk_tb : std_logic;
	signal rst_tb : std_logic;
	signal Q_tb : std_logic_vector(N_tb-1 downto 0);
	
begin
	rst_tb 	<= '0', '1' after 30 ns, '0' after 50 ns;
	D_tb 	<= "0000", "1001" after 70 ns, "1101" after 100 ns;
	clk_tb 	<= '0', '1' after 85 ns, '0' after 95 ns, '1' after 110 ns, '0' after 120 ns;
	DUT: regNb
		generic map(
			N => N_tb
		)
		port map(
			D_i		=>	D_tb,
			rst_i	=>	rst_tb,
			clk_i	=>	clk_tb,
			Q_o		=>	Q_tb
		);

end regNb_tb_arq;