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
	--a_tb <= "00010" after 100 ns,"00001" after 200 ns;
	--b_tb <= "00011" after 100 ns,"01000" after 200 ns;
	
	--tb_x0 <= "0010", "0101" after 10 ns, "1111" after 20 ns, "0000" after 30 ns;
	--tb_x1 <= "1001", "1110" after 10 ns, "1111" after 20 ns, "0000" after 30 ns;
	a_tb <= "0010", "0101" after 10 ns, "1111" after 20 ns, "0000" after 30 ns;
	b_tb <= "1001", "1110" after 10 ns, "1111" after 20 ns, "0000" after 30 ns;

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