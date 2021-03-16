library IEEE;
use IEEE.std_logic_1164.all;

--sumador generico de N bits.
entity sumNb is
	generic( N: natural := 4);
	port(
		a_i: 	in std_logic_vector(N-1 downto 0);
		b_i: 	in std_logic_vector(N-1 downto 0);
		control:	in std_logic;
		s_o: 	out std_logic_vector(N-1 downto 0);
		co_o: 	out std_logic
	);
end;


architecture sumNb_arq of sumNb is

	component sum1b is
		port(
			a_i	: in std_logic;
			b_i	: in std_logic;
			ci_i: in std_logic;
			s_o	: out std_logic;
			co_o: out std_logic
		);
	end component;

	signal c_aux: std_logic_vector(N downto 0);
	signal b_aux: std_logic_vector(N-1 downto 0);
	
begin

	c_aux(0) <= control;

	sumNbgen: for i in 0 to N-1 generate
			b_aux(i) <= b_i(i) xor control;

			sum1b_inst: sum1b
				port map(
					a_i		=> a_i(i),
					b_i		=> b_aux(i),
					ci_i	=> c_aux(i),
					s_o		=> s_o(i),
					co_o	=> c_aux(i+1)
				);
	end generate;
	
	co_o <= c_aux(N);


end;
