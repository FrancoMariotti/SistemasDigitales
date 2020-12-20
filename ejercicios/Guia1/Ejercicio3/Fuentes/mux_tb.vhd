library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_tb is
end;

architecture mux_tb_arq of mux_tb is
	component mux is
	generic(N:natural:= 4);
	port(
		x0:   in std_logic_vector(N-1 downto 0);
		x1:   in std_logic_vector(N-1 downto 0);
		x2:   in std_logic_vector(N-1 downto 0);
		x3:   in std_logic_vector(N-1 downto 0);
		sel:  in std_logic_vector(1 downto 0);
		sal:  out std_logic_vector(N-1 downto 0)
	);
	end component;		
	
	constant N_tb: natural := 8;
	
	signal x0_tb: std_logic_vector(N_tb-1 downto 0) :=	std_logic_vector(to_unsigned(0,N_tb));
	signal x1_tb: std_logic_vector(N_tb-1 downto 0) :=  std_logic_vector(to_unsigned(22,N_tb));
	signal x2_tb: std_logic_vector(N_tb-1 downto 0) :=  std_logic_vector(to_unsigned(64,N_tb));
	signal x3_tb: std_logic_vector(N_tb-1 downto 0) :=  std_logic_vector(to_unsigned(32,N_tb));
	signal sal_tb: std_logic_vector(N_tb-1 downto 0);
	
	signal sel_tb: std_logic_vector(1 downto 0);
begin
	sel_tb <= "00", "01" after 100 ns, "10" after 200 ns, "11" after 300 ns;
	DUT: mux
		generic map(
			N => N_tb
		)
		port map(
			x0 	=> 	x0_tb,
			x1 	=> 	x1_tb,
			x2	=> 	x2_tb,
			x3 	=> 	x3_tb,
			sel => 	sel_tb,
			sal => 	sal_tb
		);
end mux_tb_arq;
