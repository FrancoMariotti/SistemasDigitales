library IEEE;
use IEEE.std_logic_1164.all;

--sumador generico de N bits.
entity sumNb is
	generic( N: natural := 4);
	port(
		a_i: 	in std_logic_vector(N-1 downto 0);
		b_i: 	in std_logic_vector(N-1 downto 0);
		ci_i: 	in std_logic;
		control:		in std_logic;
		s_o: 	out std_logic_vector(N-1 downto 0);
		co_o: 	out std_logic
	);
end;


architecture behavioural of sumNb is
	signal b_aux: signed(N+1 downto 0);
	signal s_aux: std_logic_vector(N+1 downto 0);
begin
	
	process( control )
	begin
		if control = '1' then
			b_aux <= signed(not b_i) + 1;
		else
			b_aux <= '0' & b_i & '1';
		end if ;
		
	end process ;
	
	s_aux <= std_logic_vector(unsigned('0' & a_i & ci_i) + b_aux);

	s_o <= s_aux(N downto 1);
	co_o <= s_aux(N+1);

end architecture ; -- behavioural