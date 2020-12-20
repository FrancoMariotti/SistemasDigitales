library IEEE;
use IEEE.std_logic_1164.all;

--sumador sin signo generico de N bits.
entity sumNb_tb is
end;

architecture sumNb_tb_arq of sumNb_tb is
	constant N_tb: natural := 4;
	
	component sumNb is
		generic( N: natural := 4);
		port(
			a_i: 	in std_logic_vector(N-1 downto 0);
			b_i: 	in std_logic_vector(N-1 downto 0);
			ci_i: 	in std_logic;
			s_o: 	out std_logic_vector(N-1 downto 0);
			co_o: 	out std_logic
		);
	end component;
	
	signal a_tb: std_logic_vector(N_tb-1 downto 0) := "0010";
	signal b_tb: std_logic_vector(N_tb-1 downto 0) := "1100";
	signal ci_tb: std_logic := '0';
	
	signal s_tb: std_logic_vector(N_tb-1 downto 0);
	signal co_tb: std_logic;
begin
	ci_tb <= '1' after 100 ns, '0' after 200 ns;
	a_tb  <= "0011" after 100 ns, "0101" after 200 ns, "1010" after 300 ns;
	b_tb  <= "0001" after 200 ns, "0110" after 300 ns;
	
	DUT: sumNb
	generic map(
		N => N_tb
	)
	port map(
		a_i 	=> a_tb,
		b_i 	=> b_tb,
		ci_i 	=> ci_tb,
		s_o 	=> s_tb,
		co_o 	=> co_tb
	);
end sumNb_tb_arq;