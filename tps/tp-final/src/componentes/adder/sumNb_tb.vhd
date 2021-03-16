library IEEE;
use IEEE.std_logic_1164.all;


entity sumNb_tb is
end entity ; -- sumNb_tb

architecture behavioural of sumNb_tb is
	constant N_tb: natural := 4;

	signal a_tb: std_logic_vector(N_tb-1 downto 0);
	signal b_tb: std_logic_vector(N_tb-1 downto 0);
	signal s_tb: std_logic_vector(N_tb-1 downto 0);
	signal co_tb: std_logic;

	signal control_tb: std_logic := '0';

	component sumNb is
		generic( N: natural := 4);
		port(
			a_i: 	in std_logic_vector(N-1 downto 0);
			b_i: 	in std_logic_vector(N-1 downto 0);
			control:		in std_logic;
			s_o: 	out std_logic_vector(N-1 downto 0);
			co_o: 	out std_logic
		);
	end component;
begin
	
	a_tb <= "0100", "0100" after 10 ns;
	b_tb <= "0100", "0001" after 12 ns;

	control_tb <= not control_tb after 12 ns;

	DUT: sumNb 
		generic map( N => N_tb )
		port map (
			a_i => a_tb,
			b_i => b_tb,
			control => control_tb,
			s_o => s_tb,
			co_o => co_tb
		);


end architecture ; -- behavioural