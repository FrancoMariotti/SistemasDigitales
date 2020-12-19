library IEEE;
use IEEE.std_logic_1164.all;

entity mux_tb is
end;

architecture mux_tb_arq of mux_tb is
	component mux is
		port(
			x0:   in std_logic_vector(3 downto 0);
			x1:   in std_logic_vector(3 downto 0);
			x2:   in std_logic_vector(3 downto 0);
			x3:   in std_logic_vector(3 downto 0);
			sel:  in std_logic_vector(1 downto 0);
			sal:  out std_logic_vector(3 downto 0)
		);
	end component;
	
	signal x0_tb: std_logic_vector(3 downto 0) := "0000";
	signal x1_tb: std_logic_vector(3 downto 0) := "0001";
	signal x2_tb: std_logic_vector(3 downto 0) := "0100";
	signal x3_tb: std_logic_vector(3 downto 0) := "1000";
	signal sal_tb: std_logic_vector(3 downto 0);
	
	signal sel_tb: std_logic_vector(1 downto 0);
begin
	sel_tb <= "00", "01" after 100 ns, "10" after 200 ns, "11" after 300 ns;
	DUT: mux
		port map(
			x0 	=> 	x0_tb,
			x1 	=> 	x1_tb,
			x2	=> 	x2_tb,
			x3 	=> 	x3_tb,
			sel => 	sel_tb,
			sal => 	sal_tb
		);
end;
