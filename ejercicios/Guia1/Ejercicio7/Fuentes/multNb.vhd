library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--multiplicador sin signo generico de N bits.
entity mulNb is
	generic( N: natural := 4);
	port(
		a_i: 	in 	std_logic_vector(N-1 downto 0);
		b_i: 	in 	std_logic_vector(N-1 downto 0);
		s_o: 	out std_logic_vector(2*N-1 downto 0)
	);
end;

architecture mulNb_arq of mulNb is
begin 
	s_o <= std_logic_vector(signed(a_i) * signed(b_i));
end mulNb_arq;