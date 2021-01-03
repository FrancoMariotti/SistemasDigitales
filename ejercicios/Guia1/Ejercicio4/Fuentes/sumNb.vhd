library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--sumador generico de N bits.
entity sumNb is
	generic( N: natural := 4);
	port(
		a_i: 	in std_logic_vector(N-1 downto 0);
		b_i: 	in std_logic_vector(N-1 downto 0);
		ci_i: 	in std_logic;
		s_o: 	out std_logic_vector(N-1 downto 0);
		co_o: 	out std_logic
	);
end;


architecture sumNb_arq of sumNb is
	signal res: std_logic_vector(N+1 downto 0);
begin
	res 	<= std_logic_vector(unsigned('0' & a_i & ci_i) + unsigned('0' & b_i & '1'));
	s_o		<= res(N downto 1);
	co_o 	<= res(N+1);
end sumNb_arq;
