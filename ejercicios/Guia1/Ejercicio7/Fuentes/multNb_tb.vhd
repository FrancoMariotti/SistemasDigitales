library IEEE;
use IEEE.std_logic_1164.all;

entity mulNb_tb is
end;


architecture mulNb_tb_arq of mulNb_tb is
	component mulNb is
		generic( N: natural := 4);
		port(
			a_i: 	in std_logic_vector(N-1 downto 0);
			b_i: 	in std_logic_vector(N-1 downto 0);
			s_o: 	out std_logic_vector(2*N-1 downto 0)
		);
	end component;
	
	constant N_tb: natural := 4;
	
	signal a_tb: std_logic_vector(N_tb-1 downto 0);
	signal b_tb: std_logic_vector(N_tb-1 downto 0);
	signal s_tb: std_logic_vector(2*N_tb-1 downto 0);
begin 
	--a_tb <= "0010", "0101" after 10 ns, "1111" after 20 ns, "0000" after 30 ns;
	--b_tb <= "1001", "1110" after 10 ns, "1111" after 20 ns, "0000" after 30 ns;
	
	-- +2 +5 -1 -8
	a_tb <= "0010", "0101" after 10 ns, "1111" after 20 ns, "1000" after 30 ns,
	-- -8
	"1000" after 40 ns, "0000" after 50 ns;
	-- -7 -6 -1 +7
	b_tb <= "1001", "1010" after 10 ns, "1111" after 20 ns, "0111" after 30 ns,
	-- -8
	"1000" after 40 ns, "0000" after 50 ns;
	-- tb_y: -14 	-30 	+1 		-56 	-64
	-- 		1110010 1100010 0000001 1001000 1000000
	

	DUT: mulNb
	generic map(
		N => N_tb
	)
	port map(
		a_i => a_tb,
		b_i	=> b_tb,
		s_o => s_tb
	);
end mulNb_tb_arq;